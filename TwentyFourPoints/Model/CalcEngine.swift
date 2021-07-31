//
//  CalcEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/7/20.
//

import Foundation
import SwiftUI

struct storedVal {
    var value:Double
    var source:Int
}

enum opr {
    case add
    case sub
    case mul
    case div
}

func dblToString3Precision(x:Double) -> String {
    let testIfInt=Int(x*100000)
    if testIfInt%100000 == 0 {
        return String(Int(testIfInt/100000))
    }
    return String(round(x*1000)/1000)
}

func doubleEquality(a:Double, b:Double) -> Bool {
    if (abs(a-b)<0.00001) {
        return true
    }
    return false
}


//TODO: Highlight the top candidate
class TFCalcEngine: ObservableObject {
    struct CandidateMatch {
        var index: Int
        var number: Double
    }
    // this engine handles basically everything in the problem screen
    weak var tfengine: TFEngine?
    var cardActive: [Bool] // which cards are being activated and which are not
    var storedExpression: String?
    var autocompleteHintExpression: String?
    var expression = "" //update this from getExpr
    var keyboardContents = ""
    var topCandidateMatch: CandidateMatch?
    var stored: storedVal?
    var mainVal: storedVal? //put any calculation result into here
    var incorText:String
    var selectedOperator : opr?
    var nxtNumNeg:Bool? //set this as nil when its been applied
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an operator could be used.
    
    func updtStoredExpr() {
        if stored != nil {
            storedExpression=dblToString3Precision(x: stored!.value)
        } else {
            storedExpression=nil
        }
        objectWillChange.send()
    }
    
    func updateExpression() {
        expression=""
        if (nxtNumNeg==true) {
            expression = "-"
        }
        if (mainVal != nil) {
            expression+=dblToString3Precision(x: mainVal!.value)
        }
        if (selectedOperator != nil) {
            switch selectedOperator! {
            case .add:
                expression+="+"
            case .div:
                expression+="÷"
            case .mul:
                expression+="×"
            case .sub:
                expression+="-"
            }
        }
        if topCandidateMatch == nil {
            autocompleteHintExpression=nil
        } else {
            autocompleteHintExpression=expression+dblToString3Precision(x: topCandidateMatch!.number)
        }
        expression=expression+keyboardContents
        oprButtonActive=(mainVal != nil || topCandidateMatch != nil)
        objectWillChange.send()
    }
    init(isPreview: Bool) {
        incorText=""
        incorShowOpacity=1
        cardActive = [true, true, true, true]
        if (isPreview) {
            expression = "Expression"
        }
        
        updateExpression()
    }
    
