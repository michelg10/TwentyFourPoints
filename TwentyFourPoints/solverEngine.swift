//
//  solverEngine.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/21.
//

import Foundation

class solverEngine: ObservableObject {
    @Published var responderHasFocus: [Bool]
    @Published var cards: [Int]
    init() {
        responderHasFocus=[false,false,false,false]
        cards=[1,1,1,1]
    }
    func nextResponderFocus() {
        for i in 0..<responderHasFocus.count {
            if responderHasFocus[i] {
                responderHasFocus.swapAt(i, (i+1)%4)
                return
            }
        }
    }
    func setCards(ind: Int,val: String) {
        var myVal=val.filter("0123456789".contains)
        if myVal.count>2 {
            myVal=String(myVal.prefix(2))
            nextResponderFocus()
            print("Count too big")
        } else if myVal.count == 2 && cards[ind]<Int(myVal) ?? 0 {
            nextResponderFocus()
            print("Count is 2")
        }
        if myVal.count == 1 && cards[ind]<Int(myVal) ?? 0 {
            if !("0"..."2").contains(myVal.first!) {
                print("Does not contain!")
                nextResponderFocus()
            }
        }
        let myValInt=Int(myVal) ?? 0
        if myValInt <= 24 {
            cards[ind]=myValInt
        }
    }
}
