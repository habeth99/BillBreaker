//
//  CheckProgressCirc.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

//struct CheckProgressCirc: View {
//    var progress = 10
//    var color = Color.green
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                Circle()
//                    .stroke(color.opacity(0.2), lineWidth: 6)
//                    .frame(width: 100, height: 100)
//                
//                Circle()
//                    .trim(from: 0, to: CGFloat(progress))
//                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
//                    .frame(width: 100, height: 100)
//                    .rotationEffect(.degrees(-90))
//                
//                Text("-$20")
//            }
//        }
//    }
//}
//
//#Preview {
//    CheckProgressCirc()
//}
struct CheckProgressCirc: View {
    var fullAmount: Double
    var amountPaid: Double
    var stillOwed: Double
    var color = Color.green
    
    private var progress: Double {
        guard fullAmount > 0 else { return 0 }
        return min(amountPaid / fullAmount, 1.0)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 6)
                    .frame(width: 90, height: 90)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-90))
                
                Text("-$\(String(format: "%.2f", stillOwed))")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(FatCheckTheme.Spacing.sm)
        }
    }
}
