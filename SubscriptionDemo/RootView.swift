//
//  ContentView.swift
//  SubscriptionDemo
//
//  Created by Евгения Максимова on 30.11.2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var flowViewModel = AppFlowViewModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var paywallViewModel = PaywallViewModel()

    var body: some View {
        Group {
            if flowViewModel.hasSubscription {
                MainView()
            } else if flowViewModel.hasFinishedOnboarding {
                PayWallView(viewModel: paywallViewModel) {
                    flowViewModel.completePurchase()
                }
            } else {
                OnboardingView(viewModel: onboardingViewModel) {
                    flowViewModel.completeOnboarding()
                }
            }
        }
    }
}
