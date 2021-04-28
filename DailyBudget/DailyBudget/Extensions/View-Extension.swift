//
//  View-Extension.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 28.04.21.
//

import Foundation
import SwiftUI

extension View {
  /// Sets the background to a color.
  func backgroundColor(_ color: Color) -> some View {
    return self.background(Rectangle().foregroundColor(color))
  }
}
