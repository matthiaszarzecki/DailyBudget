//
//  GlowingBackground.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 25.11.25.
//

import SwiftUI

struct RotatingGlowingBackground: View {
  var body: some View {
    ZStack {
      // moving background gradient
      LinearGradient(
        gradient: Gradient(
          colors: [
            Color(red:1, green:0.3, blue:0.45),
            Color(red:0.45, green:0.15, blue:1),
            Color(red:0, green:0.85, blue:0.9)
          ]
        ),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .blur(radius: 18) // soft blur for glow
      .scaleEffect(1.2)
      .blendMode(.screen) // additive-ish blend
      .animation(
        Animation.linear(duration: 8).repeatForever(autoreverses: true),
        value: UUID()
      )

      RoundedRectangle(cornerRadius: 18)
        .fill(Color.white.opacity(0.06))
        .overlay(
          RoundedRectangle(cornerRadius: 18)
            .stroke(
              Color.white.opacity(0.08),
              lineWidth: 0.5
            )
        )
        .shadow(
          color: Color.purple.opacity(0.6),
          radius: 30,
          x: 0,
          y: 0
        )
        .padding(24)
    }
    // ensures blendMode applies to group
    .compositingGroup()
  }
}

#Preview {
  RotatingGlowingBackground()
}
