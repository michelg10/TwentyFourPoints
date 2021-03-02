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
    var storeClickable: Bool
}

func operatorClickable(mods: [Int]) -> TutProperty {
    var rturn=TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: true, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeClickable: false)
    rturn.skippable=false
    var oprButtonsHighlighted = Array(repeating: false, count: 4)
    for i in mods {
        oprButtonsHighlighted[i] = true
    }
    rturn.oprButtonsHighlighted=oprButtonsHighlighted
    return rturn
}
func numberClickable(mods: [Int]) -> TutProperty {
    var rturn=TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: true, storeClickable: false)
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
let gameMessageProperty = TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false,storeClickable: false)

class tutorialEngine: ObservableObject, tfCallable {
    func logButtonKonami(button: daBtn) {
        // do nothing
    }
    
    func reset() {
        // do nothing
    }
    
    func doStore() {
        
    }
    
    func handleNumberPress(index: Int) {
        
    }
    
    func handleOprPress(Opr: opr) {
        
    }
    
    @Published var curState = 0
    @Published var cards: [card]
    
    @Published var oprButtonsUsable: [Bool]
    @Published var numbButtonsUsable: [Bool]
    @Published var expr: String
    @Published var stored: String?
    
    func getOprButtonsClickable(state: Int) -> [Bool] {
        if !tutState[state].tutProperty.oprButtonsClickable {
            return allFalse
        }
        return tutState[state].tutProperty.oprButtonsHighlighted
    }
    func getNumbButtonsClickable(state: Int) -> [Bool] {
        if !tutState[state].tutProperty.numbButtonsClickable {
            return allFalse
        }
        return tutState[state].tutProperty.numbButtonsHighlighted
    }
    
    var tutState:[TutState]=[
        TutState(stateText: "Each level consists of 4 integers between 1 and 13 and is guaranteed to have an answer.",tutProperty: gameMessageProperty),
        TutState(stateText: "Your goal is to find a way to combine each of the 4 numbers once using the four primary operators get 24.",tutProperty: gameMessageProperty),
        TutState(stateText: "The bottom-most row houses your operator buttons. These allow you to do addition, subtraction, and division.",tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allTrue, oprButtonsClickable: false, numbButtonsHighlighted: allFalse, numbButtonsClickable: false, storeClickable: false)),
        TutState(stateText: "The middle row houses your number buttons. These show you the puzzle.",tutProperty: TutProperty(skippable: true, oprButtonsHighlighted: allFalse, oprButtonsClickable: false, numbButtonsHighlighted: allTrue, numbButtonsClickable: false, storeClickable: false)),
        TutState(stateText: "The solution to this puzzle is 1×1×2×12=24. Try tapping on the first 1.",tutProperty: numberClickable(mods: [0])),
        TutState(stateText: "Now try tapping the multiply", tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: "Now tap the 1", tutProperty: numberClickable(mods: [1])),
        TutState(stateText: "Tap the multiply again", tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: "Tap the 2", tutProperty: numberClickable(mods: [2])),
        TutState(stateText: "Tap the multiply again", tutProperty: operatorClickable(mods: [2])),
        TutState(stateText: "Tap the 12", tutProperty: numberClickable(mods: [2])),
        TutState(stateText: "Congratulations! You’ve completed the puzzle.", tutProperty: gameMessageProperty),
        TutState(stateText: "Some more complex problems require the use of the 􀁱 button. Let's look at one such problem.", tutProperty: gameMessageProperty),
        TutState(stateText: "The solution for this problem is 13×3-3×5. Try multiplying 3 by 5.", tutProperty: gameMessageProperty),
        TutState(stateText: "Now press the 􀁱 button", tutProperty: gameMessageProperty),
        TutState(stateText: "Now try multiplying 3 by 13.", tutProperty: gameMessageProperty),
        TutState(stateText: "Press minus and then press the stored 15 to use it", tutProperty: gameMessageProperty),
        TutState(stateText: "That’s it. Let’s go!", tutProperty: gameMessageProperty)
    ]
    
    init() {
        oprButtonsUsable=Array(repeating:false, count:4)
        numbButtonsUsable=Array(repeating: false, count: 4)
        expr=""
        stored=nil
        cards=[card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1),card(CardIcon: .spade, numb: -1)]
    }
}
