//
//  RecognizedTextDataSource.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/23/24.
//

import Foundation
import UIKit
import Vision

protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation])
}
