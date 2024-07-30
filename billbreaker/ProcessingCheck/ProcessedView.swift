//
//  ProcessedView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/30/24.
//

import Foundation
import SwiftUI

struct ProcessedView: View {
    var proReceipt: APIReceipt
    
    var body: some View {
        VStack{
            Text(proReceipt.name)
            
            ForEach(Array(proReceipt.items.enumerated()), id: \.offset) { index, item in
                Text(item.name)
            }
        }
    }
}
