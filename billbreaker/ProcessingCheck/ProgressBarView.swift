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
                        .frame(width: 310, height: 10)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(FatCheckTheme.Spacing.xxl)
                    
                    RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md, style: .continuous)
                        .frame(width: 310 * progress, height: 10)
                        .foregroundColor(FatCheckTheme.Colors.primaryColor)
                        .padding(FatCheckTheme.Spacing.xxl)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 7)) {
                progress = 0.95 // 95%
            }
        }
    }
}

#Preview {
    ProgressBarView()
}
