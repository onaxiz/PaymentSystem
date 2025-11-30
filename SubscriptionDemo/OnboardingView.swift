//
//  OnboardingView.swift
//  SubscriptionDemo
//
//  Created by Евгения Максимова on 30.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text(viewModel.currentSlide.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)

                Text(viewModel.currentSlide.subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            HStack(spacing: 8) {
                ForEach(viewModel.slides.indices, id: \.self) { index in
                    Circle()
                        .fill(index == viewModel.pageIndex ? Color.primary : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }

            Button(action: {
                if viewModel.isLastPage {
                    onFinish()
                } else {
                    viewModel.advance()
                }
            }) {
                Text(viewModel.isLastPage ? "Начать" : "Продолжить")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
    }
}
