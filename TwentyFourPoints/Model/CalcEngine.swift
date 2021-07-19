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

class TFCalcEngine: ObservableObject {
    // this engine handles basically everything in the problem screen
    weak var tfengine: TFEngine?
    var cA: [Bool] // which cards are being activated and which are not
    var storedExpr: String?
    var expr: String = "" //update this from getExpr
    var stored: storedVal?
    var mainVal: storedVal? //put any calculation result into here
    var incorText:String
    var selectedOperator : opr?
    var nxtNumNeg:Bool? //set this as nil when its been applied
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an operator could be used.
    
    func updtStoredExpr() {
        if stored != nil {
            storedExpr=dblToString3Precision(x: stored!.value)
        } else {
            storedExpr=nil
        }
    }
    
    func updtExpr() {
        expr=""
        if (nxtNumNeg==true) {
            expr = "-"
        }
        if (mainVal == nil) {
            return
        }
        expr=expr+dblToString3Precision(x: mainVal!.value)
        if (selectedOperator == nil) {
            return
        }
        switch selectedOperator! {
        case .add:
            expr+="+"
        case .div:
            expr+="÷"
        case .mul:
            expr+="×"
        case .sub:
            expr+="-"
        }
    }
    init(isPreview: Bool) {
        incorText=""
        incorShowOpacity=1
        cA = [true, true, true, true]
        if (isPreview) {
            expr = "Expression"
        }
        
        updtExpr()
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
        incorText=""
        tfengine!.hapticGate(hap: .light)
        
        if !cA[index] {
            return
        }
        
        if (selectedOperator == nil) {
            if (mainVal == nil) {
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    cA[index]=false
                    oprButtonActive=true
                }
                mainVal=storedVal(value: Double(tfengine!.curQ.cs[index].numb), source: index)
            } else {
                if mainVal!.source == 4 {
                    // put into storage
                    if (stored == nil) {
                        stored=mainVal
                        mainVal=nil
                    } else {
                        precondition(stored!.source != 4)
                        
                        withAnimation(.easeInOut(duration: cardAniDur)) {
                            cA[stored!.source]=true
                        }
                        
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
                            withAnimation(.easeInOut(duration: cardAniDur)) {
                                cA[mainVal!.source]=true
                                cA[index]=false
                            }
                            mainVal=storedVal(value: Double(tfengine!.curQ.cs[index].numb), source: index)
                        }
                    }
                }
            }
        } else {
            // do the math
            let addendB = Double(tfengine!.curQ.cs[index].numb)
            var pretendcA=cA
            pretendcA[index]=false
            let mathRes:mathResult=doMath(addendB: addendB, noCardsActive: !pretendcA.contains(true))
            if mathRes == .success {
                cA[index]=false
                tfengine!.nextCardView(nxtCardSet: nil)
                tfengine!.incrementLvl()
            } else if mathRes == .cont {
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    cA[index]=false
                }
            } else if mathRes == .failure {
                respondToFailure(isDivByZero: false)
            } else if mathRes == .divByZero {
                respondToFailure(isDivByZero: true)
            }
        }
        updtExpr()
        objectWillChange.send()
    }
    func handleOprPress(Opr:opr) {
        incorText=""
        tfengine!.hapticGate(hap: .light)
        // replace whatever operator is currently in use. if there's nothing in the expression right now, turn the next number negative.
        
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
        
        updtExpr()
        objectWillChange.send()
    }
    func doStore() {
        tfengine!.hapticGate(hap: .light)
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
                oprButtonActive=false
            }
        } else {
            if (mainVal == nil) {
                if nxtNumNeg == true {
                    nxtNumNeg=nil
                    stored!.value *= -1
                }
                mainVal=stored
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    oprButtonActive=true
                    stored=nil
                }
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
                    let mathRturn=doMath(addendB: tmp, noCardsActive: !cA.contains(true))
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
        updtExpr()
        objectWillChange.send()
    }
    func reset() { //deactivate everything and reset engine
        incorText=""
        selectedOperator=nil
        nxtNumNeg=nil
        withAnimation(.easeInOut(duration: cardAniDur)) {
            cA=Array(repeating: true, count: 4)
            oprButtonActive=false
        }
        mainVal=nil
        updtExpr()
        stored=nil
        updtStoredExpr()
        objectWillChange.send()
    }
    
    var incorShowOpacity: Double
    func respondToFailure(isDivByZero: Bool) {
        var currentExpr: String
        if isDivByZero {
            currentExpr=expr+"0"
        } else {
            updtExpr()
            currentExpr=expr
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
}
