//
//  SplashView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/15/24.
//

import Foundation
import SwiftUI
import SVGKit

struct SplashView: View {
    var body: some View {
        ZStack {
            // Green background
            Color(hex: "#30cd31")
                .ignoresSafeArea()
            
            // SVG logo
            SVGKitView(named: "fat-check-logo-1", size: CGSize(width: 230, height: 175))
                .frame(width: 100, height: 100)
        }
    }
}

struct SVGKitView: UIViewRepresentable {
    let named: String
    let size: CGSize
    
    func makeUIView(context: Context) -> SVGKFastImageView {
        guard let svgURL = Bundle.main.url(forResource: named, withExtension: "svg"),
              let svgImage = SVGKImage(contentsOf: svgURL) else {
            return SVGKFastImageView()
        }
        
        svgImage.size = size
        let view = SVGKFastImageView(svgkImage: svgImage)
        view?.contentMode = .scaleAspectFit
        return view ?? SVGKFastImageView()
    }
    
    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {}
}
