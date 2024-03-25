//
//  BreakABillView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/23/24.
//

import Foundation
import SwiftUI
import AVFoundation

// Ensure you have the CameraManager and CameraPreview code from the previous explanations in your project.

struct BreakABillView: View {
    @State private var hasCameraPermission: Bool = false

    var body: some View {
        
            VStack {
                Image(systemName: "camera")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .controlSize(.large)
                NavigationLink("Take a photo of a Receipt", destination:CameraView())
                    .padding()
                NavigationLink("Or enter Receipt Manually", destination:BILLView())
            }
    }
}


// Preview
struct BreakABillView_Previews: PreviewProvider {
    static var previews: some View {
        BreakABillView()
    }
}


