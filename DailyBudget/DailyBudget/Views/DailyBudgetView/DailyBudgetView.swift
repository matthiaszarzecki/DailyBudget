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
      resetDates: viewModel.getResetDatesDisplay()
    )
  }
}

struct DailyBudgetDisplay: View {
  var checkIfBudgetNeedsResetting: () -> Void
  var currentTotalAmount: Int
  var currentDailyAmount: Int
  var adaptTotalAmount: (Int) -> Void
  var adaptDailyAmount: (Int) -> Void
  var resetDates: String

  var currentBudgetRow: some View {
    VStack {
      Text("\(currentTotalAmount)")
        .font(.largeTitle)
        .padding()
      
      HStack {
        RoundedButton(
          imageName: "minus",
          text: "10",
          action: { adaptTotalAmount(-10) },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
        
        RoundedButton(
          imageName: "minus",
          text: "5",
          action: { adaptTotalAmount(-5) },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
        
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 22, height: 10, alignment: .center)

        RoundedButton(
          imageName: "plus",
          text: "5",
          action: { adaptTotalAmount(5) },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple
        )
        
        RoundedButton(
          imageName: "plus",
          text: "10",
          action: { adaptTotalAmount(10) },
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
        action: { adaptDailyAmount(-1) },
        foregroundColor: .dailyBudgetPurple,
        backgroundColor: .white
      )
      
      Text("\(currentDailyAmount)")
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding()

      RoundedButton(
        imageName: "plus",
        text: "1",
        action: { adaptDailyAmount(1) },
        foregroundColor: .dailyBudgetPurple,
        backgroundColor: .white
      )
    }
  }
  
  var verticalSpacer: some View {
    Rectangle()
      .frame(width: 20, height: 100, alignment: .center)
      .foregroundColor(.clear)
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
            verticalSpacer
            
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
            
            verticalSpacer
          }
        }
        .overlay(
          VStack {
            Text(resetDates)
              .foregroundColor(.white)
          },
          alignment: .bottom
        )
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
      checkIfBudgetNeedsResetting: {},
      currentTotalAmount: 120,
      currentDailyAmount: 23,
      adaptTotalAmount: {_ in },
      adaptDailyAmount: {_ in },
      resetDates: "ResetDate"
    )
  }
}
