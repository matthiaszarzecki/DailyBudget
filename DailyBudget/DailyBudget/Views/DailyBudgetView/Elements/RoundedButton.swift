//
//  RoundedButton.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 30.04.21.
//

import SwiftUI

struct RoundedButton: View {
  let imageName: String
  let text: String
  let action: () -> Void
  let foregroundColor: Color
  let shadowColor: Color
  
  let iconSize: CGFloat = 22

  var body: some View {
    Button(
      action: {
        action()
      },
      label: {
        HStack(spacing: 2) {
          Image(systemName: imageName)
          Text(text)
            .font(.title2)
        }
        .frame(
          width: iconSize * 2,
          height: iconSize,
          alignment: .center
        )
        .foregroundColor(foregroundColor)
      }
    )
    .buttonStyle(.glass)
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  RoundedButton(
    imageName: "plus",
    text: "5",
    action: {},
    foregroundColor: .dailyBudgetPurple,
    shadowColor: .dailyBudgetPurple
  )
  .padding()
}
