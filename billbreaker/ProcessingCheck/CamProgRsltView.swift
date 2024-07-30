//
//  CamProgRsltView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/30/24.
//

import Foundation
import SwiftUI

//struct CamProgRsltView: View {
//    @StateObject private var model = DataModel()
//    @State private var showingReceiptDetail = false
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                CameraView(model: model)
//                    .navigationTitle("Camera")
//                    .sheet(isPresented: $showingReceiptDetail) {
//                        ProcessedView(proReceipt: model.processedReceipt)
//                    }
//                
//                if model.isProcessing {
//                    ProgressView("Processing...")
//                        .padding()
//                        .background(Color.secondary.colorInvert())
//                        .cornerRadius(10)
//                }
//            }
//        }
//        .onReceive(model.$processedReceipt) { _ in
//            showingReceiptDetail = true
//        }
//    }
//}
struct CamProgRsltView: View {
    @StateObject private var model = DataModel()
    @State private var showingReceiptDetail = false

    var body: some View {
        NavigationView {
            ZStack {
                CameraView(model: model)
                    .navigationTitle("Camera")
                
                if model.isProcessing {
                    ProgressView("Processing...")
                        .padding()
                        .background(Color.secondary.colorInvert())
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showingReceiptDetail) {
            //if let receipt = model.processedReceipt {
            ProcessedView(proReceipt: model.processedReceipt)
            //}
        }
        .onChange(of: model.isProcessingComplete) { completed in
            if completed {
                showingReceiptDetail = true
                model.isProcessingComplete = false // Reset for next use
            }
        }
    }
}
