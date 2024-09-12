//
//  testlist.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/11/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<10) { index in
                    VStack {
                        // Your heterogeneous content here
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        // Add more views as needed
                    }
                    .background(Color(UIColor.systemBackground))
                    .padding(.horizontal)
                    
                    Divider()
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    ContentView()
}
