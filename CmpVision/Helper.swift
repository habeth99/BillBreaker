//
//  Helper.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import UIKit
import Vision

public func getTestReceiptImageName(_ number: Int) -> String {
    String.init(format: "%d-receipt.jpg", number)
}

//https://www.udemy.com/course/machine-learning-with-core-ml-2-and-swift
public func visualization(_ image: UIImage, observations: [VNDetectedObjectObservation]) -> UIImage {
    var transform = CGAffineTransform.identity
        .scaledBy(x: 1, y: -1)
        .translatedBy(x: 1, y: -image.size.height)
    transform = transform.scaledBy(x: image.size.width, y: image.size.height)

    UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
    let context = UIGraphicsGetCurrentContext()

    image.draw(in: CGRect(origin: .zero, size: image.size))
    context?.saveGState()

    context?.setLineWidth(2)
    context?.setLineJoin(CGLineJoin.round)
    context?.setStrokeColor(UIColor.black.cgColor)
    context?.setFillColor(red: 0, green: 1, blue: 0, alpha: 0.3)

    observations.forEach { observation in
        let bounds = observation.boundingBox.applying(transform)
        context?.addRect(bounds)
    }

    context?.drawPath(using: CGPathDrawingMode.fillStroke)
    context?.restoreGState()
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage!
}
