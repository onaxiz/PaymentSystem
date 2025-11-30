//
//  AppFlowViewModel.swift
//  SubscriptionDemo
//
//  Created by Codex on 30.11.2025.
//

import SwiftUI

final class AppFlowViewModel: ObservableObject {
    @AppStorage("hasSubscription") var hasSubscription: Bool = false {
        willSet { objectWillChange.send() }
    }
    
    @Published var hasFinishedOnboarding: Bool = false
    
    func completeOnboarding() {
        hasFinishedOnboarding = true
    }
    
    func completePurchase() {
        hasSubscription = true
    }
}
