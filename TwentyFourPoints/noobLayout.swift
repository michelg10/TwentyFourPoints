//
//  noobLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct noobLayout: View {
    @ObservedObject var tuengine: tutorialEngine
    var body: some View {
        let curState=tuengine.tutState[tuengine.curState]
        VStack {
            Text("24 Points")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Tutorial")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.init("TextColor"))
            TutorialTextView(tutString: curState.stateText, skippable: curState.tutProperty.skippable,tuengine: tuengine)
                .id("ttv"+String(tuengine.curState))
                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                .animation(springAnimation)
            VStack {
                TopButtonsRow(tfengine: tuengine,
                              storeActionEnabled: curState.tutProperty.storeClickable,
                              storeIconColorEnabled: curState.tutProperty.storeClickable,
                              storeTextColorEnabled: curState.tutProperty.storeClickable,
                              storeRectColorEnabled: curState.tutProperty.storeClickable,
                              expr: tuengine.expr,
                              answerShowOpacity: 0,
                              answerText: "",
                              incorShowOpacity: 0,
                              incorText: "",
                              resetActionEnabled: false,
                              resetColorEnabled: true,
                              storedExpr: tuengine.stored
                )
                MiddleButtonRow(colorActive: curState.tutProperty.numbButtonsHighlighted,
                                actionActive: tuengine.getNumbButtonsClickable(state: tuengine.curState),
                                cards: tuengine.cards,
                                tfengine: tuengine
                )
                BottomButtonRow(tfengine: tuengine,
                                oprActionActive: tuengine.getOprButtonsClickable(state: tuengine.curState),
                                oprColorActive: curState.tutProperty.oprButtonsHighlighted)
            }.padding(.horizontal,15)
            .padding(.bottom,50)
            .padding(.top,23)
        }.padding(.top,25)
        .navigationBarHidden(true)
        .onAppear {
            canNavBack=false
        }
    }
}

struct noobLayout_Previews: PreviewProvider {
    static var previews: some View {
        noobLayout(tuengine: tutorialEngine())
    }
}
