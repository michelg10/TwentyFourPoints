//
//  AchievementData.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/26.
//

import Foundation

protocol Persona {
    var title: String { get }
    var detailSubtitle: String { get }
    var detailDesc: String { get }
    var detailSpecialThanks: String? { get }
}

struct LvlAchievement: Persona {
    var title: String
    var lvlReq: Int
    var secret: Bool
    var detailDesc: String
    var detailSpecialThanks: String?
    
    var detailSubtitle: String {
        return NSLocalizedString("lvlReqPrefix",comment:"The LEVEL text in the persona detail view")+String(lvlReq)+NSLocalizedString("lvlReqPostfix",comment:"The LEVEL text in the persona detail view")
    }
}

var lvlachievement: [LvlAchievement] = [
    .init(title: "Jonathan",lvlReq: 10, secret: false,detailDesc: NSLocalizedString("PersonaDescJonathan", comment: "")),
    .init(title: "Harrison", lvlReq: 20, secret: false, detailDesc: NSLocalizedString("PersonaDescHarrison", comment: "")),
    .init(title: "Alex",lvlReq: 50, secret: false,detailDesc: NSLocalizedString("PersonaDescAlex", comment: "")),
    .init(title: "Michel",lvlReq: 100,secret: false,detailDesc: NSLocalizedString("PersonaDescMichel", comment: "")),
    .init(title: "Ethan",lvlReq: 200,secret:false,detailDesc: NSLocalizedString("PersonaDescEthan", comment: "")),
    .init(title: "Ella",lvlReq: 300,secret:false,detailDesc: NSLocalizedString("PersonaDescElla", comment: "")),
    .init(title: "Alyx",lvlReq: 400,secret:false,detailDesc: NSLocalizedString("PersonaDescAlyx", comment: "")),
    .init(title: "Mimi",lvlReq: 500,secret:false,detailDesc: NSLocalizedString("PersonaDescMimi", comment: ""),detailSpecialThanks: NSLocalizedString("MimiSpecialThanks", comment: "")),
    .init(title: "Mike",lvlReq: 750,secret:false,detailDesc: NSLocalizedString("PersonaDescMike", comment: ""),detailSpecialThanks: NSLocalizedString("MikeSpecialThanks", comment: "")),
    .init(title: "Sarah",lvlReq: 1000,secret:false,detailDesc: NSLocalizedString("PersonaDescSarah", comment: "")),
    .init(title: "Max",lvlReq: 2000,secret:false,detailDesc: NSLocalizedString("PersonaDescMax", comment: "")),
    .init(title: "Sophie",lvlReq: 3000,secret:false,detailDesc: NSLocalizedString("PersonaDescSophie", comment: "")),
    .init(title: "Rick Astley",lvlReq: 10000,secret:true,detailDesc: NSLocalizedString("PersonaDescRickAstley", comment: ""))
]

let leaderboardUnlockQsThres=30
struct SpeedAchievement {
    var name: String
    var speedReq: Double
    var qsReq: Int // this must be monotonically increasing!
    var description: String
    var specialThanks: String?
}
var speedAchievement: [SpeedAchievement] = [
    .init(name: "Kevin", speedReq: 30, qsReq: 10, description: NSLocalizedString("PersonaDescKevin", comment: "")),
    .init(name: "Derek", speedReq: 20, qsReq: 10, description: NSLocalizedString("PersonaDescDerek", comment: "")),
    .init(name: "Charlie", speedReq: 15, qsReq: 15, description: NSLocalizedString("PersonaDescCharlie", comment: "")),
    .init(name: "Vic", speedReq: 10, qsReq: 15, description: NSLocalizedString("PersonaDescVic", comment: "")),
    .init(name: "George", speedReq: 8, qsReq: 30, description: NSLocalizedString("PersonaDescGeorge", comment: ""), specialThanks: NSLocalizedString("GeorgeSpecialThanks", comment: "")),
    .init(name: "Nikos", speedReq: 6, qsReq: 30, description: NSLocalizedString("PersonaDescNikos", comment: "")),
    .init(name: "Eric", speedReq: 5, qsReq: 30, description: NSLocalizedString("PersonaDescEric", comment: "")),
    .init(name: "__userDefinable__", speedReq: 4, qsReq: 30, description: "__userDefinedDesc__", specialThanks: "Special thanks to YOU for playing 24 Points by Michel!"),
]
