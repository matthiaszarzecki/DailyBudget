//
//  RoundedButton.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 30.04.21.
//

import SwiftUI

struct RoundedButton: View {
  let imageName: String
  let action: () -> Void
  let foregroundColor: Color
  let backgroundColor: Color
  
  let iconSize: CGFloat = 33
  
  var body: some View {
    Button(
      action: {
        action()
      },
      label: {
        Image(systemName: imageName)
          .frame(width: iconSize, height: iconSize, alignment: .center)
          .backgroundColor(backgroundColor)
          .foregroundColor(foregroundColor)
          .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
          .shadow(radius: 10)
      }
    )
  }
}

struct RoundedButton_Previews: PreviewProvider {
  static var previews: some View {
    RoundedButton(
      imageName: "plus",
      action: {},
      foregroundColor: .white,
      backgroundColor: .dailyBudgetPurple
    )
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
