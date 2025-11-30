## SubscriptionDemo

Небольшой SwiftUI-прототип: онбординг, экран подписки и главный экран. Оплата замокана — можно посмотреть, как устроен поток и MVVM, не трогая StoreKit.

### Экраны и демо

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-11-30 at 06.45.08.png" alt="Экран онбординга" width="220" />
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-11-30 at 06.45.17.png" alt="Экран paywall" width="220" />
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-11-30 at 06.45.27.png" alt="Основной экран" width="220" />
</div>

<div align="center">
  <video src="screenshots/Simulator Screen Recording - iPhone 16 Pro - 2025-11-30 at 07.01.40.mp4" width="260" controls muted></video>
</div>

### Что внутри

- Три экрана: пролистываемый онбординг, paywall с выбором тарифа, главный экран (пока заглушка).
- `AppFlowViewModel` — решает, что показывать (`hasFinishedOnboarding`, `hasSubscription`), статус покупки пишет в `@AppStorage`.
- `PaywallViewModel` — тарифы, выбранный план, вызов мок-сервиса оплаты, статус для тоста.
- `MockSubscriptionPaymentService` — async/await, имитирует задержку и иногда падает с ошибкой.
- `PurchaseStatusView` — тост внизу экрана (идёт оплата / успех / ошибка), сам скрывается.

### Как устроено

`RootView` держит три view model и по флагам показывает: онбординг → paywall → главный экран. Экран меняется, когда срабатывают колбэки `onFinish` / `onPurchase` и обновляются `@Published`. На paywall кнопка вызывает `purchaseSelectedPlan()` в `Task`, крутится спиннер, тост показывает результат.

### Структура проекта

```
SubscriptionDemo/
├── AppFlowViewModel.swift
├── OnboardingView.swift / OnboardingViewModel.swift
├── PayWallView.swift
├── PaywallViewModel.swift
├── PurchaseStatusView.swift
├── SubscriptionPaymentService.swift
├── MainView.swift
├── RootView.swift
└── Assets.xcassets
```




