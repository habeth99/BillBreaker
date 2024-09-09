//
//  AddButton2.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/6/24.
//

import Foundation
import SwiftUI

struct AddButton2: View {
    let action: () -> Void
    var menuItems: [ContextMenuItem]
    
    @State private var showPopover = false
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: { showPopover = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(.black)
                        .clipShape(Circle())
                }
                .popover(isPresented: $showPopover, arrowEdge: .bottom) {
                    PopoverContent(menuItems: menuItems, dismissAction: { showPopover = false })
                }
            }
            .padding()
        }
        .background(.clear)
        .ignoresSafeArea()
    }
}

struct PopoverContent: View {
    let menuItems: [ContextMenuItem]
    let dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(menuItems) { item in
                Button(action: {
                    item.action()
                    dismissAction()
                }) {
                    Label(item.title, systemImage: item.iconName)
                        .foregroundColor(.primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
    }
}

struct ContextMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let action: () -> Void
}
