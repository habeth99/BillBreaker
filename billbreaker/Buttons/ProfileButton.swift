//
//  ProfileButton.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/3/24.
//

import Foundation
import SwiftUI

struct ProfileButton: View {
    let imageName: String
    let text: String
    let isSelected = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: imageName)
                    .foregroundColor(.black)
                Text(text)
                    .foregroundColor(.black)
            }
        }
    }
}
