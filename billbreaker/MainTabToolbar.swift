//
//  TabView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct MainTabToolbar: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    @ObservedObject var model: DataModel
    @Binding var selectedPhotoData: PhotosPickerItem?

    var body: some View {
        HStack {
            ImportButton(
                imageName: "plus",
                text: "Import",
                selectedPhotoData: $selectedPhotoData
            ){
                //router.navigate(to: .importPhoto)
            }

            ArchiveButton(imageName: "archivebox", text: "Archive") {
                router.navigate(to: .billDetails(receiptId: router.linkReceiptId))
            }
            
            ProfileButton(imageName: "gear", text: "Settings") {
                router.navigate(to: .settings)
            }
            
        }
        .padding()
        .background(Color.black.opacity(0.0))
    }
}

