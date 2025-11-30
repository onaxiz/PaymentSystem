//
//  OnboardingViewModel.swift
//  SubscriptionDemo
//
//  Created by Codex on 30.11.2025.
//

import Foundation

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

final class OnboardingViewModel: ObservableObject {
    @Published private(set) var pageIndex: Int = 0
    
    let slides: [OnboardingSlide]
    
    init(slides: [OnboardingSlide] = OnboardingViewModel.defaultSlides) {
        self.slides = slides
    }
    
    var currentSlide: OnboardingSlide {
        slides[pageIndex]
    }
    
    var isLastPage: Bool {
        pageIndex == slides.count - 1
    }
    
    func advance() {
        guard !isLastPage else { return }
        pageIndex += 1
    }
    
    func reset() {
        pageIndex = 0
    }
}

extension OnboardingViewModel {
    static let defaultSlides: [OnboardingSlide] = [
        .init(
            title: "Добро пожаловать",
            subtitle: "Короткое описание с ключевыми преимуществами приложения."
        ),
        .init(
            title: "Готово к работе",
            subtitle: "Расскажите пользователю, что произойдёт дальше и чего ожидать."
        )
    ]
}
