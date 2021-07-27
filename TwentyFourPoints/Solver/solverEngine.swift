//
//  solverEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/21.
//

import Foundation

class solverEngine: ObservableObject {
    var whichCardInFocus: Int
    var cards: [Int]?
    var computedSolution: String?
    var showHints: Bool
    var currentCardHasTyped: Bool=false
    weak var tfengine: TFEngine?
    func computeSolution() {
        if cards==nil {
            return
        }
        computedSolution = solution(problemSet: cards!)
    }
    func setCardToFocus(index: Int) {
        if cards == nil {
            return
        }
        whichCardInFocus=index
        currentCardHasTyped = false
        objectWillChange.send()
    }
    init(isPreview: Bool, tfEngine: TFEngine?) {
        if isPreview {
            showHints=true
            cards=[1,2,3,4]
            whichCardInFocus = -1
            computedSolution="Preview"
            return
        }
        showHints=true
        whichCardInFocus = -1
        cards=nil
        tfengine=tfEngine
        
        computeSolution()
    }
    func randomProblem(upperBound: Int) {
        let prob=generateProblem(Int32(upperBound))
        cards=[Int(prob.c1),Int(prob.c2),Int(prob.c3),Int(prob.c4)]
        computedSolution=String(cString: prob.res.data)
        objectWillChange.send()
    }
    func nextResponderFocus() {
        if cards==nil {
            return
        }
        showHints=false
        whichCardInFocus=(whichCardInFocus+1)%4
        currentCardHasTyped = false
        objectWillChange.send()
    }
    func prevResponderFocus() {
        if cards==nil {
            return
        }
        showHints=false
        whichCardInFocus=(whichCardInFocus-1+4)%4
        currentCardHasTyped = false
        objectWillChange.send()
    }
    func handleKeyboardDelete() {
        if whichCardInFocus == -1 {
            return
        }
        let currentCardString=String(cards![whichCardInFocus])
        currentCardHasTyped = true
        if currentCardString.count<1 {
            return
        }
        setCards(ind: whichCardInFocus, val: String(currentCardString[currentCardString.startIndex..<currentCardString.index(currentCardString.endIndex, offsetBy: -1)]))
    }
    func handleKeyboardNumberPress(number: Int) {
        if (whichCardInFocus == -1) {
            return
        }
        if !currentCardHasTyped {
            setCards(ind: whichCardInFocus, val: "")
        }
        currentCardHasTyped = true
        setCards(ind: whichCardInFocus, val: String(cards![whichCardInFocus])+String(number))
    }
    func setCards(ind: Int,val: String) {
        if cards==nil {
            return
        }
        var myVal=val.filter("0123456789".contains)
        if val == myVal+" " {
            nextResponderFocus()
            cards![whichCardInFocus]=0
            objectWillChange.send()
            return
        }
        if myVal == "" {
            myVal="0"
        }
        myVal=String(Int(myVal)!)
        let myValInt=Int(myVal) ?? 0
        if myValInt <= 24 {
            cards![ind]=myValInt
        } else {
            cards![ind]=myValInt/10
        }
        if !cards!.contains(0) {
            computeSolution()
        }
        DispatchQueue.global().async { [self] in
            tfengine!.saveData()
        }
        objectWillChange.send()
    }
}
