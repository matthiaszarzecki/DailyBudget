//
//  ContentView.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 28.04.21.
//

import SwiftUI

struct DailyBudgetView: View {
  @ObservedObject private var viewModel = DailyBudgetViewModel()
  
  var body: some View {
    DailyBudgetDisplay(
      checkIfBudgetNeedsResetting: viewModel.checkIfBudgetNeedsResetting,
      currentTotalAmount: viewModel.state.currentTotalAmount,
      currentDailyAmount: viewModel.state.currentDailyAmount,
      adaptTotalAmount: viewModel.adaptTotalAmount,
      adaptDailyAmount: viewModel.adaptDailyAmount,
      resetDates: viewModel.getResetDatesDisplay(),
      setDebugDayReset: viewModel.setDebugDayReset
    )
  }
}

#Preview {
  DailyBudgetDisplay(
    checkIfBudgetNeedsResetting: {},
    currentTotalAmount: 120,
    currentDailyAmount: 23,
    adaptTotalAmount: {_ in },
    adaptDailyAmount: {_ in },
    resetDates: "ResetDate",
    setDebugDayReset: {}
  )
}
