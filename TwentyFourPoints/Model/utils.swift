//
//  utils.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/7/20.
//

import Foundation

func getQuestionLvlIndex(getLvl:Int) -> Int {
    if getLvl < lvlachievement[0].lvlReq {
        return -1
    }
    for i in 0..<lvlachievement.count {
        if getLvl >= lvlachievement[lvlachievement.count-i-1].lvlReq {
            return lvlachievement.count-i-1
        }
    }
    return -1
}

func getSpeedLvlIndex(getLvl: Double) -> Int {
    if getLvl < speedAchievement[0].speedReq {
        return -1
    }
    for i in 0..<lvlachievement.count {
        if getLvl >= speedAchievement[speedAchievement.count-i-1].speedReq {
            return speedAchievement.count-i-1
        }
    }
    return -1
}

