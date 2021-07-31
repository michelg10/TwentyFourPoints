//
//  commonFunctions.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/2.
//

import Foundation
import SwiftUI
import CoreHaptics

enum haptic {
    case lightButton
    case cards
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
    default:
        return
    }
}

class HapticGenerator {
    var engine: CHHapticEngine
    init() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        engine.playsHapticsOnly = true
        engine.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }
        
        engine.resetHandler = {
            
            print("Reset Handler: Restarting the engine.")
            
            do {
                // Try restarting the engine.
                try self.engine.start()                
            } catch {
                print("Failed to start the engine")
            }
        }
        
        // Start the haptic engine for the first time.
        do {
            try self.engine.start()
        } catch {
            print("Failed to start the engine: \(error)")
        }
        
        addObservers()
    }
    
    func generateHapticWithParams(intensity: Float, sharpness: Float) {
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                        value: intensity)
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                        value: sharpness)
        let event = CHHapticEvent(eventType: .hapticTransient,
                                  parameters: [intensityParameter, sharpnessParameter],
                                  relativeTime: 0)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            
            // Create a player to play the haptic pattern.
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate) // Play now.
        } catch let error {
            print("Error creating a haptic transient pattern: \(error)")
        }
    }
    
    func generateHaptic(hap:haptic) {
        switch hap {
        case .lightButton:
            generateHapticWithParams(intensity: 0.57, sharpness: 1.0)
        case .cards:
            generateHapticWithParams(intensity: 0.68, sharpness: 0.25)
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
    
    // Tokens to track whether app is in the foreground or the background:
    private var foregroundToken: NSObjectProtocol?
    private var backgroundToken: NSObjectProtocol?
    
    private func addObservers() {
        backgroundToken = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                                                 object: nil,
                                                                 queue: nil)
        { _ in
            // Stop the haptic engine.
            self.engine.stop(completionHandler: { error in
                if let error = error {
                    print("Haptic Engine Shutdown Error: \(error)")
                    return
                }
            })
        }
        foregroundToken = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                                 object: nil,
                                                                 queue: nil)
        { _ in
            // Restart the haptic engine.
            self.engine.start(completionHandler: { error in
                if let error = error {
                    print("Haptic Engine Startup Error: \(error)")
                    return
                }
            })
        }
    }
}

protocol tfCallable {
    func logButtonKonami(button: daBtn)
    func reset()
    func doStore()
    func handleNumberPress(index: Int)
    func handleOprPress(Opr:opr)
    func hapticGate(hap:haptic)
    func getDoSplit() -> Bool
    func handleKeyboardNumberPress(number: Int?)
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

func solution(problemSet: [Int]) -> String? {
    let solvedData=solve24(Int32(problemSet[0]), Int32(problemSet[1]), Int32(problemSet[2]), Int32(problemSet[3])).data
    let solutionToProblem=String(cString: solvedData!)
    solvedData?.deallocate()
    if solutionToProblem=="nosol" {
        return nil
    }
    return solutionToProblem
}
