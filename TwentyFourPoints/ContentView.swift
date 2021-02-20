//
//  ContentView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

extension AnyTransition {
    static var cardLayoutTrans: AnyTransition { get {
        AnyTransition.modifier(active: myTransitionModifier(ctrl: 1)
            ,identity: myTransitionModifier(ctrl: 0)
        )
    }}
}

struct myTransitionModifier: ViewModifier {
    let ctrl: Double
    func body(content: Content) -> some View {
        content.offset(x: CGFloat(-100*ctrl), y: 0)
    }
}

struct ContentView: View {
    @ObservedObject var tfengine:TFEngine
    var body: some View {
        VStack {
            TopBar(lvl: tfengine.lvl, lvlNm: tfengine.lvlName)
                .padding(.horizontal,20)
                .padding(.bottom,20)
            ForEach((0..<2), id:\.self) { index in
                if tfengine.curActiveView==index {
                    CardLayout(tfengine: tfengine, index: index, primID: "CardLayout"+String(index))
                        .padding(.horizontal,30)
                        .id("MasterCardLayoutView"+String(index))
                        .offset(x: tfengine.curShownView==index ? 0 : -UIScreen.main.bounds.width, y: 0)
                        
                }
            }
            buttons(tfengine: tfengine)
                .padding(.horizontal,15)
                .padding(.bottom,50)
                .padding(.top,23)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 8")
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 12")
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 12 Pro Max")
    }
}
