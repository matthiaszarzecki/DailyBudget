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
      amount: viewModel.state.currentBudget,
      increaseBudget: viewModel.increaseBudget,
      decreaseBudget: viewModel.decreaseBudget
    )
  }
}

struct DailyBudgetDisplay: View {
  @AppStorage("current_budget") var currentBudget: Int = 0
  @AppStorage("daily_budget") var dailyBudget: Int = 25
  
  var amount: Int
  var increaseBudget: (_ amount: Int) -> Void
  var decreaseBudget: (_ amount: Int) -> Void
  
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
  }
}

struct DailyBudgetView_Previews: PreviewProvider {
  static var previews: some View {
    DailyBudgetDisplay(
      amount: 25,
      increaseBudget: {_ in },
      decreaseBudget: {_ in }
    )
  }
}
