//
//  CardLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct CardLayout: View {
    var card1:card
    var card2:card
    var card3:card
    var card4:card
    
    var tfengine:TFEngine
    var isDummy: Bool
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 100, content: {
            HStack {
                Button(action: {
                    tfengine.handleNumberPress(index: 0)
                }, label: {
                    cardView(number: card1.numb, active: isDummy ? false : tfengine.cA[0], CardIcon: card1.CardIcon)
                })
                Button(action: {
                    tfengine.handleNumberPress(index: 1)
                }, label: {
                    cardView(number: card2.numb, active: isDummy ? false : tfengine.cA[1], CardIcon: card2.CardIcon)
                })
            }
            HStack {
                Button(action: {
                    tfengine.handleNumberPress(index: 2)
                }, label: {
                    cardView(number: card3.numb, active: isDummy ? false : tfengine.cA[2], CardIcon: card3.CardIcon)
                })
                Button(action: {
                    tfengine.handleNumberPress(index: 3)
                }, label: {
                    cardView(number: card4.numb, active: isDummy ? false : tfengine.cA[3], CardIcon: card4.CardIcon)
                })
            }
        }).frame(minWidth: 0, maxWidth: .infinity, minHeight:0,  maxHeight: .infinity, alignment: .center)
    }
}

struct CardLayout_Previews: PreviewProvider {
    static var previews: some View {
        CardLayout(card1: card(CardIcon: .diamond, numb: 13), card2: card(CardIcon: .club, numb: 1), card3: card(CardIcon: .spade, numb: 4), card4: card(CardIcon: .club, numb: 5),tfengine: TFEngine(), isDummy: false)
    }
}
