//
//  MainView.swift
//  SubscriptionDemo
//
//  Created by Евгения Максимова on 30.11.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Добро пожаловать")) {
                    Text("Подписка активна. Это главный экран приложения.")
                    Text("Здесь может быть список задач, заметок или любой другой контент.")
                }
                
                Section(header: Text("Пример контента")) {
                    Text("Элемент 1")
                    Text("Элемент 2")
                    Text("Элемент 3")
                }
            }
            .navigationTitle("Главный экран")
        }
    }
}

#Preview {
    MainView()
}
