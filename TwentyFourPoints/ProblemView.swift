//
//  ContentView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct ProblemView: View {
    @ObservedObject var tfengine:TFEngine
    @State var draggedAmt: CGSize = .zero
    @State var displaceDrag: CGFloat = .zero
    @Namespace var ns
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                TopBar(tfengine:tfengine)
                    .padding(.bottom,20)
                ZStack {
                    if tfengine.konamiCheatVisible {
                        konamiView(tfengine: tfengine, levelInput: tfengine.lvl)
                            .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                            .animation(.spring(response: 0.45, dampingFraction: 0.825, blendDuration: 0))
                    } else {
                        HStack {
                            CardLayout(tfengine: tfengine, cA: tfengine.cA, cs: tfengine.cs, operational: tfengine.cardsClickable && tfengine.nxtState == .ready, primID: "CardLayoutView"+tfengine.curQuestionID.uuidString)
                                .padding(.horizontal,30)
                                .id("MasterCardLayoutView")
                                .animation(.spring())
                                .offset(x: (draggedAmt.width < 0 ? -2*sqrt(-draggedAmt.width) : draggedAmt.width) + displaceDrag, y: 0)
                                .background(Color.init(white: 0,opacity: 0.0001))
                                .simultaneousGesture(DragGesture()
                                                        .onChanged({ (value) in
                                                            draggedAmt=value.translation
                                                            tfengine.cardsClickable=false
                                                        }).onEnded({ (value) in
                                                            if value.predictedEndTranslation.width > UIScreen.main.bounds.width*0.4 {
                                                                draggedAmt = .zero
                                                                tfengine.nextCardView(nxtCardSet: nil)
                                                            } else {
                                                                draggedAmt = .zero
                                                            }
                                                            tfengine.cardsClickable=true
                                                        }))
                        }
                    }
                }
                buttons(tfengine: tfengine, buttonsDisabled: tfengine.konamiCheatVisible)
                    .padding(.horizontal,15)
                    .padding(.bottom,50)
                    .padding(.top,23)
                Spacer()
            }.ignoresSafeArea(.keyboard,edges: .all)
            .navigationBarHidden(true)
        }
    }
}

struct ProblemView_Previews: PreviewProvider {
    static var previews: some View {
//        ProblemView(tfengine: TFEngine())
//            .previewDevice("iPhone 8")
        ProblemView(tfengine: TFEngine(isPreview: true))
            .previewDevice("iPhone 12")
//        ProblemView(tfengine: TFEngine())
//            .previewDevice("iPhone 12 Pro Max")
    }
}
