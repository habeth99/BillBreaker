//
//  TestView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/3/24.
//

import Foundation
import SwiftUI

struct TestView: View {
    @State var user: User
    @State private var receipt: String = ""

    var body: some View {
        Form {
            TextField("Receipt", text: $receipt)
            
            Button("Add Receipt") {
                user.receipts.append(receipt)
                // Since User is now a class, modifications are automatically observed
                // Additional actions to persist changes to Firebase can be triggered here
            }
        }
    }
}

// Assuming you want to provide a preview for TestView
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a temporary User instance for previews
        TestView(user: User(name: "Sample User", venmoHandle: "@SampleVenmo", cashAppHandle: "$SampleCash"))
    }
}

