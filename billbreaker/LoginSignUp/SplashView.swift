//
//  SplashView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/15/24.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            if let iconImage = UIImage(named: "AppIcon60x60") {
                Image(uiImage: iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(20.0)
            } else {
                Text("Logo not found")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#30cd31"))
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
