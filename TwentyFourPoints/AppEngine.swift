//
//  AppEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import Foundation

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

class TFEngine: ObservableObject {
    //TODO: Add konami code
    @Published var cs: [card]
    
    @Published var cA: [Bool]
    
    var buttonsCanPress=false
    @Published var expr: String="Expression"
    
    @Published var stored: Double?
    
    @Published var oprButtonActive: Bool = false // activate this when any number is pressed. and thus an opertor could be used.
    
    init() {
        cs=[card(CardIcon: .club, numb: 1),card(CardIcon: .diamond, numb: 5),card(CardIcon: .heart, numb: 10),card(CardIcon: .spade, numb: 12)]
        cA=Array.init(repeating: false, count: 4)
        //persistent data: the current 24-points thing, how many questions you are on
    }
    
    func handleOprPress(Opr:opr) {
        // replace whatever operator is currently in use. if there's nothing in the expression right now, turn the next number negative.
        
        
    }
    
    func handleNumberPress(index: Int) {
        // if an operator has been pressed, then do the math (and verify)
        // if an operator hasn't been pressed:
        //     if the current expression is empty, put it in the current expression (with any negatives)
        //     else
        //          if storage is empty, put the current expression into storage and put the current number into active expression
        //          else
        //              if the expression in the text field is composite, then put the number into the swap and put the swap number back
        //              else: put the number in the text field back and put the current number into the text field
        
        
    }
    
    func reset() { //deactivate everything and reset engine
        
    }
    func doStore() {
        //store can only be called if there's something in store or in the expression
        
    }
}
