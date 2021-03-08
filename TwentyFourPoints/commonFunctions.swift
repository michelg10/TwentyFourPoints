//
//  commonFunctions.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/2.
//

import Foundation
import SwiftUI

enum haptic {
    case soft
    case light
    case medium
    case heavy
    case rigid
}

var canNavBack: Bool = true

func generateHaptic(hap:haptic) {
    switch hap {
    case .soft:
        let softHapticsEngine=UIImpactFeedbackGenerator.init(style: .soft)
        softHapticsEngine.impactOccurred()
    case .light:
        let lightHapticsEngine=UIImpactFeedbackGenerator.init(style: .light)
        lightHapticsEngine.impactOccurred()
    case .medium:
        let mediumHapticsEngine=UIImpactFeedbackGenerator.init(style: .medium)
        mediumHapticsEngine.impactOccurred()
    case .heavy:
        let heavyHapticsEngine=UIImpactFeedbackGenerator.init(style: .heavy)
        heavyHapticsEngine.impactOccurred()
    case .rigid:
        let rigidHapticsEngine=UIImpactFeedbackGenerator.init(style: .rigid)
        rigidHapticsEngine.impactOccurred()
    }
}

struct KeyboardShortcutSet {
    var resetButton: KeyEquivalent
    var storeButton: KeyEquivalent
    var numsButton: [KeyEquivalent]
    var oprsButton: [KeyEquivalent]
    var skipButton: KeyEquivalent
}

protocol tfCallable {
    func logButtonKonami(button: daBtn)
    func reset()
    func doStore()
    func handleNumberPress(index: Int)
    func handleOprPress(Opr:opr)
    func hapticGate(hap:haptic)
    func getUltraCompetitive() -> Bool
    func getKeyboardSettings() -> KeyboardShortcutSet
    func getDoSplit() -> Bool
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && canNavBack
    }
}
