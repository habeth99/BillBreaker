//
//  Seeing.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//



//let image = UIImage(imageLiteralResourceName: getTestReceiptImageName(1007))

//let recognizeTextRequest = VNRecognizeTextRequest  { (request, error) in
    //guard let observations = request.results as? [VNRecognizedTextObservation] else {
        //print("Error: \(error! as NSError)")
        //return
    //}
    //for currentObservation in observations {
        //let topCandidate = currentObservation.topCandidates(1)
        //if let recognizedText = topCandidate.first {
            //OCR Results
            //print(recognizedText.string)
        //}
    //}
   // let fillColor: UIColor = UIColor.green.withAlphaComponent(0.3)
    //let result = visualization(image, observations: observations)
//}
//recognizeTextRequest.recognitionLevel = .accurate

//NEW NEW NEW NEW

import SwiftUI
import Vision

struct VisionView: View {
    @State private var recognizedText: String = "Tap 'Recognize Text' to start."
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text(recognizedText)
                        .padding()
                }
                Button("Recognize Text") {
                    performTextRecognition()
                }
                .padding()
            }
            .navigationBarTitle("Text Recognition", displayMode: .inline)
        }
    }
    
    func performTextRecognition() {
        guard let uiImage = UIImage(named: "1007-receipt") else {
            self.recognizedText = "Failed to load the image."
            return
        }
        guard let cgImage = uiImage.cgImage else {
            self.recognizedText = "Image has no CGImage."
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                DispatchQueue.main.async {
                    self.recognizedText = "Recognition error: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: ", ")
            
            DispatchQueue.main.async {
                self.recognizedText = recognizedStrings.isEmpty ? "No text recognized." : recognizedStrings
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.recognizedText = "Failed to perform recognition: \(error.localizedDescription)"
                }
            }
        }
    }
}


#Preview {
    VisionView()
}

