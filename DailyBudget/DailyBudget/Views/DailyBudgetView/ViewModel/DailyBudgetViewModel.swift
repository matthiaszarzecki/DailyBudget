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
  
  @AppStorage("reset_date_day") private var resetDateDay: String = ISO8601DateFormatter().string(from: Date.distantPast)
  @AppStorage("reset_date_month") private var resetDateMonth: String = ISO8601DateFormatter().string(from: Date.distantPast)
  
  @AppStorage("current_budget") var savedTotalAmount: Int = 0
  @AppStorage("daily_budget") var savedDailyAmount: Int = 25
  
  init() {
    state.currentTotalAmount = savedTotalAmount
    state.currentDailyAmount = savedDailyAmount
    
    print("### Checking for update after starting app")
    checkIfBudgetNeedsResetting()
  }
  
  func getResetDatesDisplay() -> String {
    return "Reset Day: \(resetDateDay)\nReset Month: \(resetDateMonth)"
  }
  
  func setDebugDayReset() {
    // Set new reset date for tomorrow
    resetDateDay = getResetDateForTwoMinutesFromNow()
    print("### Next Daily Reset: \(resetDateDay)")
  }
  
  func adaptTotalAmount(amount: Int) {
    self.state.currentTotalAmount += amount
    savedTotalAmount = self.state.currentTotalAmount
  }
  
  /// Resets the Total Amount to the saved Monthly Amount.
  func resetTotalAmount() {
    self.state.currentTotalAmount = 0
    savedTotalAmount = self.state.currentTotalAmount
  }
  
  func adaptDailyAmount(amount: Int) {
    self.state.currentDailyAmount += amount
    savedDailyAmount = self.state.currentDailyAmount
  }
  
  var shouldUpdateMonth: Bool {
    if let expiryDateMonthParsed = ISO8601DateFormatter().date(from: resetDateMonth),
       Date() > expiryDateMonthParsed {
      return true
    }
    return false
  }
  
  var shouldUpdateDay: Bool {
    if let expiryDateDayParsed = ISO8601DateFormatter().date(from: resetDateDay),
       Date() > expiryDateDayParsed {
      return true
    }
    return false
  }
  
  func checkIfBudgetNeedsResetting() {
    if shouldUpdateMonth {
      // If it is the next month
      print("### Resetting Budget for the month")
      
      // Reset current amount to zero
      resetTotalAmount()
      adaptTotalAmount(amount: state.currentDailyAmount)

      setResetDates()
    } else if shouldUpdateDay {
      // If it is the next day
      print("### Resetting Budget for the day")
      
      // Add daily amount to current amount
      adaptTotalAmount(amount: state.currentDailyAmount)
      
      setResetDates()
    } else {
      print("### Not Resetting Budget")
      setResetDates()
    }
  }
  
  func setResetDates() {
    // Set new reset date for tomorrow
    resetDateDay = getResetDateForNextDay()
    print("### Next Daily Reset: \(resetDateDay)")
    
    // Set new reset date for next month
    resetDateMonth = getResetDateForNextMonth()
    print("### Next Monthly Reset: \(resetDateMonth)")
  }
  
  func getResetDateForNextDay() -> String {
    // Set expiry date to next day...
    let expiryAdvance = DateComponents(day: 1)
    var nextDate = Calendar.current.date(byAdding: expiryAdvance, to: Date())!
    
    // ...at 0400 in the morning.
    nextDate = Calendar.current.date(bySettingHour: 4, minute: 0, second: 0, of: nextDate)!
    
    let stringDate = ISO8601DateFormatter().string(from: nextDate)
    return stringDate
  }
  
  func getResetDateForTwoMinutesFromNow() -> String {
    // Set expiry date to next day...
    let expiryAdvance = DateComponents(minute: 2)
    let nextDate = Calendar.current.date(byAdding: expiryAdvance, to: Date())!
    
    let stringDate = ISO8601DateFormatter().string(from: nextDate)
    return stringDate
  }
  
  func getResetDateForNextMonth() -> String {
    // Set expiry date to the next
    // possible 1st day, which is the
    // first day of the next month...
    var nextDate = Calendar.current.date(bySetting: .day, value: 1, of: Date())!

    // ...at 4am in the morning
    nextDate = Calendar.current.date(bySetting: .hour, value: 4, of: nextDate)!

    let stringDate = ISO8601DateFormatter().string(from: nextDate)
    return stringDate
  }
  
  struct DailyBudgetViewState {
    var currentTotalAmount = 0
    var currentDailyAmount = 0
  }
}
