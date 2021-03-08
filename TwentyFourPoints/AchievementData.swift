//
//  AchievementData.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/26.
//

import Foundation

struct Achievement {
    var name: String
    var lvlReq: Int
    var secret: Bool
    var description: String
    var specialThanks: String?
}

var achievement: [Achievement] = [
    Achievement(name: "Jonathan",lvlReq: 10, secret: false,description: NSLocalizedString("PersonaDescJonathan", comment: "")),
    Achievement(name: "Harrison", lvlReq: 20, secret: false, description: NSLocalizedString("PersonaDescHarrison", comment: "")),
    Achievement(name: "Alex",lvlReq: 50, secret: false,description: NSLocalizedString("PersonaDescAlex", comment: "")),
    Achievement(name: "Michel",lvlReq: 100,secret: false,description: NSLocalizedString("PersonaDescMichel", comment: "")),
    Achievement(name: "Ethan",lvlReq: 200,secret:false,description: NSLocalizedString("PersonaDescEthan", comment: "")),
    Achievement(name: "Ella",lvlReq: 300,secret:false,description: NSLocalizedString("PersonaDescElla", comment: "")),
    Achievement(name: "Alyx",lvlReq: 400,secret:false,description: NSLocalizedString("PersonaDescAlyx", comment: "")),
    Achievement(name: "Mimi",lvlReq: 500,secret:false,description: NSLocalizedString("PersonaDescMimi", comment: ""),specialThanks: NSLocalizedString("MimiSpecialThanks", comment: "")), 
    Achievement(name: "Mike",lvlReq: 750,secret:false,description: NSLocalizedString("PersonaDescMike", comment: ""),specialThanks: NSLocalizedString("MikeSpecialThanks", comment: "")),
    Achievement(name: "Sarah",lvlReq: 1000,secret:false,description: NSLocalizedString("PersonaDescSarah", comment: "")),
    Achievement(name: "Max",lvlReq: 2000,secret:false,description: NSLocalizedString("PersonaDescMax", comment: "")),
    Achievement(name: "Sophie",lvlReq: 3000,secret:false,description: NSLocalizedString("PersonaDescSophie", comment: "")),
    Achievement(name: "Rick Astley",lvlReq: 10000,secret:true,description: NSLocalizedString("PersonaDescRickAstley", comment: ""))
]
