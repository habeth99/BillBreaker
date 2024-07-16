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
            Color.white // Or any background color you prefer
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
    }
}

#Preview {
    SplashView()
}