    func doMath(addendB: Double, noCardsActive: Bool) -> mathResult {
        let addendA = mainVal!.value * (nxtNumNeg == true ? -1 : 1)
        if selectedOperator == .div && doubleEquality(a: addendB, b: 0) {
            mainVal!.value=0
            selectedOperator = nil
            return .divByZero
        }
        switch selectedOperator! {
        case .add:
            mainVal!.value=addendA+addendB
        case .div:
            mainVal!.value=addendA/addendB
        case .mul:
            mainVal!.value=addendA*addendB
        case .sub:
            mainVal!.value=addendA-addendB
        }
        mainVal!.source=4
        selectedOperator = nil
        
        nxtNumNeg=nil
        
        // check for all empty and 24
        let allEmpty: Bool = noCardsActive && stored == nil
        if allEmpty {
            if doubleEquality(a: abs(mainVal!.value),b: 24) {
                return .success
            } else {
                return .failure
            }
        }
        return .cont
    }
    func handleNumberPress(index: Int) {
        keyboardContents=""
        topCandidateMatch=nil
        incorText=""
        tfengine!.hapticGate(hap: .lightButton)
        
        if !cardActive[index] {
            return
        }
        
        if (selectedOperator == nil) {
            if (mainVal == nil) {
                cardActive[index]=false
                mainVal=storedVal(value: Double(tfengine!.curQ.cs[index].numb), source: index)
            } else {
                if mainVal!.source == 4 {
                    // put into storage
                    if (stored == nil) {
                        stored=mainVal
                        mainVal=nil
                    } else {
                        precondition(stored!.source != 4)
                        
                        cardActive[stored!.source]=true
                        
                        stored=mainVal
                        
                        mainVal=nil
                    }
                    
                    updtStoredExpr()
                    handleNumberPress(index: index)
                } else {
                    if stored == nil {
                        // push into storage
                        stored=mainVal
                        mainVal=nil
                        updtStoredExpr()
                        handleNumberPress(index: index)
                    } else {
                        if mainVal!.source != index {
                            cardActive[mainVal!.source]=true
                            cardActive[index]=false
                            mainVal=storedVal(value: Double(tfengine!.curQ.cs[index].numb), source: index)
                        }
                    }
                }
            }
        } else {
            // do the math
            let addendB = Double(tfengine!.curQ.cs[index].numb)
            var pretendcA=cardActive
            pretendcA[index]=false
            let mathRes:mathResult=doMath(addendB: addendB, noCardsActive: !pretendcA.contains(true))
            if mathRes == .success {
                cardActive[index]=false
                tfengine!.nextCardView(nxtCardSet: nil)
                tfengine!.incrementLvl()
            } else if mathRes == .cont {
                cardActive[index]=false
            } else if mathRes == .failure {
                respondToFailure(isDivByZero: false)
            } else if mathRes == .divByZero {
                respondToFailure(isDivByZero: true)
            }
        }
        updateExpression()
    }
    func handleOprPress(Opr:opr) {
        incorText=""
        tfengine!.hapticGate(hap: .lightButton)
        // replace whatever operator is currently in use. if there's nothing in the expression right now, turn the next number negative.
        
        if topCandidateMatch != nil {
            if topCandidateMatch!.index == -1 {
                doStore()
            } else {
                handleNumberPress(index: topCandidateMatch!.index)
            }
            handleOprPress(Opr: Opr)
            return
        }
        
        if (mainVal == nil) {
            assert(Opr == .sub)
            if (nxtNumNeg == nil) {
                nxtNumNeg = true
            } else {
                nxtNumNeg!.toggle()
            }
        } else {
            selectedOperator = Opr
        }
        
        updateExpression()
    }
    func doStore() {
        if topCandidateMatch != nil {
            if topCandidateMatch!.index == -1 {
                doStore()
            } else {
                handleNumberPress(index: topCandidateMatch!.index)
            }
            doStore()
            return
        }
        
        keyboardContents=""
        topCandidateMatch=nil
        tfengine!.hapticGate(hap: .lightButton)
        //store can only be called if there's something in store or in the expression
        
        //handle operator selected
        //handle disabling operator selection and usage
        
        if (stored == nil) { //put the mainval into stored. it's now empty.
            if (mainVal != nil) {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    mainVal!.value *= -1
                }
                stored=mainVal
                mainVal=nil
                selectedOperator=nil
            }
        } else {
            if (mainVal == nil) {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    stored!.value *= -1
                }
                mainVal=stored
                stored=nil
            } else {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    mainVal!.value *= -1
                }
                if selectedOperator == nil {
                    swap(&mainVal,&stored)
                } else {
                    let tmp=stored!.value
                    stored=nil
                    let mathRturn=doMath(addendB: tmp, noCardsActive: !cardActive.contains(true))
                    if mathRturn == .success {
                        tfengine!.nextCardView(nxtCardSet: nil)
                        tfengine!.incrementLvl()
                    } else if mathRturn == .failure {
                        respondToFailure(isDivByZero: false)
                    } else if mathRturn == .divByZero {
                        respondToFailure(isDivByZero: true)
                    }
                }
            }
        }
        
        updtStoredExpr()
        updateExpression()
    }
    func reset() { //deactivate everything and reset engine
        topCandidateMatch=nil
        keyboardContents=""
        incorText=""
        selectedOperator=nil
        nxtNumNeg=nil
        withAnimation(.easeInOut(duration: cardAniDur)) {
            cardActive=Array(repeating: true, count: 4)
            oprButtonActive=false
        }
        mainVal=nil
        updateExpression()
        stored=nil
        updtStoredExpr()
    }
    
    var incorShowOpacity: Double
    func respondToFailure(isDivByZero: Bool) {
        var currentExpr: String
        if isDivByZero {
            currentExpr=expression+"0"
        } else {
            updateExpression()
            currentExpr=expression
        }
        reset()
        incorText=currentExpr
        let flashDuration=0.2
        objectWillChange.send()
        incorShowOpacity=0.4
        objectWillChange.send()
        DispatchQueue.main.asyncAfter(deadline: .now()+flashDuration) { [self] in
            incorShowOpacity=1.0
            objectWillChange.send()
        }
    }
    func handleKeyboardNumberPress(number: Int?) {
        if number==nil {
            // do autocomplete
            if topCandidateMatch != nil {
                if topCandidateMatch!.index == -1 {
                    doStore()
                } else {
                    handleNumberPress(index: topCandidateMatch!.index)
                }
            }
            topCandidateMatch=nil
            keyboardContents=""
            updateExpression()
            return
        }
        let newKeyboardContents=String((Int(keyboardContents) ?? 0)*10+number!)
        var numberAppearedBefore: [String: Bool]=[:]
        var potentialCandidateMatches: [CandidateMatch]=[]
        if stored != nil {
            potentialCandidateMatches.append(.init(index: -1, number: stored!.value))
        }
        for i in 0..<cardActive.count {
            if cardActive[i] {
                potentialCandidateMatches.append(.init(index: i, number: Double(tfengine!.curQ.cs[i].numb)))
            }
        }
        var candidateMatches: [CandidateMatch]=[]
        for i in potentialCandidateMatches {
            let currentNumber=i.number
            let currentNumberString=String(dblToString3Precision(x: currentNumber))
            if newKeyboardContents.count>currentNumberString.count {
                continue
            }
            if numberAppearedBefore[currentNumberString]==nil&&currentNumberString[currentNumberString.startIndex..<currentNumberString.index(currentNumberString.startIndex, offsetBy: newKeyboardContents.count)]==newKeyboardContents {
                numberAppearedBefore[currentNumberString]=true
                candidateMatches.append(.init(index: i.index, number: currentNumber))
            }
        }
        if candidateMatches.count == 1 {
            topCandidateMatch=nil
            if candidateMatches[0].index == -1 {
                doStore()
            } else {
                handleNumberPress(index: candidateMatches[0].index)
            }
            updateExpression()
        } else if candidateMatches.count>1 {
            candidateMatches.sort { a, b in
                if dblToString3Precision(x: a.number)==newKeyboardContents {
                    return true
                }
                if dblToString3Precision(x: b.number)==newKeyboardContents {
                    return false
                }
                if dblToString3Precision(x: a.number).count == dblToString3Precision(x: b.number).count {
                    return a.number<b.number
                }
                return dblToString3Precision(x: a.number).count > dblToString3Precision(x: b.number).count
            }
            keyboardContents=newKeyboardContents
            topCandidateMatch=candidateMatches[0]
            updateExpression()
        }
    }
}
