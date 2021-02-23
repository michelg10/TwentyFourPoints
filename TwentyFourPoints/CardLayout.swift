//
//  CardLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct cardButtonView: View {
    
    var card: card
    var active: Bool
    
    var tfengine:TFEngine
    var operational:Bool
    var index:Int
    var body: some View {
        ZStack {
            Button(action: {
                tfengine.handleNumberPress(index: index)
            }, label: {
                cardView(active: active, card: card, isStationary: false)
            })
            .buttonStyle(cardButtonStyle())
            .disabled(!active || !operational)
        }
    }
}

struct CardLayout: View {
    var tfengine:TFEngine //tfengine should only serve as an interface
    var cA:[Bool]
    var cs:[card]
    var operational: Bool
    
    var body: some View {
        VStack(alignment: .center,spacing: 40.0, content: {
            HStack(spacing: 30.0) {
                cardButtonView(card: cs[0], active: cA[0], tfengine: tfengine, operational: operational, index: 0)
                cardButtonView(card: cs[1], active: cA[1], tfengine: tfengine, operational: operational, index: 1)
            }
            HStack(spacing: 30.0) {
                cardButtonView(card: cs[2], active: cA[2], tfengine: tfengine, operational: operational, index: 2)
                cardButtonView(card: cs[3], active: cA[3], tfengine: tfengine, operational: operational, index: 3)
            }
        })
    }
}

struct CardLayout_Previews: PreviewProvider {
    static var previews: some View {
        let tfengine=TFEngine()
        CardLayout(tfengine: tfengine, cA:tfengine.cA,cs: tfengine.cs,operational: true)
            .preferredColorScheme(.light)
    }
}
