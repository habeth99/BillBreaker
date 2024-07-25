//
//  ScanCheckView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/23/24.
//

import Foundation
import SwiftUI
import Vision
import VisionKit
import AVFoundation

//struct ScanCheckView: View {
//    @State private var scannedText = ""
//    @State private var isShowingScanner = false
//    @State private var isShowingProcessor = false
//    
//    var body: some View {
//        VStack {
//            Button("Scan Receipt") {
//                isShowingScanner = true
//            }
//        }
//        .sheet(isPresented: $isShowingScanner) {
//            DocumentScannerView(scannedText: $scannedText,
//                                isShowingScanner: $isShowingScanner,
//                                scanMode: .receipts)
//        }
//        .onChange(of: scannedText) { newValue in
//            if !newValue.isEmpty {
//                isShowingProcessor = true
//            }
//        }
//        .sheet(isPresented: $isShowingProcessor) {
//            ReceiptProcessorView(scannedText: scannedText)
//        }
//    }
//}

//struct ScanCheckView: View {
//    @State private var scannedText = ""
//    @State private var showingProcessedDetails = false
//    
//    var body: some View {
//        VStack {
//            DocumentScannerView(scannedText: $scannedText,
//                                isShowingScanner: .constant(true),
//                                scanMode: .receipts)
//                .edgesIgnoringSafeArea(.all)
//        }
//        .onChange(of: scannedText) { newValue in
//            if !newValue.isEmpty {
//                showingProcessedDetails = true
//            }
//        }
//        .sheet(isPresented: $showingProcessedDetails) {
//            ReceiptProcessorView(scannedText: scannedText)
//        }
//    }
//}

//struct ScanCheckView: View {
//    @State private var scannedText = ""
//    @State private var showingProcessedDetails = false
//    
//    var body: some View {
//        ZStack {
//            DocumentScannerView(scannedText: $scannedText,
//                                scanMode: .receipts)
//                .edgesIgnoringSafeArea(.all)
//            
//            if !scannedText.isEmpty {
//                VStack {
//                    Spacer()
//                    Button("Show Processed Details") {
//                        showingProcessedDetails = true
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//                }
//            }
//        }
//        .sheet(isPresented: $showingProcessedDetails) {
//            ReceiptProcessorView(scannedText: scannedText)
//        }
//    }
//}

struct ScanCheckView: View {
    @State private var scannedText = ""
    @State private var showingProcessedDetails = false
    @State private var isCameraAuthorized = false
    
    var body: some View {
        ZStack {
            DocumentScannerView(scannedText: $scannedText,
                                scanMode: .receipts)
                .edgesIgnoringSafeArea(.all)
            
            // Fallback view for debugging
            Text("If you can see this, DocumentScannerView is not displaying properly")
                .foregroundColor(.white)
                .background(Color.black.opacity(0.7))
                .padding()
        }
        .onAppear {
            checkCameraAuthorization()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshScanCheck"))) { _ in
            checkCameraAuthorization()
        }
    }
    
//    func checkCameraAuthorization() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            print("Camera access already authorized")
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    print("Camera access granted")
//                } else {
//                    print("Camera access denied")
//                }
//            }
//        case .denied, .restricted:
//            print("Camera access denied or restricted")
//        @unknown default:
//            print("Unknown camera authorization status")
//        }
//    }
    
    func checkCameraAuthorization() {
        print("Checking camera authorization")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("Camera already authorized")
            isCameraAuthorized = true
        case .notDetermined:
            print("Requesting camera access")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    print("Camera access granted: \(granted)")
                    self.isCameraAuthorized = granted
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
            isCameraAuthorized = false
        @unknown default:
            print("Unknown camera authorization status")
            isCameraAuthorized = false
        }
    }
}
