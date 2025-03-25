//
//  SelectorButton.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/28/24.
//

import Foundation
import SwiftUI

struct SelectorButton: View {
    var body: some View {
        
        VStack {
            Spacer()
            Button("Options") {
                print("Button tapped")
            }
            .contextMenu {
                Button("Option 1") {
                    print("Option 1 selected")
                }
                Button("Option 2") {
                    print("Option 2 selected")
                }
                Button("Option 3") {
                    print("Option 3 selected")
                }
        }
        }
    }
}

#Preview {
    SelectorButton()
}
