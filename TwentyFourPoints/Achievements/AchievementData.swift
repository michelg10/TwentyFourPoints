//
//  AchievementData.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/26.
//

import Foundation
import SwiftUI

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
    .init(title: "Mimi",lvlReq: 500,secret:false,detailDesc: NSLocalizedString("PersonaDescMimi", comment: ""), detailSpecialThanks: NSLocalizedString("MimiSpecialThanks", comment: "")),
    .init(title: "Mike",lvlReq: 750,secret:false,detailDesc: NSLocalizedString("PersonaDescMike", comment: ""), detailSpecialThanks: NSLocalizedString("MikeSpecialThanks", comment: "")),
    .init(title: "Sarah",lvlReq: 1000,secret:false,detailDesc: NSLocalizedString("PersonaDescSarah", comment: "")),
    .init(title: "Max",lvlReq: 2000,secret:false,detailDesc: NSLocalizedString("PersonaDescMax", comment: ""), detailSpecialThanks: NSLocalizedString("MaxSpecialThanks", comment: "")),
    .init(title: "Sophie",lvlReq: 3000,secret:false,detailDesc: NSLocalizedString("PersonaDescSophie", comment: ""), detailSpecialThanks: NSLocalizedString("SophieSpecialThanks", comment: "")),
    .init(title: "Rick Astley",lvlReq: 10000,secret:true,detailDesc: NSLocalizedString("PersonaDescRickAstley", comment: ""), detailSpecialThanks: NSLocalizedString("RickAstleySpecialThanks", comment: ""))
]

let leaderboardUnlockQsThres=30
struct SpeedAchievement: Persona {
    var title: String
    var speedReq: Double
    var qspan: Int // this must be monotonically increasing!
    var detailDesc: String
    var detailSpecialThanks: String?
    
    var detailSubtitle: String {
        return "\(speedReq) / \(qspan) Qs"
    }
}

var speedGroups:[[SpeedAchievement]] = {
    var rturn: [[SpeedAchievement]] = [[]]
    var curGrp: [SpeedAchievement]=[speedAchievement[0]]
    for i in 1..<speedAchievement.count {
        if speedAchievement[i-1].qspan != speedAchievement[i].qspan {
            rturn.append(curGrp)
            curGrp.removeAll()
        }
        curGrp.append(speedAchievement[i])
    }
    return rturn
}()

var speedAchievement: [SpeedAchievement] = [
    .init(title: "Kevin", speedReq: 30, qspan: 10, detailDesc: NSLocalizedString("PersonaDescKevin", comment: "")),
    .init(title: "Derek", speedReq: 20, qspan: 10, detailDesc: NSLocalizedString("PersonaDescDerek", comment: "")),
    .init(title: "Charlie", speedReq: 15, qspan: 15, detailDesc: NSLocalizedString("PersonaDescCharlie", comment: "")),
    .init(title: "Vic", speedReq: 10, qspan: 15, detailDesc: NSLocalizedString("PersonaDescVic", comment: "")),
    .init(title: "George", speedReq: 8, qspan: 30, detailDesc: NSLocalizedString("PersonaDescGeorge", comment: ""), detailSpecialThanks: NSLocalizedString("GeorgeSpecialThanks", comment: "")),
    .init(title: "Nikos", speedReq: 6, qspan: 30, detailDesc: NSLocalizedString("PersonaDescNikos", comment: "")),
    .init(title: "Eric", speedReq: 5, qspan: 30, detailDesc: NSLocalizedString("PersonaDescEric", comment: "")),
    .init(title: "__userDefinable__", speedReq: 4, qspan: 30, detailDesc: "__userDefinedDesc__", detailSpecialThanks: "Special thanks to YOU for playing 24 Points by Michel!"),
]
