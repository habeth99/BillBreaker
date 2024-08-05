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
    //should this state object be an environmentObject var
    @StateObject private var model = DataModel()
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    @State private var showingReceiptDetail = false
    @State private var selectedPhotoData: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            CameraView(model: model)
            
            VStack {
                Spacer()
                // Camera button
                Button(action: {
                    model.camera.takePhoto()
                }) {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 70, height: 70)
                }
                MainTabToolbar(model: model, selectedPhotoData: $selectedPhotoData)
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            await model.camera.start()
            await model.loadPhotos()
            await model.loadThumbnail()
        }
        .sheet(isPresented: $showingReceiptDetail) {
            ProcessedView(proReceipt: model.processedReceipt)
        }
        .onChange(of: model.isProcessingComplete) { completed in
            if completed {
                showingReceiptDetail = true
                model.isProcessingComplete = false // Reset for next use
            }
        }
        .onChange(of: selectedPhotoData) { newValue in
            if let photoItem = newValue {
                Task {
                    if let imageData = try? await photoItem.loadTransferable(type: Data.self) {
                        await model.processPhoto(imageData: imageData)
                    }
                }
            }
        }
    }
}
