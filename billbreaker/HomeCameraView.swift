//
//  HomeCamerView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/2/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct HomeCameraView: View {
    @StateObject private var model = DataModel()
    @EnvironmentObject var router: Router
    @State private var isFlashing = false
    @State private var showingProgress = false
    @ObservedObject var transformer: ReceiptProcessor
    @State private var selectedItem: PhotosPickerItem?
    
    
    var body: some View {
        ZStack {
            
            if model.showFullScreenImage, let image = model.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
            } else {
                CameraView(model: model)
            }
            
            Color.white
                .opacity(isFlashing ? 0.6 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFlashing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            await processSelectedItem(newItem)
                        }
                    }
                    
                    Button(action: takePhotoWithFlash) {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 70, height: 70)
                    }
                    .padding(.horizontal, FatCheckTheme.Spacing.xxl)
                    Spacer()
                }
                .padding(FatCheckTheme.Spacing.xxl)
            }
            .padding()
            
            if showingProgress {
                ProgressBarView()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(
            Button(action: {
                router.dismissCamera()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            },
            alignment: .topLeading
        )
        .task {
            await model.camera.start()
            await model.loadPhotos()
            await model.loadThumbnail()
        }
        .onChange(of: model.isProcessingComplete) { completed in
            if completed {
                Task { @MainActor in
                    await transformer.transformReceipt(apiReceipt: model.processedReceipt)
                    router.isScanFlowActive = true
                    router.scanPath = [] // Clear the path
                    model.isProcessingComplete = false // Reset for next use
                    router.dismissCamera()
                }
            }
        }
        .onChange(of: model.isProcessing) { newValue in
            showingProgress = newValue
        }
    }
    
    private func takePhotoWithFlash() {
        isFlashing = true
        model.camera.takePhoto()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFlashing = false
        }
    }
    
    private func processSelectedItem(_ item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    model.importPhoto(image: uiImage)
                    model.capturedImage = uiImage
                    model.showFullScreenImage = true
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
//struct HomeCameraView: View {
//    @StateObject private var model = DataModel()
//    @EnvironmentObject var router: Router
//    @State private var isFlashing = false
//    @State private var showingProgress = false
//    @ObservedObject var transformer: ReceiptProcessor
//    @State private var selectedItem: PhotosPickerItem?
//
//    var body: some View {
//        ZStack {
//            if model.showFullScreenImage, let image = model.capturedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    //.aspectRatio(contentMode: .fit)
//                    .edgesIgnoringSafeArea(.all)
//            } else {
//                CameraView(model: model)
//            }
//
//            Color.white
//                .opacity(isFlashing ? 0.6 : 0)
//                .animation(.easeInOut(duration: 0.2), value: isFlashing)
//                .ignoresSafeArea()
//
//            if !model.showFullScreenImage {
//                VStack {
//                    Spacer()
//                    HStack {
//                        PhotosPicker(
//                            selection: $selectedItem,
//                            matching: .images,
//                            photoLibrary: .shared()) {
//                            Image(systemName: "photo.on.rectangle.angled")
//                                .font(.system(size: 30))
//                                .foregroundColor(.white)
//                        }
//                        .onChange(of: selectedItem) { newItem in
//                            Task {
//                                await processSelectedItem(newItem)
//                            }
//                        }
//
//                        Button(action: takePhotoWithFlash) {
//                            Circle()
//                                .stroke(Color.white, lineWidth: 3)
//                                .frame(width: 70, height: 70)
//                        }
//                        .padding(.horizontal, FatCheckTheme.Spacing.xxl)
//                        Spacer()
//                    }
//                    .padding(FatCheckTheme.Spacing.xxl)
//                }
//                .padding()
//            }
//
//            if showingProgress {
//                ProgressBarView()
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .overlay(
//            Button(action: {
//                if model.showFullScreenImage {
//                    model.showFullScreenImage = false
//                } else {
//                    router.dismissCamera()
//                }
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .padding()
//            },
//            alignment: .topLeading
//        )
//        .task {
//            await model.camera.start()
//            await model.loadPhotos()
//            await model.loadThumbnail()
//        }
//        .onChange(of: model.isProcessingComplete) { completed in
//            if completed {
//                Task { @MainActor in
//                    await transformer.transformReceipt(apiReceipt: model.processedReceipt)
//                    router.isScanFlowActive = true
//                    router.scanPath = [] // Clear the path
//                    model.isProcessingComplete = false // Reset for next use
//                    router.dismissCamera()
//                }
//            }
//        }
//        .onChange(of: model.isProcessing) { newValue in
//            showingProgress = newValue
//        }
//    }
//
//    private func takePhotoWithFlash() {
//        isFlashing = true
//        model.camera.takePhoto()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            isFlashing = false
//        }
//    }
//
//    private func processSelectedItem(_ item: PhotosPickerItem?) async {
//        guard let item = item else { return }
//
//        do {
//            if let data = try await item.loadTransferable(type: Data.self),
//               let uiImage = UIImage(data: data) {
//                await MainActor.run {
//                    model.importPhoto(image: uiImage)
//                    model.capturedImage = uiImage
//                    model.showFullScreenImage = true
//                }
//            }
//        } catch {
//            print("Error loading image: \(error)")
//        }
//    }
//}

