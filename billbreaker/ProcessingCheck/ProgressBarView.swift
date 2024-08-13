//
//  ProgressBarView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/12/24.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            FatCheckTheme.Colors.accentColor.opacity(0.4)
                .ignoresSafeArea()
            VStack{
                Text("Scanning Check...")
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md, style: .continuous)
                        .frame(width: 300, height: 20)
                        .foregroundColor(.gray.opacity(0.2))
                        .padding(FatCheckTheme.Spacing.xxl)
                    
                    RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md, style: .continuous)
                        .frame(width: 300 * progress, height: 20)
                        .foregroundColor(FatCheckTheme.Colors.primaryColor)
                        .padding(FatCheckTheme.Spacing.xxl)
                }
//                Text("\(Int(progress * 99))%")
//                    .font(.headline)
//                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 7)) {
                progress = 0.99 // 99%
            }
        }
    }
}

#Preview {
    ProgressBarView()
}
