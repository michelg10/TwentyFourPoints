//
//  noobLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct noobLayout: View {
    @ObservedObject var tuengine: tutorialEngine
    @State var finishTutorial: Int?
    
    var body: some View {
        let curState=tuengine.tutState[tuengine.curState]
        VStack {
            Text("24 Points")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Tutorial")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.init("TextColor"))
            NavigationLink(
                destination: mainView(tfengine: TFEngine(isPreview: false)),
                tag: 1,
                selection: $finishTutorial,
                label: {
                    EmptyView()
                }
            )
            TutorialTextView(id: "ttv"+String(tuengine.curState),
                             tutString: curState.stateText,
                             skippable: curState.tutProperty.skippable && tuengine.curState != tuengine.tutState.count-1,
                             skipVisible: tuengine.curState==0 || tuengine.curState == tuengine.tutState.count-1,
                             tuengine: tuengine,
                             finishTutorial: $finishTutorial
            )
            
            VStack {
                TopButtonsRow(tfengine: tuengine,
                              storeActionEnabled: curState.tutProperty.storeClickable,
                              storeIconColorEnabled: curState.tutProperty.storeHighlighted,
                              storeTextColorEnabled: curState.tutProperty.storeHighlighted,
                              storeRectColorEnabled: curState.tutProperty.storeHighlighted,
                              expr: tuengine.expr,
                              answerShowOpacity: 0,
                              answerText: "",
                              incorShowOpacity: 0,
                              incorText: "",
                              resetActionEnabled: false,
                              resetColorEnabled: true,
                              storedExpr: tuengine.stored
                )
                MiddleButtonRow(colorActive: tuengine.numbButtonsHighlighted,
                                actionActive: tuengine.getNumbButtonsClickable(),
                                cards: tuengine.cards,
                                tfengine: tuengine
                )
                BottomButtonRow(tfengine: tuengine,
                                oprActionActive: tuengine.getOprButtonsClickable(),
                                oprColorActive: tuengine.oprButtonsHighlighted)
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
