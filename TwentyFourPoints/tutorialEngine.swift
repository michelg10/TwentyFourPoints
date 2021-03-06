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
            expr=""
            stored="15"
            updtState()
        }
        if curState == 16 {
            if expr.contains("-") {
                expr="24"
                stored=nil
                updtState()
            }
        }
    }
    
    func handleNumberPress(index: Int) {
        print("Handling number press at state \(curState)")
        if curState == 4 {
            expr="1"
            updtState()
        }
        if curState == 6 {
            expr="1"
            updtState()
        }
        if curState == 8 {
            expr="2"
            updtState()
        }
        if curState == 10 {
            expr="24"
            updtState()
        }
        if curState == 13 {
            if expr=="" {
                if index == 2 {
                    expr="3"
                } else if index == 3 {
                    expr="5"
                }
                numbButtonsHighlighted[index]=false
            } else {
                if expr.contains("×") {
                    expr="15"
                    updtState()
                }
            }
        }
        if curState == 15 {
            if expr=="" {
                if index==0 {
                    expr="13"
                } else if index == 1 {
                    expr="3"
                }
                numbButtonsHighlighted[index]=false
            } else {
                if expr.contains("×") {
                    expr="39"
                    updtState()
                }
            }
        }
    }
    
    func handleOprPress(Opr: opr) {
        print("Handling button press at state \(curState)")
        if curState == 5 {
            expr="1×"
            updtState()
        }
        if curState == 7 {
            expr="1×"
            updtState()
        }
        if curState == 9 {
            expr="2×"
            updtState()
        }
        if curState == 13 {
            if expr.firstIndex(of: "×") == nil {
                expr=expr+"×"
            }
        }
        if curState == 15 {
            if expr.firstIndex(of: "×") == nil {
                expr=expr+"×"
            }
        }
        if curState == 16 {
            if expr.firstIndex(of: "-") == nil {
                expr=expr+"-"
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
        TutState(stateText: "Each level consists of 4 integers between 1 and 13 and is guaranteed to have an answer.",tutProperty: gameMessageProperty),
        TutState(stateText: "Your goal is to find a way to combine each of the 4 numbers once using the four primary operators get 24.",tutProperty: gameMessageProperty),
        TutState(stateText: "The bottom-most row houses your operator buttons. These allow you to do addition, subtraction, and division.",tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allTrue, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: false, storeClickable: false)),
        TutState(stateText: "The middle row houses your number buttons. These show you the puzzle.",tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allTrue, numbButtonsClickable: false, storeHighlighted: false, storeClickable: false)),
        TutState(stateText: "The solution to this puzzle is 1×1×2×12=24. Try tapping on the first 1.",tutProperty: numberClickable(mods: [0])),
        TutState(stateText: "Now try tapping the multiply", tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: "Now tap the 1", tutProperty: numberClickable(mods: [1])),
        TutState(stateText: "Tap the multiply again", tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: "Tap the 2", tutProperty: numberClickable(mods: [2])),
        TutState(stateText: "Tap the multiply again", tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: "Tap the 12", tutProperty: numberClickable(mods: [3])),
        TutState(stateText: "Congratulations! You’ve completed the puzzle.", tutProperty: gameMessageProperty),
        TutState(stateText: "Some more complex problems require the use of the store button. Let's look at one such problem.", tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: true, storeClickable: false)),
        TutState(stateText: "The solution for this problem is 13×3-3×5. Try multiplying 3 by 5.", tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: [false,false,true,false], oprButtonsClickable: true, numbButtonsHighlighted: [false,false,true,true], numbButtonsClickable: true, storeHighlighted: false, storeClickable: false)),
        TutState(stateText: "Now press the store button", tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: true, storeClickable: true)),
        TutState(stateText: "Now try multiplying 3 by 13.", tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: [false,false,true,false], oprButtonsClickable: true, numbButtonsHighlighted: [true,true,false,false], numbButtonsClickable: true, storeHighlighted: true, storeClickable: false)),
        TutState(stateText: "Press minus and then press the stored 15 to use it", tutProperty: TutProperty(skippable: false, oprButtonsHighlighted: [false,true,false,false], oprButtonsClickable: true, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeHighlighted: true, storeClickable: true)),
        TutState(stateText: "That’s it. Let’s go!", tutProperty: gameMessageProperty)
    ]
    
    init() {
        oprButtonsHighlighted=Array(repeating:false, count:4)
        numbButtonsHighlighted=Array(repeating: false, count: 4)
        expr=""
        stored=nil
        cards=[card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1)]
    }
}
