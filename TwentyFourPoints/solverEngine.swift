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
    func randomProblem(upperBound: Int) {
        let prob=generateProblem(Int32(upperBound))
        cards[0]=Int(prob.c1)
        cards[1]=Int(prob.c2)
        cards[2]=Int(prob.c3)
        cards[3]=Int(prob.c4)
        computedSolution=String(cString: prob.res.data)
    }
    func nextResponderFocus() {
        showHints=false
        whichResponder=(whichResponder+1)%4
        cards[whichResponder]=0
    }
    func setCards(ind: Int,val: String) {
        var myVal=val.filter("0123456789".contains)
        if val == myVal+" " {
            nextResponderFocus()
            return
        }
        if myVal == "" {
            myVal="0"
        }
        myVal=String(Int(myVal)!)
//        if myVal.count>2 {
//            myVal=String(myVal.prefix(2))
//            nextResponderFocus()
//            print("Count too big")
//        } else if myVal.count == 2 && cards[ind]<Int(myVal) ?? 0 {
//            nextResponderFocus()
//            print("Count is 2")
//        }
        let myValInt=Int(myVal) ?? 0
        if myValInt <= 24 {
            cards[ind]=myValInt
        } else {
            cards[ind]=myValInt/10
        }
        if !cards.contains(0) {
            computeSolution()
        }
    }
}
