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
    @ObservedObject var rotationObserver: UIRotationObserver
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let buttonsPadding=horizontalSizeClass == .regular ? 30.0 : 15.0
        GeometryReader { _ in
            ZStack {
                VStack {
                    Spacer()
                    TopBar(lvl: tfengine.levelInfo.lvl, lvlName: tfengine.levelInfo.lvlName, konamiCheatVisible: tfengine.konamiCheatVisible, rewardVisible: tfengine.rewardScreenVisible, tfengine:tfengine)
                        .equatable()
                        .padding(.bottom,20)
                    ZStack {
                        if tfengine.konamiCheatVisible {
                            konamiView(tfengine: tfengine, levelInput: tfengine.levelInfo.lvl)
                                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(springAnimation)
                        } else if (tfengine.rewardScreenVisible) {
                            InGameRankUpView(tfengine: tfengine,newRank: tfengine.getLvlIndex(getLvl: tfengine.levelInfo.lvl))
                                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(springAnimation)
                                .onAppear {
                                    sID=UUID().uuidString
                                    confettiEnabled=true
                                }
                        } else {
                            CardLayout(tfengine: tfengine, cA: tfengine.cA, cs: tfengine.cs, cardsShouldVisible: tfengine.cardsShouldVisible, operational: tfengine.cardsClickable && tfengine.nxtState == .ready, primID: "CardLayoutView"+tfengine.curQuestionID.uuidString, ultraCompetitive: tfengine.getUltraCompetitive(), rotationObserver: rotationObserver)
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
                                                            if value.predictedEndTranslation.width > UIApplication.shared.windows.first!.frame.width*(horizontalSizeClass == .regular ? 0.2 : 0.4) {
                                                                draggedAmt = .zero
                                                                tfengine.nextCardView(nxtCardSet: nil)
                                                            } else {
                                                                draggedAmt = .zero
                                                            }
                                                            tfengine.cardsClickable=true
                                                        }))
                        }
                    }
                    bottomButtons(rotationObserver: rotationObserver, tfengine: tfengine, buttonsDisabled: tfengine.konamiCheatVisible || tfengine.rewardScreenVisible, buttonsPadding: buttonsPadding)
                        .padding(.horizontal,CGFloat(buttonsPadding))
                        .padding(.bottom,horizontalSizeClass == .regular ? 80.0 : 50.0)
                        .padding(.top,23)
                    Spacer()
                }
                if confettiEnabled {
                    EmitterView()
                        .id("emit"+sID)
                        .animation(nil)
                        .disabled(true)
                        .zIndex(9999)
                }
            }.background(Color.init("bgColor"))
            .ignoresSafeArea(.keyboard,edges: .all)
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
        ProblemView(tfengine: TFEngine(isPreview: true), rotationObserver: UIRotationObserver())
            .previewLayout(.fixed(width: 1194, height: 834))
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.verticalSizeClass, .regular)
        //        ProblemView(tfengine: TFEngine())
        //            .previewDevice("iPhone 12 Pro Max")
    }
}
