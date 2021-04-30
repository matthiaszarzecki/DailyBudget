//
//  DailyBudgetViewModel.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 28.04.21.
//

import Foundation
import SwiftUI

class DailyBudgetViewModel: ObservableObject {
  @AppStorage("current_budget") var currentBudget: Int = 0
  @AppStorage("daily_budget") var dailyBudget: Int = 25
  
  //@Published private(set) var state = DailyBudgetViewState()
  
  func increaseBudget(amount: Int) {
    currentBudget += amount
  }
  
  func decreaseBudget(amount: Int) {
    currentBudget -= amount
  }
  
  struct DailyBudgetViewState {
    @AppStorage("current_budget") var currentBudget: Int = 0
  }
}
