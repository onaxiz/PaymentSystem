import Foundation

protocol SubscriptionPaymentServicing {
    func purchase(plan: SubscriptionPlan) async throws -> SubscriptionPaymentResult
}

struct SubscriptionPaymentResult: Sendable {
    let transactionId: String
    let expirationDate: Date
}

enum SubscriptionPaymentError: LocalizedError {
    case userCancelled
    case networkUnavailable
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .userCancelled:
            return "Покупка отменена пользователем"
        case .networkUnavailable:
            return "Нет связи с платежным сервисом"
        case .unknown:
            return "Неизвестная ошибка сервиса"
        }
    }
}

struct MockSubscriptionPaymentService: SubscriptionPaymentServicing {
    func purchase(plan: SubscriptionPlan) async throws -> SubscriptionPaymentResult {
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        let random = Int.random(in: 0...100)
        if random < 10 {
            throw SubscriptionPaymentError.networkUnavailable
        } else if random < 20 {
            throw SubscriptionPaymentError.userCancelled
        }
        
        return SubscriptionPaymentResult(
            transactionId: UUID().uuidString,
            expirationDate: Calendar.current.date(byAdding: .month, value: plan.billing == .month ? 1 : 12, to: Date()) ?? Date()
        )
    }
}
