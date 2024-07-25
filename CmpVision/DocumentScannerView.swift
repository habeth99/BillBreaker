//
//  DocumentScannerView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/23/24.
//

import Foundation
import SwiftUI
import VisionKit
import Vision

//struct DocumentScannerView: UIViewControllerRepresentable {
//    @Binding var scannedText: String
//    @Binding var isShowingScanner: Bool
//    var scanMode: DocumentScanningViewController.ScanMode
//    
//    func makeUIViewController(context: Context) -> DocumentScanningViewController {
//        let viewController = DocumentScanningViewController()
//        viewController.scanMode = scanMode
//        viewController.resultsViewController = context.coordinator
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: DocumentScanningViewController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: UIViewController, RecognizedTextDataSource {
//        var scannerView: DocumentScannerView
//        
//        init(_ scannerView: DocumentScannerView) {
//            self.scannerView = scannerView
//            super.init(nibName: nil, bundle: nil)
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
//            let text = recognizedText.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
//            scannerView.scannedText = text
//            scannerView.isShowingScanner = false
//        }
//    }
//}

struct DocumentScannerView: UIViewControllerRepresentable {
//    @Binding var scannedText: String
//    var scanMode: DocumentScanningViewController.ScanMode
//    
//    func makeUIViewController(context: Context) -> DocumentScanningViewController {
//        let viewController = DocumentScanningViewController()
//        viewController.scanMode = scanMode
//        viewController.resultsViewController = context.coordinator
//        // Ensure the view controller doesn't dismiss itself after scanning
////        viewController.shouldDismissAfterScan = false
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: DocumentScanningViewController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
    @Binding var scannedText: String
    var scanMode: DocumentScanningViewController.ScanMode
    
    func makeUIViewController(context: Context) -> DocumentScanningViewController {
        print("Making DocumentScanningViewController")
        let viewController = DocumentScanningViewController()
        viewController.scanMode = scanMode
        viewController.resultsViewController = context.coordinator
        // viewController.shouldDismissAfterScan = false  // Uncomment when property is added
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DocumentScanningViewController, context: Context) {
        print("Updating DocumentScanningViewController")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: UIViewController, RecognizedTextDataSource {
        var scannerView: DocumentScannerView
        
        init(_ scannerView: DocumentScannerView) {
            self.scannerView = scannerView
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
            let text = recognizedText.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            scannerView.scannedText = text
            // Don't dismiss the scanner, just update the scanned text
        }
    }
}
