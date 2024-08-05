//
//  ImportPhotosButton.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/5/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImportButton: View {
    let imageName: String
    let text: String
    @Binding var selectedPhotoData: PhotosPickerItem?
    let action: () -> Void
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhotoData,
            matching: .images,
            photoLibrary: .shared()
        ) {
            VStack {
                Image(systemName: imageName)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
            }
            .padding(.trailing)
        }
    }
}
