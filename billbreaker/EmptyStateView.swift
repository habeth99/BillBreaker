//
//  EmptyStateView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/19/24.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 60))
            
            Text("No Checks")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your history of fatchecks will be shown here.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
