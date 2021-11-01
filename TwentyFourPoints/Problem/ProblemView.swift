//
//  ContentView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI
import GameKit

struct ProblemView: View {
    @ObservedObject var tfengine:TFEngine
    @ObservedObject var tfcalcengine: TFCalcEngine
    @State var draggedAmt: CGSize = .zero
    @State var displaceDrag: CGFloat = .zero
    @State var sID: String=""
    @State var confettiEnabled=false
    @State var konamikaren=konamiKaren()
    @ObservedObject var rotationObserver: UIRotationObserver
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let buttonsPadding=horizontalSizeClass == .regular ? 30.0 : 15.0
        print("ProblemView reload")
        return GeometryReader { _ in
            ZStack {
                VStack {
                    TopBar(lvl: tfengine.levelInfo.lvl, lvlName: tfengine.levelInfo.lvlName, konamiCheatVisible: tfengine.konamiCheatVisible, rewardVisible: tfengine.rewardScreenVisible, tfengine:tfengine)
                        .drawingGroup()
                        .padding(.bottom,20)
                        .padding(.top,10)
                    ZStack {
                        if tfengine.konamiCheatVisible {
                            konamiView(tfengine: tfengine, karen: konamikaren)
                                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(springAnimation)
                        } else if (tfengine.rewardScreenVisible) {
                            InGameRankUpView(tfengine: tfengine,newRank: getQuestionLvlIndex(getLvl: tfengine.levelInfo.lvl))
                                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(springAnimation)
                                .onAppear {
                                    sID=UUID().uuidString
                                    confettiEnabled=true
                                }
                        } else {
                            CardLayout(tfengine: tfengine, cA: tfcalcengine.cardActive, cs: tfengine.curQ.cs, cardsShouldVisible: tfengine.cardsShouldVisible, operational: tfengine.cardsClickable && tfengine.nxtState == .ready, primID: "CardLayoutView"+tfengine.curQuestionID.uuidString, instantCompetitive: tfengine.instantCompetitive, rotationObserver: rotationObserver)
                                .padding(.horizontal,30)
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
                                                                tfengine.currentSession=UUID().uuidString
                                                            } else {
                                                                draggedAmt = .zero
                                                            }
                                                            tfengine.cardsClickable=true
                                                        }))
                        }
                    }.drawingGroup()
                    bottomButtons(rotationObserver: rotationObserver, tfengine: tfengine, tfcalcengine: tfcalcengine, buttonsDisabled: tfengine.konamiCheatVisible || tfengine.rewardScreenVisible, buttonsPadding: buttonsPadding)
                        .padding(.horizontal,CGFloat(buttonsPadding))
                        .padding(.bottom,horizontalSizeClass == .regular ? 90.0 : 60.0)
                        .padding(.top,23)
                }
                if confettiEnabled {
                    EmitterView()
                        .id("emit"+sID)
                        .animation(nil)
                        .disabled(true)
                        .zIndex(9999)
                }
            }
//            .ignoresSafeArea(.keyboard,edges: .all) // this would only be required for konami
            .navigationBarHidden(true)
        }.onAppear {
            canNavBack=true
            tfengine.setAccessPointVisible(visible: false)
            tfengine.mainMenuButtonsActive=false
            tfengine.currentSession=UUID().uuidString
        }.onDisappear {
            tfengine.cardsOnScreen=false
            canNavBack=false
            tfengine.mainMenuButtonsActive=true
            tfengine.setAccessPointVisible(visible: true)
        }
    }
}

struct ProblemView_Previews: PreviewProvider {
    static var previews: some View {
        //        ProblemView(tfengine: TFEngine())
        //            .previewDevice("iPhone 8")
        ProblemView(tfengine: TFEngine(isPreview: true), tfcalcengine: TFCalcEngine(isPreview: true), rotationObserver: UIRotationObserver())
            .previewLayout(.fixed(width: 1194, height: 834))
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.verticalSizeClass, .regular)
        //        ProblemView(tfengine: TFEngine())
        //            .previewDevice("iPhone 12 Pro Max")
    }
}
