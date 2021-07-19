//
//  UIRotationObserver.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/7.
//

import Foundation
import SwiftUI

class UIRotationObserver:ObservableObject {
    @Published var isPortrait: Bool = true
    @objc func rotated() {
        self.isPortrait = UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isPortrait ?? false
        print("Rotation update")
    }
    init() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
            isPortrait = UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isPortrait ?? false
        }
    }
}
