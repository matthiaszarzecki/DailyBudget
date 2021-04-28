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
      /*amount: viewModel.state.currentBudget,
       increaseBudget: viewModel.increaseBudget,
       decreaseBudget: viewModel.decreaseBudget*/
    )
  }
}

struct DailyBudgetDisplay: View {
  @AppStorage("current_budget") var currentBudget: Int = 0
  @AppStorage("daily_budget") var dailyBudget: Int = 25
  @AppStorage("reset_date_day") private var resetDateDay: String = ISO8601DateFormatter().string(from: Date.distantPast)
  @AppStorage("reset_date_month") private var resetDateMonth: String = ISO8601DateFormatter().string(from: Date.distantPast)
  
  //var amount: Int
  //var increaseBudget: (_ amount: Int) -> Void
  //var decreaseBudget: (_ amount: Int) -> Void
  
  init() {
    print("### Checking for update after starting app")
    checkIfBudgetNeedsResetting()
  }
  
  func checkIfBudgetNeedsResetting() {
    if let expiryDateMonthParsed = ISO8601DateFormatter().date(from: resetDateMonth),
       Date() > expiryDateMonthParsed {
      // If it is the next month
      print("### Resetting Budget for the month")
      
      // Reset current amount to daily amount
      currentBudget = dailyBudget
      
      // Set new reset date for tomorrow
      resetDateDay = getResetDateForNextDay()
      print("### Next Daily Reset: \(resetDateDay)")
      
      // Set new reset date for next month
      resetDateMonth = getResetDateForNextMonth()
      print("### Next Monthly Reset: \(resetDateMonth)")
    } else if let expiryDateDayParsed = ISO8601DateFormatter().date(from: resetDateDay),
              Date() > expiryDateDayParsed {
      // If it is the next day
      print("### Resetting Budget for the day")
      
      // Add daily amount to current amount
      currentBudget += dailyBudget
      
      // Set new reset date for tomorrow
      resetDateDay = getResetDateForNextDay()
      print("### Next Daily Reset: \(resetDateDay)")
      
      // Set new reset date for next month
      resetDateMonth = getResetDateForNextMonth()
      print("### Next Monthly Reset: \(resetDateMonth)")
    } else {
      print("### Not Resetting Budget")
      print("### Next Daily Reset: \(resetDateDay)")
      print("### Next Monthly Reset: \(resetDateMonth)")
    }
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
  
  func getResetDateForNextMonth() -> String {
    // Set expiry date to next month...
    let expiryAdvance = DateComponents(day: 20)
    var nextDate = Calendar.current.date(byAdding: expiryAdvance, to: Date())!
    
    // ...at 0400 in the morning.
    //nextDate = Calendar.current.date(bySettingHour: 4, minute: 0, second: 0, of: nextDate)!
    
    // ...of the first day
    nextDate = Calendar.current.date(bySetting: .day, value: 1, of: nextDate)!
    
    let stringDate = ISO8601DateFormatter().string(from: nextDate)
    return stringDate
  }
  
  var currentBudgetRow: some View {
    HStack {
      let iconSize: CGFloat = 33
      Button(
        action: {
          //decreaseBudget(5)
          currentBudget -= 5
        },
        label: {
          Image(systemName: "minus")
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .backgroundColor(.gray)
            .foregroundColor(.white)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
      )
      
      Text("\(currentBudget)")
        .font(.largeTitle)
        .padding()
      
      Button(
        action: {
          //increaseBudget(5)
          currentBudget += 5
        },
        label: {
          Image(systemName: "plus")
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .backgroundColor(.gray)
            .foregroundColor(.white)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
      )
    }
  }
  
  var dailyBudgetRow: some View {
    HStack {
      let iconSize: CGFloat = 33
      Button(
        action: {
          //decreaseBudget(5)
          dailyBudget -= 5
        },
        label: {
          Image(systemName: "minus")
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .backgroundColor(.gray)
            .foregroundColor(.white)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
      )
      
      Text("\(dailyBudget)")
        .font(.largeTitle)
        .padding()
      
      Button(
        action: {
          //increaseBudget(5)
          dailyBudget += 5
        },
        label: {
          Image(systemName: "plus")
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .backgroundColor(.gray)
            .foregroundColor(.white)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
      )
    }
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      Text("Your Budget")
        .font(.largeTitle)
      
      currentBudgetRow
      
      Spacer()
      
      Text("Daily Amount")
        .font(.largeTitle)
      
      dailyBudgetRow
      
      Spacer()
    }
    // When the app is put to the foreground,
    // check if a reset should happen.
    .onReceive(
      NotificationCenter.default.publisher(
        for: UIApplication.willEnterForegroundNotification)
    ) { _ in
      print("### Checking for update after putting app into foreground")
      checkIfBudgetNeedsResetting()
    }
  }
}

struct DailyBudgetView_Previews: PreviewProvider {
  static var previews: some View {
    DailyBudgetDisplay(
      /*amount: 25,
       increaseBudget: {_ in },
       decreaseBudget: {_ in }*/
    )
  }
}
