//
//  tutorialEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/2.
//

import Foundation

struct TutState {
    var stateText:String
    var skippable: Bool
}

class tutorialEngine {
    var curState = 0
    
    var tutState:[TutState]=[
        TutState(stateText: "Each puzzle consists of 4 integers between 1 and 13 and is guaranteed to have an answer. Your goal is to find a way to combine each of the 4 numbers once using the four primary operators get 24.",skippable: true),
        TutState(stateText: "The bottom-most row houses your operator buttons. These allow you to do addition, subtraction, and division.",skippable: true),
        TutState(stateText: "The middle row houses your number buttons. These show you the puzzle.",skippable: true),
        TutState(stateText: "The solution to this puzzle is 1×1×2×12=24. Try tapping on the first 1.", skippable: false),
        TutState(stateText: "Now try tapping the multiply", skippable: false),
        TutState(stateText: "Now tap the 1", skippable: false),
        TutState(stateText: "Tap the multiply again", skippable: false),
        TutState(stateText: "Tap the 2", skippable: false),
        TutState(stateText: "Tap the multiply again", skippable: false),
        TutState(stateText: "Tap the 12", skippable: false),
        TutState(stateText: "Congratulations! You’ve completed the puzzle.", skippable: true),
        TutState(stateText: "Some more complex problems require the use of the 􀁱 button. Lets look at one such problem.", skippable: true),
        TutState(stateText: "The solution for this problem is 13×3-3×5. Try multiplying 3 by 5.", skippable: false),
        TutState(stateText: "Now press the 􀁱 button", skippable: false),
        TutState(stateText: "Now try multiplying 3 by 13.", skippable: false),
        TutState(stateText: "Press minus and then press the stored 15 to use it", skippable: false),
        TutState(stateText: "That’s it. Let’s go!", skippable: true)
    ]
    
    init() {
        
    }
}
