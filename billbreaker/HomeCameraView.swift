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
    @EnvironmentObject var viewModel: UserViewModel
    @State private var showingReceiptDetail = false
    @State private var selectedPhotoData: PhotosPickerItem?
    @StateObject var rviewModel: ReceiptViewModel
    
    init(viewModel: UserViewModel) {
        self._rviewModel = StateObject(wrappedValue: ReceiptViewModel(user: viewModel))
    }
    
    var body: some View {
        NavigationStack(path: $router.path){
            ZStack {
                CameraView(model: model)
                
                VStack {
                    Spacer()
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
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .mainTab(let tabRoute):
                    switch tabRoute {
                    case .home:
                        HomeView(rviewModel: rviewModel)
                    case .settings:
                        SettingsView()
                    default: EmptyView()
                    }
                case .receipt(let receiptRoute):
                    switch receiptRoute {
                    case .details(let receiptId):
                        BillDetailsView(rviewModel: rviewModel, receiptId: receiptId)
                    }
                    
                }
            }
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
