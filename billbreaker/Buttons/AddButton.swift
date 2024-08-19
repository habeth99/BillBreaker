//
//  AddButton.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/17/24.
//

import Foundation
import SwiftUI

struct AddButton: View {
    let action: () -> Void
    //var label: String = "Add Item"
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer() // This pushes the content to the trailing edge
                
                VStack {
                    Button(action: action) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                            .frame(width: 64, height: 64)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            .padding() // Add padding to the HStack to prevent the button from touching the edge
        }
    }
}

//#Preview {
//    AddButton()
//}
