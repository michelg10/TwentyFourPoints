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
                cardView(card: tfengine.cs[index][0], active: tfengine.cA[index][0], primID: primID+"cv0", tfengine: tfengine, groupIndex:index, index: 0)
                    .id(primID+"-CardView0")
                cardView(card: tfengine.cs[index][1], active: tfengine.cA[index][1], primID: primID+"cv1", tfengine: tfengine, groupIndex:index, index: 1)
                    .id(primID+"-CardView1")
            }
            HStack(spacing: 30.0) {
                cardView(card: tfengine.cs[index][2], active: tfengine.cA[index][2], primID: primID+"cv2", tfengine: tfengine, groupIndex:index, index: 2)
                    .id(primID+"-CardView2")
                cardView(card: tfengine.cs[index][3], active: tfengine.cA[index][3], primID: primID+"cv3", tfengine: tfengine, groupIndex:index, index: 3)
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
