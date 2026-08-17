import SwiftUI

// Paymob's SDK needs a concrete UIViewController to present from (`presentPayVC(VC:...)`);
// SwiftUI has no first-class way to obtain "the current view controller", so this bridges via
// UIViewControllerRepresentable and reports its host back through `onResolve` once attached.
struct ViewControllerResolver: UIViewControllerRepresentable {
    let onResolve: (UIViewController?) -> Void

    func makeUIViewController(context: Context) -> ResolverViewController {
        let viewController = ResolverViewController()
        viewController.onResolve = onResolve
        return viewController
    }

    func updateUIViewController(_ uiViewController: ResolverViewController, context: Context) {}

    final class ResolverViewController: UIViewController {
        var onResolve: ((UIViewController?) -> Void)?

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            onResolve?(parent)
        }
    }
}
