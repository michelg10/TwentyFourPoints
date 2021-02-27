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
}

var achievement: [Achievement] = [
    Achievement(name: "Jonathan",lvlReq: 10, secret: false),
    Achievement(name: "Alex",lvlReq: 50, secret: false),
    Achievement(name: "Michel",lvlReq: 100,secret: false),
    Achievement(name: "Ethan",lvlReq: 200,secret:false),
    Achievement(name: "Ella",lvlReq: 300,secret:false),
    Achievement(name: "Alyx",lvlReq: 400,secret:false),
    Achievement(name: "Mimi",lvlReq: 500,secret:false),
    Achievement(name: "Mike",lvlReq: 750,secret:false),
    Achievement(name: "Sarah",lvlReq: 1000,secret:false),
    Achievement(name: "Max",lvlReq: 2000,secret:false),
    Achievement(name: "Sophie",lvlReq: 3000,secret:false),
    Achievement(name: "Rick Astley",lvlReq: 10000,secret:true)
]
