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
            } else {
                mainView(rotationObserver: UIRotationObserver(), tfengine: TFEngine(isPreview: false))
            }
        }
    }
}
