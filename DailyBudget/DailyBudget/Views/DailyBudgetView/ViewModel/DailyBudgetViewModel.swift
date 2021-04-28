//
//  DailyBudgetViewModel.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 28.04.21.
//

import Foundation
import SwiftUI

class DailyBudgetViewModel: ObservableObject {
  @Published private(set) var state = DailyBudgetViewState()
  
  func increaseBudget(amount: Int) {
    state.currentBudget += amount
  }
  
  func decreaseBudget(amount: Int) {
    state.currentBudget -= amount
  }
  
  struct DailyBudgetViewState {
    @AppStorage("current_budget") var currentBudget: Int = 0
  }
}
