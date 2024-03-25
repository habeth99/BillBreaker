//
//  JoinBillView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import SwiftUI

struct JoinBillView: View {
    @State private var numberString: String = ""
    @State private var code: Int?
    
    var body: some View {
        VStack {
            Text("Enter sharecode")
            
            TextField("ex. 123456", text: $numberString)
                .keyboardType(.numberPad) // Display a number pad keyboard
                .onChange(of: numberString) { newValue in
                    // Update the integer whenever the text changes
                    code = Int(newValue)
                }
                .onSubmit {
                    // Handle the submitted integer value
                    print("The entered integer is: \(code ?? 0)")
                }
            // Add any additional modifiers for styling
                .padding()
                .border(Color.gray)
                .frame(maxWidth: 300)
            Spacer()
        }
    }
}

#Preview {
    JoinBillView()
}
