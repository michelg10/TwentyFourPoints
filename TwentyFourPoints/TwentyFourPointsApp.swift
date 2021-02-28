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
            mainView(tfengine: TFEngine(isPreview: false))
        }
    }
}
