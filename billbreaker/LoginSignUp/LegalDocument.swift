//
//  PrivacyPolicy.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/5/24.
//

import Foundation
import SwiftUI

struct LegalDocumentView: View {
    let title: String
    let urlString: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WebView(urlString: urlString)
                .navigationBarTitle(title, displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}
