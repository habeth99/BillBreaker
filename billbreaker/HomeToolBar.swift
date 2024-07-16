//
//  HomeToolBar.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI

struct HomeToolbar: ToolbarContent {
    let onEdit: () -> Void
    let onJoin: () -> Void
    let onAdd: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button("Edit", action: onEdit)
            Button("Join", action: onJoin)
        }
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: onAdd) {
                Image(systemName: "plus")
            }
        }
    }
}
