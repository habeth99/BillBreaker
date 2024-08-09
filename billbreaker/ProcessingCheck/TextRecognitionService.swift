//
//  TextRecognitionService.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/29/24.
//

import Foundation
import Vision
import AVFoundation
import VisionKit


class TextRecognitionService {
    static let shared = TextRecognitionService()
    
    func performTextRecognition(imageData: Data, completion: @escaping (String) -> Void) {
        guard let uiImage = UIImage(data: imageData), let cgImage = uiImage.cgImage else {
            completion("Failed to convert imageData to CGImage.")
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    completion("Recognition error: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: ", ")
            
            
            DispatchQueue.main.async {
                completion(recognizedStrings.isEmpty ? "No text recognized." : recognizedStrings)
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    completion("Failed to perform recognition: \(error.localizedDescription)")
                }
            }
        }
    }
}
//class TextRecognitionService {
//    func performTextRecognition(imageData: Data) async throws -> APIReceipt {
//        guard let uiImage = UIImage(data: imageData), let cgImage = uiImage.cgImage else {
//            throw NSError(domain: "TextRecognitionService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert imageData to CGImage."])
//        }
//        
//        let request = VNRecognizeTextRequest()
//        request.recognitionLevel = .accurate
//        
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        try await handler.perform([request])
//        
//        guard let observations = request.results as? [VNRecognizedTextObservation] else {
//            throw NSError(domain: "TextRecognitionService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get recognized text observations."])
//        }
//        
//        let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
//        
//        // Here, you would parse the recognizedText into an APIReceipt
//        // For now, we'll return a dummy APIReceipt
//        return APIReceipt(name: "Sample Receipt", address: "123 Main St", dateTime: "", items: [], subTotal: 10.0, tax: 1.0, tip: 2.0, total: 13.0, method: "Card", cardLastFour: "1234")
//    }
//}

//class TextRecognitionService {
//    func performTextRecognition(imageData: Data) async throws -> APIReceipt {
//        guard let uiImage = UIImage(data: imageData), let cgImage = uiImage.cgImage else {
//            throw NSError(domain: "TextRecognitionService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert imageData to CGImage."])
//        }
//        
//        let request = VNRecognizeTextRequest()
//        request.recognitionLevel = .accurate
//        
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        
//        // Wrap the perform call in a Task to make it async
//        try await withCheckedThrowingContinuation { continuation in
//            do {
//                try handler.perform([request])
//                continuation.resume()
//            } catch {
//                continuation.resume(throwing: error)
//            }
//        }
//        
//        guard let observations = request.results else {
//            throw NSError(domain: "TextRecognitionService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get recognized text observations."])
//        }
//        
//        let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
//        
//        // Here, you would parse the recognizedText into an APIReceipt
//        // For now, we'll return a dummy APIReceipt
//        // Ensure this matches your APIReceipt initializer exactly
//        return APIReceipt(
//            name: "Sample Receipt",
//            address: "123 Main St",
//            dateTime: "",
//            items: [],
//            subTotal: 10.0,
//            tax: 1.0,
//            tip: 2.0,
//            total: 13.0,
//            method: "Card",
//            cardLastFour: "1234"
//        )
//    }
//}
