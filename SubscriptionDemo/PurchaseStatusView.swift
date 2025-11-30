import SwiftUI

struct PurchaseStatusView: View {
    let status: PaywallViewModel.PurchaseStatus
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: status.iconName)
                .font(.title2)
                .foregroundColor(status.tintColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(status.title)
                    .font(.headline)
                Text(status.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if status.isDismissible {
                Button("Готово") {
                    onDismiss()
                }
                .foregroundColor(.primary)
                .buttonStyle(.borderedProminent)
                .tint(.gray.opacity(0.2))
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    PurchaseStatusView(
        status: .success(title: "Подписка активирована", message: "Действительна до 10 декабря"),
        onDismiss: {}
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
