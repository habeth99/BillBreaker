//
//  Statboard.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/19/24.
//

import Foundation
import SwiftUI

//struct StatboardView: View {
//    var body: some View {
//        ZStack{
//            //FatCheckTheme.Colors.primaryColor
//            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md)
//                .fill(FatCheckTheme.Colors.accentColor)
//                .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
//                .padding()
//            
//            HStack {
//                VStack {
//                    Text("$40.00")
//                        .bold()
//                        .font(.title)
//                        .padding(.horizontal)
//                    Text("Amount owed")
//                }
//                Spacer()
//                
//            }
//            .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
//            .padding()
//        }
//    }
//}
//struct StatboardView: View {
//    @State private var progress: Double = 0.75 // Example progress value
//
//    var body: some View {
//        ZStack {
//            FatCheckTheme.Colors.accentColor
//            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md)
//                .fill(FatCheckTheme.Colors.white)
//                .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
//                .padding()
//            
//            HStack {
//                VStack {
//                    Text("$40.00")
//                        .bold()
//                        .font(.title)
//                        .padding(.horizontal)
//                    Text("Amount owed")
//                }
//                Spacer()
//                ProgressCircle(value: 20, maxValue: 60, color: FatCheckTheme.Colors.primaryColor, icon: "dollarsign", label: "")
//                    .padding()
//            }
//            .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
//            .padding()
//        }
//    }
//}
//
//struct ProgressCircle: View {
//    let value: Double
//    let maxValue: Double
//    let color: Color
//    let icon: String
//    let label: String
//
//    private var progress: Double {
//        min(value / maxValue, 1.0)
//    }
//
//    var body: some View {
//        VStack {
//            ZStack {
//                Circle()
//                    .stroke(color.opacity(0.2), lineWidth: 4)
//                    .frame(width: 50, height: 50)
//                
//                Circle()
//                    .trim(from: 0, to: progress)
//                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
//                    .frame(width: 50, height: 50)
//                    .rotationEffect(.degrees(-90))
//                
//                Image(systemName: icon)
//                    .foregroundColor(color)
//            }
//            
//            Text("$\(Int(value))")
//                .font(.headline)
//            Text(label)
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//    }
//}

struct StatboardView: View {

    var body: some View {
        ZStack {
            //FatCheckTheme.Colors.accentColor
            //Color.gray.opacity(0.1)
            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md)
                .fill(FatCheckTheme.Colors.white)
                .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
                //.padding(FatCheckTheme.Spacing.sm)
                .padding(.horizontal, FatCheckTheme.Spacing.sm)
            
            HStack (spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("$60.00")
                        .bold()
                        .font(.largeTitle)
                    Text("Amount owed")
                        .font(.caption)
                }
                Spacer()
                ProgressCircle(value: 10, maxValue: 60, color: FatCheckTheme.Colors.primaryColor, icon: "dollarsign", label: "")
            }
            .frame(maxWidth: .infinity, maxHeight: FatCheckTheme.Size.sm)
            .padding( FatCheckTheme.Spacing.xxl)
        }
    }
}

struct ProgressCircle: View {
    let value: Double
    let maxValue: Double
    let color: Color
    let icon: String
    let label: String

    private var progress: Double {
        min(value / maxValue, 1.0)
    }

    var body: some View {
        VStack(spacing: 4) {
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
            
            Text("$\(Int(value))")
                .font(.caption)
                .foregroundColor(color)
        }
    }
}

#Preview {
    StatboardView()
}
