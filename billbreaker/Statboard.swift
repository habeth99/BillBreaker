//
//  Statboard.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/19/24.
//

import Foundation
import SwiftUI

struct StatboardView: View {
    @ObservedObject var rviewModel: ReceiptViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.sm)
                .fill(FatCheckTheme.Colors.white)
                .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
                .padding(.horizontal, FatCheckTheme.Spacing.sm)
            HStack (spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(NumberFormatter.localizedString(from: rviewModel.totalAmountOwed as NSDecimalNumber, number: .currency))
                        .bold()
                        .font(.system(size: 45))
                    Text("Amount owed")
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(rviewModel.openChecksCount)")
                        .bold()
                        .font(.system(size: 45))
                    Text("Open checks")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
            .padding( FatCheckTheme.Spacing.lg)
        }
    }
}

struct ProgressCircle: View {
    let value: Decimal
    let maxValue: Decimal
    let color: Color
    let icon: String
    let label: String

    private var progress: CGFloat {
        CGFloat(NSDecimalNumber(decimal: min(value / maxValue, 1.0)).doubleValue)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 6)
                    .frame(width: 50, height: 50)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))

                Image(systemName: icon)
                    .foregroundColor(color)
            }

            Text(formattedValue)
                .font(.caption)
                .foregroundColor(color)
                .padding(.top, FatCheckTheme.Spacing.xs)
        }
        .padding(FatCheckTheme.Spacing.xs)
    }

    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: value as NSDecimalNumber) ?? "0"
    }
}

//#Preview {
//    StatboardView()
//}
