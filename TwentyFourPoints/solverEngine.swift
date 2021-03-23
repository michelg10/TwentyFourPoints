//
//  solverEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/21.
//

import Foundation

class solverEngine: ObservableObject {
    @Published var whichResponder: Int
    @Published var cards: [Int]
    @Published var computedSolution: String?
    @Published var showHints: Bool
    func computeSolution() {
        computedSolution = solution(problemSet: cards)
    }
    init(isPreview: Bool) {
        if isPreview {
            showHints=true
            cards=[1,2,3,4]
            whichResponder = -1
            computedSolution="Preview"
            return
        }
        showHints=true
        whichResponder = -1
        cards=[0,0,0,0]
        
        computeSolution()
    }
    func nextResponderFocus() {
        showHints=false
        whichResponder=(whichResponder+1)%4
    }
    func setCards(ind: Int,val: String) {
        var myVal=val.filter("0123456789".contains)
        if myVal == "" {
            myVal="0"
        }
        myVal=String(Int(myVal)!)
        if myVal.count>2 {
            myVal=String(myVal.prefix(2))
            nextResponderFocus()
            print("Count too big")
        } else if myVal.count == 2 && cards[ind]<Int(myVal) ?? 0 {
            nextResponderFocus()
            print("Count is 2")
        }
        if myVal.count == 1 && cards[ind]<Int(myVal) ?? 0 {
            if !("0"..."2").contains(myVal.first!) {
                print("Does not contain!")
                nextResponderFocus()
            }
        }
        let myValInt=Int(myVal) ?? 0
        if myValInt <= 24 {
            cards[ind]=myValInt
        }
        if cards.contains(0) {
            computedSolution=nil
        } else {
            computeSolution()
        }
    }
}
