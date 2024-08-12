//
//  HomeViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/10/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var receiptList: [Receipt]
    
    init(receiptList: [Receipt]){
        self.receiptList = []
    }
    
    
    
}
