//
//  TextRecognitionService.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/26/24.
//

import Foundation
import Vision
import UIKit

struct TextRecognitionService {
    
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

