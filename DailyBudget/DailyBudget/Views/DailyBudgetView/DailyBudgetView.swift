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
      
      // Reset current amount to daily amount
      currentBudget = dailyBudget
      
      setResetDates()
    } else if shouldUpdateDay {
      // If it is the next day
      print("### Resetting Budget for the day")
      
      // Add daily amount to current amount
      currentBudget += dailyBudget
      
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
            .backgroundColor(.dailyBudgetPurple)
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
            .backgroundColor(.dailyBudgetPurple)
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
          dailyBudget -= 1
        },
        label: {
          Image(systemName: "minus")
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .backgroundColor(.white)
            .foregroundColor(.dailyBudgetPurple)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
      )
      
      Text("\(dailyBudget)")
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding()
      
      Button(
        action: {
          //increaseBudget(5)
          dailyBudget += 1
        },
        label: {
          Image(systemName: "plus")
            .frame(width: iconSize, height: iconSize, alignment: .center)
            .backgroundColor(.white)
            .foregroundColor(.dailyBudgetPurple)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
      )
    }
  }
  
  let elementFraction: CGFloat = 0.45
  var centerFreaction: CGFloat {
    return 1 - elementFraction * 2
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        // Upper Part
        ZStack {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: geometry.size.width, height: geometry.size.height * elementFraction, alignment: .center)
        
          VStack {
            Text("Your Budget")
              .font(.largeTitle)
            
            currentBudgetRow
          }
        }
        
        SlantedTriangle()
          .fill(Color.dailyBudgetPurple)
          .frame(width: geometry.size.width, height: geometry.size.height * centerFreaction)
          // Move this down to cover
          // the automatic padding
          .offset(y: 8)

        // Lower Part
        ZStack {
          Rectangle()
            .foregroundColor(.dailyBudgetPurple)
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, height: geometry.size.height * elementFraction, alignment: .center)
          
          VStack {
            Text("Daily Amount")
              .font(.largeTitle)
              .foregroundColor(.white)
              .shadow(radius: 10)
            
            dailyBudgetRow
          }
        }
      }
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

struct DailyBudgetView_Previews: PreviewProvider {
  static var previews: some View {
    DailyBudgetDisplay(
      /*amount: 25,
       increaseBudget: {_ in },
       decreaseBudget: {_ in }*/
    )
  }
}
