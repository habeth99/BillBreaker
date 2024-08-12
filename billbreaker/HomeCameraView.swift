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
    @StateObject var rviewModel = ReceiptViewModel()
    @StateObject var transformer = ReceiptProcessor()
    @State private var isFlashing = false
    
//    init() {
//        self._rviewModel = StateObject(wrappedValue: ReceiptViewModel())
//        self.rviewModel = ReceiptViewModel()
//    }
    
    var body: some View {
        NavigationStack(path: $router.path){
            ZStack {
                CameraView(model: model)
                
                Color.white
                    .opacity(isFlashing ? 0.6 : 0)
                    .animation(.easeInOut(duration: 0.2), value: isFlashing)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Button(action: {
//                        model.camera.takePhoto()
                        takePhotoWithFlash()
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
//        .background(FatCheckTheme.Colors.accentColor)
//        .tint(FatCheckTheme.Colors.accentColor)
        .edgesIgnoringSafeArea(.all)
        .task {
            await model.camera.start()
            await model.loadPhotos()
            await model.loadThumbnail()
        }
        .sheet(isPresented: $showingReceiptDetail) {
            ReviewView(receipt: transformer.receipt, transformer: transformer, isPresented: $showingReceiptDetail)
        }
        .onChange(of: model.isProcessingComplete) { completed in
            if completed {
                showingReceiptDetail = true
                Task{ @MainActor in
//                    await transformReceipt()
                    await transformer.transformReceipt(apiReceipt: model.processedReceipt)
                    model.isProcessingComplete = false // Reset for next use
                }
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
    
    func transformReceipt() async {
        let transformedReceipt = await transformer.transformReceipt(apiReceipt: model.processedReceipt)
        // Use the transformedReceipt here or update some state
    }
    
    func takePhotoWithFlash() {
        isFlashing = true
        
        // Take the photo
        model.camera.takePhoto()
        
        // Turn off the flash effect after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFlashing = false
        }
    }
}
