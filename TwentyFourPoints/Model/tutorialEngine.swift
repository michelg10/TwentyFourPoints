//
//  tutorialEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/2.
//

import Foundation

struct TutState {
    var stateText:String
    var tutProperty: TutProperty
}

struct TutProperty {
    var skippable:Bool
    var oprButtonsHighlighted: [Bool]
    var oprButtonsClickable: Bool
    var numbButtonsHighlighted: [Bool]
    var numbButtonsClickable: Bool
    var storeHighlighted: Bool
    var storeClickable: Bool
}

func operatorClickable(mods: [Int]) -> TutProperty {
    var rturn=TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: true, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: false, storeClickable: false)
    rturn.skippable=false
    var oprButtonsHighlighted = Array(repeating: false, count: 4)
    for i in mods {
        oprButtonsHighlighted[i] = true
    }
    rturn.oprButtonsHighlighted=oprButtonsHighlighted
    return rturn
}
func numberClickable(mods: [Int]) -> TutProperty {
    var rturn=TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: true, storeHighlighted: false, storeClickable: false)
    rturn.skippable=false
    var numbButtonsHighlighted = Array(repeating: false, count: 4)
    for i in mods {
        numbButtonsHighlighted[i] = true
    }
    rturn.numbButtonsHighlighted=numbButtonsHighlighted
    return rturn
}

let allFalse=[false,false,false,false]
let allTrue=[true,true,true,true]
let gameMessageProperty = TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: false,storeClickable: false)

class tutorialEngine: ObservableObject, tfCallable {
    func handleKeyboardNumberPress(number: Int) {
        if curState==4&&number==1 {
            handleNumberPress(index: 0)
        }
        if curState==6&&number==1 {
            handleNumberPress(index: 0)
        }
        if curState==8&&number==2 {
            handleNumberPress(index: 0)
        }
        if curState==10&&number==1 {
            handleNumberPress(index: 0)
        }
        if curState==13 {
            if expr=="" {
                handleNumberPress(index: (number==3 ? 2 : 3))
            } else {
                if expr=="3×"&&number==5 {
                    handleNumberPress(index: 3)
                } else if expr=="5×"&&number==3 {
                    handleNumberPress(index: 2)
                }
            }
        }
        if curState==15 {
            if expr=="" {
                handleNumberPress(index: (number==1 ? 0 : 1))
            } else {
                if expr=="13×"&&number==3 {
                    handleNumberPress(index: 0)
                } else if expr=="3×"&&number==1 {
                    handleNumberPress(index: 1)
                }
            }
        }
    }
    
    func getDoSplit() -> Bool {
        return true
    }
    
    func getUltraCompetitive() -> Bool {
        return true
    }
    
    func hapticGate(hap: haptic) {
        generateHaptic(hap: hap)
    }
    
    func logButtonKonami(button: daBtn) {
        // do nothing
    }
    
    func reset() {
        // do nothing
    }
    
    func doStore() {
        if curState == 14 {
            hapticGate(hap: .light)
            expr=""
            stored="15"
            updtState()
        }
        if curState == 16 {
            if expr.contains("-") {
                hapticGate(hap: .light)
                expr="24"
                stored=nil
                updtState()
            }
        }
    }
    
    func handleNumberPress(index: Int) {
        print("Handling number press at state \(curState)")
        if curState == 4 {
            hapticGate(hap: .light)
            expr="1"
            updtState()
        }
        if curState == 6 {
            hapticGate(hap: .light)
            expr="1"
            updtState()
        }
        if curState == 8 {
            hapticGate(hap: .light)
            expr="2"
            updtState()
        }
        if curState == 10 {
            hapticGate(hap: .light)
            expr="24"
            updtState()
        }
        if curState == 13 {
            if expr=="" {
                if index == 2 {
                    hapticGate(hap: .light)
                    expr="3"
                } else if index == 3 {
                    hapticGate(hap: .light)
                    expr="5"
                }
                numbButtonsHighlighted[index]=false
            } else {
                if expr.contains("×") {
                    hapticGate(hap: .light)
                    expr="15"
                    updtState()
                }
            }
        }
        if curState == 15 {
            if expr=="" {
                if index==0 {
                    hapticGate(hap: .light)
                    expr="13"
                } else if index == 1 {
                    hapticGate(hap: .light)
                    expr="3"
                }
                numbButtonsHighlighted[index]=false
            } else {
                if expr.contains("×") {
                    hapticGate(hap: .light)
                    expr="39"
                    updtState()
                }
            }
        }
    }
    
