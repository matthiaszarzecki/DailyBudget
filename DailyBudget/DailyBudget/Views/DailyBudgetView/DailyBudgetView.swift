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

struct DailyBudgetDisplay: View {
  var checkIfBudgetNeedsResetting: () -> Void
  var currentTotalAmount: Int
  var currentDailyAmount: Int
  var adaptTotalAmount: (Int) -> Void
  var adaptDailyAmount: (Int) -> Void
  var resetDates: String
  var setDebugDayReset: () -> Void

  private let debug = true

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
          backgroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )
        
        RoundedButton(
          imageName: "minus",
          text: "5",
          action: { adaptTotalAmount(-5) },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )
        
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 22, height: 10, alignment: .center)

        RoundedButton(
          imageName: "plus",
          text: "5",
          action: { adaptTotalAmount(5) },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )
        
        RoundedButton(
          imageName: "plus",
          text: "10",
          action: { adaptTotalAmount(10) },
          foregroundColor: .white,
          backgroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
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
        backgroundColor: .white,
        shadowColor: .black
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
        backgroundColor: .white,
        shadowColor: .black
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
    1 - elementFraction * 2
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
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

        ZStack {
          VStack(spacing: 0) {
            Spacer()

            SlantedTriangleLeft()
              .fill(Color.dailyBudgetPurpleLight)
              .frame(
                width: geometry.size.width,
                height: geometry.size.height * centerFreaction * 0.75
              )
              .shadow(color: .black, radius: 12)
          }
          .frame(
            width: geometry.size.width,
            height: geometry.size.height * centerFreaction
          )

          SlantedTriangleRight()
            .fill(Color.dailyBudgetPurple)
            .frame(
              width: geometry.size.width,
              height: geometry.size.height * centerFreaction
            )
            .shadow(color: .black, radius: 6)
        }

        // Lower Part
        ZStack {
          Rectangle()
            .foregroundColor(.dailyBudgetPurple)
            .edgesIgnoringSafeArea(.all)
            .frame(
              width: geometry.size.width,
              height: geometry.size.height * elementFraction,
              alignment: .center
            )
          
          VStack {
            Text("Daily Amount")
              .font(.largeTitle)
              .foregroundColor(.white)
              .shadow(radius: 10)
            
            dailyBudgetRow
              .padding(.bottom, 18)

            VStack {
              if debug {
                Button(
                  action: setDebugDayReset,
                  label: {
                    Text("Debug: Reset in 2 minutes")
                      .padding()
                      .foregroundColor(.dailyBudgetPurple)
                      .backgroundColor(.white)
                      .mask(
                        RoundedRectangle(
                          cornerRadius: 10,
                          style: .continuous
                        )
                      )
                      .shadow(color: .black, radius: 10)
                      .padding(.bottom, 12)
                  }
                )
                Text(resetDates)
                  .foregroundColor(.white)
                  .multilineTextAlignment(.trailing)
              }
            }
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
      checkIfBudgetNeedsResetting: {},
      currentTotalAmount: 120,
      currentDailyAmount: 23,
      adaptTotalAmount: {_ in },
      adaptDailyAmount: {_ in },
      resetDates: "ResetDate",
      setDebugDayReset: {}
    )
  }
}
