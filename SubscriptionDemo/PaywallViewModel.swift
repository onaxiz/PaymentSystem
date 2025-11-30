//
//  PaywallViewModel.swift
//  SubscriptionDemo
//
//  Created by Codex on 30.11.2025.
//

import Foundation
import SwiftUI

struct SubscriptionPlan: Identifiable, Equatable {
    enum Billing {
        case month
        case year
        
        var description: String {
            switch self {
            case .month:
                return "в месяц"
            case .year:
                return "в год"
            }
        }
    }
    
    let id = UUID()
    let title: String
    let price: String
    let billing: Billing
    let detail: String
    let isBest: Bool
}

final class PaywallViewModel: ObservableObject {
    @Published private(set) var selectedPlan: SubscriptionPlan
    @Published private(set) var purchaseStatus: PurchaseStatus?
    @Published private(set) var isProcessing: Bool = false
    let plans: [SubscriptionPlan]
    
    private let paymentService: SubscriptionPaymentServicing
    
    init(
        plans: [SubscriptionPlan] = PaywallViewModel.defaultPlans,
        paymentService: SubscriptionPaymentServicing = MockSubscriptionPaymentService()
    ) {
        self.plans = plans
        self.selectedPlan = plans.first!
        self.paymentService = paymentService
    }
    
    func select(_ plan: SubscriptionPlan) {
        guard plan != selectedPlan else { return }
        selectedPlan = plan
    }
    
    @MainActor
    func purchaseSelectedPlan() async -> Bool {
        guard !isProcessing else { return false }
        isProcessing = true
        purchaseStatus = .processing(title: "Обработка платежа", message: "Связываемся с сервисом оплаты…")
        
        do {
            let result = try await paymentService.purchase(plan: selectedPlan)
            purchaseStatus = .success(
                title: "Подписка активирована",
                message: "Транзакция \(result.transactionId.prefix(6))… действительна до \(formatted(date: result.expirationDate))"
            )
            isProcessing = false
            return true
        } catch {
            purchaseStatus = .failure(
                title: "Не удалось завершить покупку",
                message: error.localizedDescription
            )
            isProcessing = false
            return false
        }
    }
    
    func dismissStatusManually() {
        guard !isProcessing else { return }
        purchaseStatus = nil
    }
    
    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension PaywallViewModel {
    static let defaultPlans: [SubscriptionPlan] = [
        .init(
            title: "Месяц",
            price: "299 ₽",
            billing: .month,
            detail: "Автопродление в любой момент",
            isBest: false
        ),
        .init(
            title: "Год",
            price: "1480 ₽",
            billing: .year,
            detail: "Экономия до 60%",
            isBest: true
        )
    ]
}

extension PaywallViewModel {
    enum PurchaseStatus: Equatable {
        case processing(title: String, message: String)
        case success(title: String, message: String)
        case failure(title: String, message: String)
        
        var title: String {
            switch self {
            case let .processing(title, _),
                 let .success(title, _),
                 let .failure(title, _):
                return title
            }
        }
        
        var message: String {
            switch self {
            case let .processing(_, message),
                 let .success(_, message),
                 let .failure(_, message):
                return message
            }
        }
        
        var iconName: String {
            switch self {
            case .processing:
                return "arrow.triangle.2.circlepath.circle"
            case .success:
                return "checkmark.seal.fill"
            case .failure:
                return "exclamationmark.triangle.fill"
            }
        }
        
        var tintColor: Color {
            switch self {
            case .processing:
                return .blue
            case .success:
                return .green
            case .failure:
                return .red
            }
        }
        
        var isDismissible: Bool {
            switch self {
            case .processing:
                return false
            case .success, .failure:
                return true
            }
        }
    }
}
