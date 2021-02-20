//
//  CardLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct CardLayout: View {
    @ObservedObject var tfengine:TFEngine
    var index:Int
    var primID: String
    
    var body: some View {
        VStack(alignment: .center,spacing: 40.0, content: {
            HStack(spacing: 30.0) {
                cardView(card: tfengine.cs[index][0], active: index==tfengine.curActiveView ? tfengine.cA[0] : false, primID: primID+"cv0", tfengine: tfengine, index: 0)
                    .id(primID+"-CardView0")
                cardView(card: tfengine.cs[index][1], active: index==tfengine.curActiveView ? tfengine.cA[1] : false, primID: primID+"cv1", tfengine: tfengine, index: 1)
                    .id(primID+"-CardView1")
            }
            HStack(spacing: 30.0) {
                cardView(card: tfengine.cs[index][2], active: index==tfengine.curActiveView ? tfengine.cA[2] : false, primID: primID+"cv2", tfengine: tfengine, index: 2)
                    .id(primID+"-CardView2")
                cardView(card: tfengine.cs[index][3], active: index==tfengine.curActiveView ? tfengine.cA[3] : false, primID: primID+"cv3", tfengine: tfengine, index: 3)
                    .id(primID+"-CardView3")
            }
        })
    }
}

struct CardLayout_Previews: PreviewProvider {
    static var previews: some View {
        CardLayout(tfengine: TFEngine(), index: 0, primID: "")
            .preferredColorScheme(.light)
    }
}
