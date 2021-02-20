//
//  AppEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import Foundation
import SwiftUI

enum cardIcon {
    case heart
    case club
    case spade
    case diamond
}

enum opr {
    case add
    case sub
    case mul
    case div
}

struct card {
    var CardIcon:cardIcon
    var numb:Int
}

struct storedVal {
    var value:Double
    var source:Int
}
class TFEngine: ObservableObject {
    //TODO: Add konami code
    @Published var viewOverride:Int?
    @Published var cs: [[card]] //card set
    
    @Published var cA: [Bool] // which cards are being activated and which are not
    
    var buttonsCanPress=false
    
    func dblToString3Precision(x:Double) -> String {
        let testIfInt=Int(x*100000)
        if testIfInt%100000 == 0 {
            return String(Int(testIfInt/100000))
        }
        return String(round(x*1000)/1000)
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
    
    @Published var expr: String //update this from getExpr
    
    @Published var stored: storedVal?
    
    var mainVal: storedVal? //put any calculation result into here
    
    @Published var lvl: Int //the current level
    
    @Published var lvlName: String //update this from getLvlName
    func updtLvlName() {
        lvlName = "Level"
    }
    
    var selectedOperator : opr?
    var storedExpr: String?
    
    @Published var viewDoneAnimating: Bool
    @Published var curActiveView:Int
    @Published var curShownView:Int?
    
    func updtStoredExpr() {
        if stored != nil {
            storedExpr=dblToString3Precision(x: stored!.value)
        } else {
            storedExpr=nil
        }
    }
    
    var nxtNumNeg:Bool? //set this as nil when its been applied
    
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an opertor could be used.
    
    init() {
        //load from persistent store
        cs=[[card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 5),card(CardIcon: .heart, numb: 10),card(CardIcon: .spade, numb: 12)],[card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 2),card(CardIcon: .heart, numb: 3),card(CardIcon: .spade, numb: 4)]]
        cA=[true, true, true,true]
        
        //persistent data: the current 24-points thing, how many questions you are on
        lvl=12345
        expr=""
        lvlName=""
        curActiveView=0
        viewDoneAnimating=true
        
        updtExpr()
        updtLvlName()
    }
    
    let viewAnimationTime=4
    
    func handleOprPress(Opr:opr) {
        curActiveView=1-curActiveView
        viewDoneAnimating=false
        withAnimation(.easeInOut(duration: Double(viewAnimationTime))) {
            curShownView=curActiveView
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+Double(viewAnimationTime)) { [self] in
            viewDoneAnimating=true
        }
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
    }
    let cardAniDur=0.17
    func handleNumberPress(index: Int) {
        // push into konami list and check for konami
        
        if !cA[index] {
            return
        }
        
        if (selectedOperator == nil) {
            if (mainVal == nil) {
                withAnimation(.easeInOut(duration: cardAniDur)) {
                    cA[index]=false
                    oprButtonActive=true
                }
                mainVal=storedVal(value: Double(cs[curActiveView][index].numb), source: index)
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
                        
                        //push out what is currently in storage back to the cards
                    }
                    
                    updtStoredExpr()
                    handleNumberPress(index: index)
                } else {
                    if mainVal!.source != index {
                        withAnimation(.easeInOut(duration: cardAniDur)) {
                            cA[mainVal!.source]=true
                            cA[index]=false
                        }
                        mainVal=storedVal(value: Double(cs[curActiveView][index].numb), source: index)
                    }
                }
            }
        } else {
            // do the math
            let addendA = mainVal!.value * (nxtNumNeg == true ? -1 : 1)
            let addendB = Double(cs[curActiveView][index].numb)
            withAnimation(.easeInOut(duration: cardAniDur)) {
                cA[index]=false
            }
            doMath(addendA: addendA, addendB: addendB)
            nxtNumNeg=nil
            
            // check for all empty and 24
            var allEmpty: Bool = !cA.contains(true) && stored == nil
            
        }
        updtExpr()
    }
    
    func doMath(addendA: Double, addendB: Double) {
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
    }
    
    func reset() { //deactivate everything and reset engine
        selectedOperator=nil
        nxtNumNeg=nil
        withAnimation(.easeInOut(duration: cardAniDur)) {
            for i in 0..<4 {
                cA[i]=true
            }
            oprButtonActive=false
        }
        mainVal=nil
        updtExpr()
        stored=nil
        updtStoredExpr()
    }
    func doStore() {
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
                    doMath(addendA: mainVal!.value * (nxtNumNeg == true ? -1 : 1), addendB: stored!.value)
                    stored=nil
                }
            }
        }
        
        updtStoredExpr()
        updtExpr()
    }
}
