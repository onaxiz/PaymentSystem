import SwiftUI

struct PayWallView: View {
    @ObservedObject var viewModel: PaywallViewModel
    let onPurchase: () -> Void
    @State private var autoDismissWorkItem: DispatchWorkItem?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Подписка")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 24)

            Text("Откройте доступ к полному контенту приложения. Выберите удобный вариант подписки.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            VStack(spacing: 12) {
                ForEach(viewModel.plans) { plan in
                    subscriptionRow(
                        plan: plan,
                        isSelected: plan == viewModel.selectedPlan
                    ) {
                        viewModel.select(plan)
                    }
                }
            }
            .padding(.horizontal, 24)

            Button {
                Task {
                    let success = await viewModel.purchaseSelectedPlan()
                    if success {
                        onPurchase()
                    }
                }
            } label: {
                HStack {
                    if viewModel.isProcessing {
                        ProgressView()
                            .tint(.white)
                    }
                    Text(viewModel.isProcessing ? "Покупаем…" : "Продолжить")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.isProcessing ? Color.gray : Color.accentColor)
                .cornerRadius(12)
                .padding(.horizontal, 24)
            }
            .disabled(viewModel.isProcessing)

            Text("Платежи здесь только эмулируются. Реального списания средств нет.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
        }
        .overlay(alignment: .bottom) {
            if let status = viewModel.purchaseStatus {
                PurchaseStatusView(status: status) {
                    viewModel.dismissStatusManually()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding()
            }
        }
        .onChange(of: viewModel.purchaseStatus) { newStatus in
            autoDismissWorkItem?.cancel()
            guard let newStatus, newStatus.isDismissible else { return }
            let workItem = DispatchWorkItem {
                viewModel.dismissStatusManually()
            }
            autoDismissWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
        }
    }

    private func subscriptionRow(
        plan: SubscriptionPlan,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(plan.title)
                            .font(.headline)

                        if plan.isBest {
                            Text("Скидка")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.yellow.opacity(0.8))
                                .cornerRadius(6)
                        }
                    }

                    Text(plan.detail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("\(plan.price) \(plan.billing.description)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Spacer()

                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(isSelected ? Color.accentColor.opacity(0.05) : Color(UIColor.systemBackground))
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    PayWallView(viewModel: PaywallViewModel(), onPurchase: {})
}
