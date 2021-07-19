//
//  GameCenter.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/7/20.
//

import Foundation
import GameKit

enum gcState {
    case noAuth
    case success
    case couldNotAuth
    case unknown
}

func setGCAuthHandler() -> gcState {
    GKLocalPlayer.local.authenticateHandler = { viewController, error in
        if let viewController = viewController {
            // how about not presenting the view controller since its annoying to the player
            return .noAuth
        }
        if error != nil {
            // Player could not be authenticated
            // Disable Game Center in the game
            return .couldNotAuth
        }
        if GKLocalPlayer.local.isAuthenticated {
            return .success
        }
    }
}
