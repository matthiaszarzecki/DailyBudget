//
//  DailyBudgetDisplay.swift
//  DailyBudget
//
//  Created by Matthias Zarzecki on 25.11.25.
//

import SwiftUI

struct DailyBudgetDisplay: View {
  private let checkIfBudgetNeedsResetting: () -> Void
  private let currentTotalAmount: Int
  private let currentDailyAmount: Int
  private let adaptTotalAmount: (Int) -> Void
  private let adaptDailyAmount: (Int) -> Void
  private let resetDates: String
  private let setDebugDayReset: () -> Void
  private let debug = true

  init(
    checkIfBudgetNeedsResetting: @escaping () -> Void,
    currentTotalAmount: Int,
    currentDailyAmount: Int,
    adaptTotalAmount: @escaping (Int) -> Void,
    adaptDailyAmount: @escaping (Int) -> Void,
    resetDates: String,
    setDebugDayReset: @escaping () -> Void
  ) {
    self.checkIfBudgetNeedsResetting = checkIfBudgetNeedsResetting
    self.currentTotalAmount = currentTotalAmount
    self.currentDailyAmount = currentDailyAmount
    self.adaptTotalAmount = adaptTotalAmount
    self.adaptDailyAmount = adaptDailyAmount
    self.resetDates = resetDates
    self.setDebugDayReset = setDebugDayReset
  }

  private var currentBudgetRow: some View {
    VStack {
      Text("\(currentTotalAmount)")
        .font(.largeTitle)
        .padding()

      HStack {
        RoundedButton(
          imageName: "minus",
          text: "10",
          action: { adaptTotalAmount(-10) },
          foregroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )

        RoundedButton(
          imageName: "minus",
          text: "5",
          action: { adaptTotalAmount(-5) },
          foregroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )

        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 22, height: 10, alignment: .center)

        RoundedButton(
          imageName: "plus",
          text: "5",
          action: { adaptTotalAmount(5) },
          foregroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )

        RoundedButton(
          imageName: "plus",
          text: "10",
          action: { adaptTotalAmount(10) },
          foregroundColor: .dailyBudgetPurple,
          shadowColor: .dailyBudgetPurple
        )
      }
    }
  }

  private var dailyBudgetRow: some View {
    HStack {
      RoundedButton(
        imageName: "minus",
        text: "1",
        action: { adaptDailyAmount(-1) },
        foregroundColor: .dailyBudgetPurple,
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
        shadowColor: .black
      )
    }
  }

  private var verticalSpacer: some View {
    Rectangle()
      .frame(width: 20, height: 100, alignment: .center)
      .foregroundColor(.clear)
  }

  private let elementFraction: CGFloat = 0.45
  private var centerFreaction: CGFloat {
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
                  }
                )
                .buttonStyle(.glass)

                // TODO: Calculate display from date to string here, pass in date
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
