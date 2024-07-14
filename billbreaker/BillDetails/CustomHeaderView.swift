//
//  CustomHeaderView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/5/24.
//

import Foundation
import SwiftUI

struct CustomHeaderView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(rviewModel.receipt.date)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(rviewModel.receipt.name)
                .font(.largeTitle)
                .bold()
        }
//        .padding()
//        .background(Color.black)
//        .foregroundColor(.white)
    }
}