    func handleOprPress(Opr: opr) {
        print("Handling button press at state \(curState)")
        if curState == 5 {
            hapticGate(hap: .light)
            expr="1×"
            updtState()
        }
        if curState == 7 {
            hapticGate(hap: .light)
            expr="1×"
            updtState()
        }
        if curState == 9 {
            hapticGate(hap: .light)
            expr="2×"
            updtState()
        }
        if curState == 13 {
            if expr.firstIndex(of: "×") == nil && expr != "" {
                hapticGate(hap: .light)
                expr+="×"
            }
        }
        if curState == 15 {
            if expr.firstIndex(of: "×") == nil && expr != "" {
                hapticGate(hap: .light)
                expr+="×"
            }
        }
        if curState == 16 {
            if expr.firstIndex(of: "-") == nil && expr != "" {
                hapticGate(hap: .light)
                expr+="-"
            }
        }
    }
    
    @Published var curState = 0
    @Published var cards: [card]
    
    @Published var oprButtonsHighlighted: [Bool]
    @Published var numbButtonsHighlighted: [Bool]
    @Published var expr: String
    @Published var stored: String?
    
    func getOprButtonsClickable() -> [Bool] {
        if !tutState[curState].tutProperty.oprButtonsClickable {
            return allFalse
        }
        return oprButtonsHighlighted
    }
    func getNumbButtonsClickable() -> [Bool] {
        if !tutState[curState].tutProperty.numbButtonsClickable {
            return allFalse
        }
        return numbButtonsHighlighted
    }
    
    func updtState() {
        curState+=1
        oprButtonsHighlighted=tutState[curState].tutProperty.oprButtonsHighlighted
        numbButtonsHighlighted=tutState[curState].tutProperty.numbButtonsHighlighted
        if curState == 3 {
            for i in 0..<4 {
                cards[i].numb=i+1
            }
        }
        if curState == 4 {
            cards=[card(CardIcon: .club, numb: 1),card(CardIcon: .club, numb: 1),card(CardIcon: .club, numb: 2),card(CardIcon: .club, numb: 12)]
        }
        if curState == 12 {
            expr=""
        }
        if curState == 13 {
            cards=[card(CardIcon: .club, numb: 13),card(CardIcon: .club, numb: 3),card(CardIcon: .club, numb: 3),card(CardIcon: .club, numb: 5)]
        }
    }
    
    var tutState:[TutState]=[
        TutState(stateText: NSLocalizedString("tutorialStage1", comment: ""),tutProperty: gameMessageProperty),
        TutState(stateText: NSLocalizedString("tutorialStage2", comment: ""),tutProperty: gameMessageProperty),
        TutState(stateText: NSLocalizedString("tutorialStage3", comment: ""),tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allTrue, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: false, storeClickable: false)),
        TutState(stateText: NSLocalizedString("tutorialStage4", comment: ""),tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allTrue, numbButtonsClickable: false, storeHighlighted: false, storeClickable: false)),
        TutState(stateText: NSLocalizedString("tutorialStage5", comment: ""),tutProperty: numberClickable(mods: [0])),
        TutState(stateText: NSLocalizedString("tutorialStage6", comment: ""), tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: NSLocalizedString("tutorialStage7", comment: ""), tutProperty: numberClickable(mods: [1])),
        TutState(stateText: NSLocalizedString("tutorialStage8", comment: ""), tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: NSLocalizedString("tutorialStage9", comment: ""), tutProperty: numberClickable(mods: [2])),
        TutState(stateText: NSLocalizedString("tutorialStage10", comment: ""), tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: NSLocalizedString("tutorialStage11", comment: ""), tutProperty: numberClickable(mods: [3])),
        TutState(stateText: NSLocalizedString("tutorialStage12", comment: ""), tutProperty: gameMessageProperty),
        TutState(stateText: NSLocalizedString("tutorialStage13", comment: ""), tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: true, storeClickable: false)),
        TutState(stateText: NSLocalizedString("tutorialStage14", comment: ""), tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: [false,false,true,false], oprButtonsClickable: true, numbButtonsHighlighted: [false,false,true,true], numbButtonsClickable: true, storeHighlighted: false, storeClickable: false)),
        TutState(stateText: NSLocalizedString("tutorialStage15", comment: ""), tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: true, storeClickable: true)),
        TutState(stateText: NSLocalizedString("tutorialStage16", comment: ""), tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: [false,false,true,false], oprButtonsClickable: true, numbButtonsHighlighted: [true,true,false,false], numbButtonsClickable: true, storeHighlighted: true, storeClickable: false)),
        TutState(stateText: NSLocalizedString("tutorialStage17", comment: ""), tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: [false,true,false,false], oprButtonsClickable: true, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: true, storeClickable: true)),
        TutState(stateText: NSLocalizedString("tutorialStage18", comment: ""), tutProperty: gameMessageProperty)
    ]
    
    init() {
        oprButtonsHighlighted=Array(repeating:false, count:4)
        numbButtonsHighlighted=Array(repeating: false, count: 4)
        expr=""
        stored=nil
        cards=[card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1)]
    }
}
