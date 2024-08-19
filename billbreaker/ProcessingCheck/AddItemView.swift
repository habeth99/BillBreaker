//
//  AddItemView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/13/24.
//

import Foundation
import SwiftUI

struct AddItemView: View {
    @State var name = "jew"
    @State var price = "1.00"
    @State var isEditing = false
    
    var body: some View {
        Button(action: {
            isEditing.toggle()
        }, label: {
            if isEditing {
                HStack{
                    TextField("Name", text: $name)
                    TextField("Price", text: $price)
                }
            }
            else {
                HStack{
                    Text(name)
                    Text(price)
                }
            }
        })
    }
}

#Preview {
    AddItemView()
}
