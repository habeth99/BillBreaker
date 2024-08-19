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
//    @ObservedObject var model: DataModel
    @Binding var selectedPhotoData: PhotosPickerItem?

    var body: some View {
        HStack {
//            ImportButton(
//                imageName: "plus",
//                text: "Import",
//                selectedPhotoData: $selectedPhotoData
//            ){
//                //router.navigate(to: .importPhoto)
//            }

            HomeButton(imageName: "house", text: "Home") {
                router.navigateToMainTab(MainTabRoute.home)
            }
            
            ProfileButton(imageName: "gear", text: "Settings") {
                router.navigateToMainTab(MainTabRoute.settings)
            }
            
        }
        .padding()
        .background(Color.black.opacity(0.0))
    }
}

