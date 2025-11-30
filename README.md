## SubscriptionDemo

SwiftUI prototype that demonstrates an onboarding → paywall → main flow with a mocked billing service. The project is intentionally small, so you can review state propagation, MVVM layers, and async payment handling without touching a real StoreKit integration.

### Screens & Demo

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-11-30 at 06.45.08.png" alt="Onboarding screen" width="220" />
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-11-30 at 06.45.17.png" alt="Paywall screen" width="220" />
  <img src="screenshots/Simulator Screenshot - iPhone 16 Pro - 2025-11-30 at 06.45.27.png" alt="Main screen" width="220" />
</div>

<div align="center">
  <video src="screenshots/Simulator Screen Recording - iPhone 16 Pro - 2025-11-30 at 07.01.40.mp4" width="260" controls muted></video>
</div>

### Highlights

- SwiftUI-only UI with onboarding pager, plan selector, and placeholder main view.
- `AppFlowViewModel` drives the navigation flow (`hasFinishedOnboarding`, `hasSubscription`) and persists purchase status with `@AppStorage`.
- `PaywallViewModel` wraps subscription plans, selected plan state, mock billing (`SubscriptionPaymentServicing`), and exposes purchase status for the UI toast.
- Async/await based mock billing service (`MockSubscriptionPaymentService`) that simulates network delay, random errors, and returns fake transaction metadata.
- `PurchaseStatusView` renders a bottom toast showing processing/success/failure with auto-dismiss timers.

### Architecture & Data Flow

1. `SubscriptionDemoApp` launches `RootView`.
2. `RootView` injects three `@StateObject`s (flow, onboarding, paywall view models) and conditionally renders:
   - `OnboardingView` until the onboarding flag flips.
   - `PayWallView` until a mock purchase succeeds.
   - `MainView` afterwards.
3. Child views communicate via closures (`onFinish`, `onPurchase`) and view model updates bubble through `@Published` to swap screens.
4. `PayWallView` calls `paywallViewModel.purchaseSelectedPlan()` inside a `Task`, shows a spinner on the button, and renders `PurchaseStatusView` overlays based on `purchaseStatus`.

### Project Structure

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

### Getting Started

1. Requirements: macOS with Xcode 16.4+ and Swift 5.9+.
2. Open `SubscriptionDemo.xcodeproj`.
3. Select the `SubscriptionDemo` scheme and run on an iOS simulator/device.
4. Tap through onboarding, hit “Continue” on the paywall (mock payment), and observe the status toast.

### Further Study Ideas

- Replace the mock service by implementing `SubscriptionPaymentServicing` with StoreKit 2.
- Add persistence for onboarding progress, multi-tier plans, or promotional pricing.
- Extend UI tests or snapshot tests for the paywall and status toast.
