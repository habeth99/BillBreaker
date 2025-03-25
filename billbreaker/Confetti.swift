//
//  Confetti.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/11/24.
//

import Foundation
import SwiftUI

struct ConfettiPiece: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = min(rect.size.width, rect.size.height)
        let height = width
        path.addRect(CGRect(x: 0, y: 0, width: width, height: height))
        return path
    }
}

struct ConfettiAnimation: View {
    @Binding var isShowing: Bool
    let duration: Double = 2.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<200) { _ in
                    ConfettiPiece()
                        .fill(Color.random)
                        .frame(width: 10, height: 10)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: isShowing ? geometry.size.height + 50 : -50
                        )
                        .animation(
                            Animation.linear(duration: duration)
                                .repeatForever(autoreverses: false)
                                .speed(Double.random(in: 0.5...1.5))
                        )
                }
            }
        }
        .opacity(isShowing ? 1 : 0)
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
