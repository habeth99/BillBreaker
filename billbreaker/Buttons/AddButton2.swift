//
//  AddButton2.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/6/24.
//

import Foundation
import SwiftUI

struct AddButton2: View {
    @State private var showMenu = false
    let itemAction: () -> Void
    let personAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    showMenu.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(.black)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .overlay(
                    VStack {
                        if showMenu {
                            ContextMenuContent(
                                itemAction: {
                                    itemAction()
                                    showMenu = false
                                },
                                personAction: {
                                    personAction()
                                    showMenu = false
                                },
                                dismissAction: { showMenu = false }
                            )
                            .offset(y: -100) // Adjusted to position higher above the button
                            .offset(x: -100)
                            .transition(.scale.combined(with: .opacity))
                            .zIndex(1)
                        }
                    }
                    .animation(.spring(), value: showMenu)
                )
            }
            .padding()
        }
    }
}

struct ContextMenuContent: View {
    let itemAction: () -> Void
    let personAction: () -> Void
    let dismissAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: itemAction) {
                HStack {
                    Image(systemName: "square.and.pencil")
                    Text("Item")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(MenuButtonStyle())
            
            Button(action: personAction) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Person")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(MenuButtonStyle())
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(width: 200) // Set a fixed width to ensure text visibility
    }
}

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(configuration.isPressed ? Color.gray.opacity(0.2) : Color.clear)
            .cornerRadius(8)
    }
}
