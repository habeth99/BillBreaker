//
//  TestHeaderView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/12/24.
//

import Foundation
import SwiftUI

struct DynamicNavBarView: View {
    @State private var scrollOffset: CGFloat = 0
    let title: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
                }
                .frame(height: 0)
                
                // Your scrollable content goes here
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(alignment: .leading, spacing: 4) {
                    if scrollOffset > -50 {
                        Text(Date(), style: .date)
                            .padding(.top)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Text(title)
                        .padding(.bottom)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.default, value: scrollOffset)
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            DynamicNavBarView(title: "Ryans Rotissere Joint")
        }
    }
}

//import SwiftUI
//
//struct DynamicNavBarView: View {
//    @State private var scrollOffset: CGFloat = 0
//    let title: String
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            ScrollView {
//                VStack(spacing: 0) {
//                    GeometryReader { geometry in
//                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
//                    }
//                    .frame(height: 0)
//                    
//                    // Your scrollable content goes here
//                    VStack {
//                        Text("Items")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding()
//                        
//                        // Add your list items here
//                    }
//                    .padding(.top, 100) // Add top padding to account for custom nav bar
//                }
//            }
//            .coordinateSpace(name: "scroll")
//            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//                scrollOffset = value
//            }
//            
//            // Custom Navigation Bar
//            VStack(spacing: 0) {
//                HStack {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.blue)
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        if scrollOffset > -50 {
//                            Text(Date(), style: .date)
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                        }
//                        Text(title)
//                            .font(.title)
//                            .fontWeight(.bold)
//                    }
//                    .padding(.leading, 8)
//                    
//                    Spacer()
//                }
//                .padding()
//                .background(Color(UIColor.systemBackground).shadow(radius: 2))
//                .animation(.default, value: scrollOffset)
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//struct ScrollOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            DynamicNavBarView(title: "Ryans Rotissere Joint")
//        }
//    }
//}

#Preview {
    ContentView()
}
