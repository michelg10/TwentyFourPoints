//
//  CardLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct CardLayout: View {
    var tfengine:TFEngine
    var isDummy: Bool
    
    var body: some View {
        VStack(alignment: .center, content: {
            var cardz=(isDummy ? tfengine.dcs : tfengine.cs)
            HStack {
                cardView(card: cardz[0], active: isDummy ? false : tfengine.cA[0], tfengine: tfengine, index: 0)
                cardView(card: cardz[1], active: isDummy ? false : tfengine.cA[1], tfengine: tfengine, index: 1)
            }
            HStack {
                cardView(card: cardz[2], active: isDummy ? false : tfengine.cA[2], tfengine: tfengine, index: 2)
                cardView(card: cardz[3], active: isDummy ? false : tfengine.cA[3], tfengine: tfengine, index: 3)
            }
        }).frame(minWidth: 0, maxWidth: .infinity, minHeight:0,  maxHeight: .infinity, alignment: .center)
    }
}

struct CardLayout_Previews: PreviewProvider {
    static var previews: some View {
        CardLayout(tfengine: TFEngine(), isDummy: false)
            .preferredColorScheme(.light)
    }
}
