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

struct ProblemView: View {
    @ObservedObject var tfengine:TFEngine
    @State var draggedAmt: CGSize = .zero
    @State var displaceDrag: CGFloat = .zero
    var body: some View {
        VStack {
            TopBar(tfengine:tfengine)
                .padding(.bottom,20)
            if tfengine.konamiCheatVisible {
                konamiView(tfengine: tfengine, levelInput: tfengine.lvl)
                    .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                    .animation(.spring())
            } else {
                CardLayout(tfengine: tfengine, cA: tfengine.cA, cs: tfengine.cs, operational: tfengine.cardsClickable)
                    .padding(.horizontal,30)
                    .id("MasterCardLayoutView"+tfengine.curQuestionID.uuidString)
                    .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                    .animation(.spring())
                    .offset(x: (draggedAmt.width < 0 ? -2*sqrt(-draggedAmt.width) : draggedAmt.width) + displaceDrag, y: 0)
                    .background(Color.init(white: 0,opacity: 0.0001))
                    .simultaneousGesture(DragGesture()
                                            .onChanged({ (value) in
                                                draggedAmt=value.translation
                                                tfengine.cardsClickable=false
                                            }).onEnded({ (value) in
                                                if value.predictedEndTranslation.width > UIScreen.main.bounds.width*0.5 {
                                                    draggedAmt = .zero
                                                    tfengine.nextCardView()
                                                } else {
                                                    draggedAmt = .zero
                                                }
                                                tfengine.cardsClickable=true
                                            }))
            }
            buttons(tfengine: tfengine, buttonsDisabled: tfengine.konamiCheatVisible)
                .padding(.horizontal,15)
                .padding(.bottom,50)
                .padding(.top,23)
        }.navigationBarHidden(true)
    }
}

struct ProblemView_Previews: PreviewProvider {
    static var previews: some View {
//        ProblemView(tfengine: TFEngine())
//            .previewDevice("iPhone 8")
        ProblemView(tfengine: TFEngine())
            .previewDevice("iPhone 12")
//        ProblemView(tfengine: TFEngine())
//            .previewDevice("iPhone 12 Pro Max")
    }
}
