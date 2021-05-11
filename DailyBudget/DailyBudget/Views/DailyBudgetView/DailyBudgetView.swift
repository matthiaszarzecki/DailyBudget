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
      //amount: viewModel.currentBudget,
      //dailyAmount: viewModel.dailyBudget,
      checkIfBudgetNeedsResetting: viewModel.checkIfBudgetNeedsResetting
    )
  }
}

struct DailyBudgetDisplay: View {
  //var amount: Int
  //var dailyAmount: Int
  var checkIfBudgetNeedsResetting: () -> Void
  
  @AppStorage("current_budget") var amount: Int = 0
  @AppStorage("daily_budget") var dailyAmount: Int = 25
  
  var currentBudgetRow: some View {
    VStack {
      Text("\(amount)")
        .font(.largeTitle)
        .padding()
      
      HStack {
        RoundedButton(
          imageName: "minus",
          text: "10",
          action: { amount -= 10 },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
        
        RoundedButton(
          imageName: "minus",
          text: "5",
          action: { amount -= 5 },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
        
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 22, height: 10, alignment: .center)

        RoundedButton(
          imageName: "plus",
          text: "5",
          action: { amount += 5 },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
        
        RoundedButton(
          imageName: "plus",
          text: "10",
          action: { amount += 10 },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
      }
    }
  }
  
  var dailyBudgetRow: some View {
    HStack {
      RoundedButton(
        imageName: "minus",
        text: "1",
        action: { dailyAmount -= 1 },
        foregroundColor: .dailyBudgetPurple,
        backgroundColor: .white
      )
      
      Text("\(dailyAmount)")
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding()

      RoundedButton(
        imageName: "plus",
        text: "1",
        action: { dailyAmount += 1 },
        foregroundColor: .dailyBudgetPurple,
        backgroundColor: .white
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
          .shadow(color: .black, radius: 10)

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

struct DailyBudgetView_Previews: PreviewProvider {
  static var previews: some View {
    DailyBudgetDisplay(
      //amount: 25,
      //dailyAmount: 25,
      checkIfBudgetNeedsResetting: {}
    )
  }
}
