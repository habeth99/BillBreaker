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
    @ObservedObject var model : DataModel
    
    var body: some View {
        VStack{
            Text(model.recognizedText)
                .foregroundColor(.white)
            Text("Hello World")
                .foregroundColor(.blue)
            Button("Update Text") {
                model.recognizedText = "Manually Updated Text"
            }

        }
    }
}



