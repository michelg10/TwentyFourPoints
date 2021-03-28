//
//  TwentyFourPointsApp.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

@main
struct TwentyFourPointsApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.string(forKey: "deviceID") == nil {
                noobView(tuengine: tutorialEngine())
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            } else {
                let tfengine=TFEngine(isPreview: false)
                mainView(rotationObserver: UIRotationObserver(), tfengine: tfengine, solengine: tfengine.solengine)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            }
        }
    }
}

class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touchedView = touches.first?.view, touchedView is UIControl {
            state = .cancelled

        } else if let touchedView = touches.first?.view as? UITextView, touchedView.isEditable {
            state = .cancelled

        } else {
            state = .began
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = AnyGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
