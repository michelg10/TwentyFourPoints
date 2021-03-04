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
    @State var sID: String=""
    @State var confettiEnabled=false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack {
                    Spacer()
                    TopBar(lvl: tfengine.levelInfo.lvl, lvlName: tfengine.levelInfo.lvlName, konamiCheatVisible: tfengine.konamiCheatVisible, rewardVisible: tfengine.rewardScreenVisible, tfengine:tfengine)
                        .equatable()
                        .padding(.bottom,20)
//                    ZStack {
//                        if tfengine.konamiCheatVisible {
//                            konamiView(tfengine: tfengine, levelInput: tfengine.levelInfo.lvl)
//                                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
//                                .animation(springAnimation)
//                        } else if (tfengine.rewardScreenVisible) {
//                            InGameRankUpView(tfengine: tfengine,newRank: tfengine.getLvlIndex(getLvl: tfengine.levelInfo.lvl))
//                                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
//                                .animation(springAnimation)
//                        } else {
//                            CardLayout(tfengine: tfengine, cA: tfengine.cA, cs: tfengine.cs, cardsShouldVisible: tfengine.cardsShouldVisible, operational: tfengine.cardsClickable && tfengine.nxtState == .ready, primID: "CardLayoutView"+tfengine.curQuestionID.uuidString)
//                                .padding(.horizontal,30)
//                                .id("MasterCardLayoutView")
//                                .animation(.spring())
//                                .offset(x: (draggedAmt.width < 0 ? -2*sqrt(-draggedAmt.width) : draggedAmt.width) + displaceDrag, y: 0)
//                                .background(Color.init(white: 0,opacity: 0.0001))
//                                .simultaneousGesture(DragGesture()
//                                                        .onChanged({ (value) in
//                                                            draggedAmt=value.translation
//                                                            tfengine.cardsClickable=false
//                                                        }).onEnded({ (value) in
//                                                            if value.predictedEndTranslation.width > UIScreen.main.bounds.width*0.4 {
//                                                                draggedAmt = .zero
//                                                                tfengine.nextCardView(nxtCardSet: nil)
//                                                            } else {
//                                                                draggedAmt = .zero
//                                                            }
//                                                            tfengine.cardsClickable=true
//                                                        }))
//                        }
//                    }
                    bottomButtons(tfengine: tfengine, buttonsDisabled: tfengine.konamiCheatVisible || tfengine.rewardScreenVisible)
                        .padding(.horizontal,15)
                        .padding(.bottom,50)
                        .padding(.top,23)
                    Spacer()
                }
                EmitterView()
                    .disabled(true)
                    .id(tfengine.curQuestionID.uuidString+"emit")
                    .zIndex(9999)
            }.ignoresSafeArea(.keyboard,edges: .all)
            .navigationBarHidden(true)
        }.onAppear {
            print("Nav back")
            canNavBack=true
        }.onDisappear {
            print("No nav back")
            canNavBack=false
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
