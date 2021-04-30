//
//  SlantedTriangle.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 30.04.21.
//

import SwiftUI

struct SlantedTriangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    
    return path
  }
}

struct SlantedTriangle_Previews: PreviewProvider {
  static var previews: some View {
    SlantedTriangle()
      .fill(Color.dailyBudgetPurple)
      .frame(width: 100, height: 100)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
