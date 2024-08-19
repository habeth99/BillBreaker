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
    @StateObject var transformer = ReceiptProcessor()
    
    var body: some View {
        ZStack {
            CameraView(model: model)
            
            //^need import photo ability and that will probably be done in CameraView ^
            
            Color.white
                .opacity(isFlashing ? 0.6 : 0)
                .animation(.easeInOut(duration: 0.2), value: isFlashing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button(action: takePhotoWithFlash) {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 70, height: 70)
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
                router.navigateToItemsScanView(ScanRoute.items)
                Task { @MainActor in
                    await transformer.transformReceipt(apiReceipt: model.processedReceipt)
                    model.isProcessingComplete = false // Reset for next use
                }
            }
        }
        .onChange(of: model.isProcessing) { newValue in
            showingProgress = newValue
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Back") {
            router.path.removeLast()
        })
    }
    
    private func takePhotoWithFlash() {
        isFlashing = true
        model.camera.takePhoto()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFlashing = false
        }
    }
}
