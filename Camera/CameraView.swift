/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Foundation

struct CameraView: View {
    @ObservedObject var model: DataModel
    
    var body: some View {
        GeometryReader { geometry in
            if let image = model.viewfinderImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                Color.black
            }
        }
        .ignoresSafeArea()
    }
}

