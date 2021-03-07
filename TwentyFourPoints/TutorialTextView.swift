//
//  SwiftUIView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct TutorialTextView: View {
    var id: String
    var tutString: String
    var skippable: Bool
    var skipVisible: Bool
    var tuengine:tutorialEngine
    @Binding var finishTutorial: Int?
    var body: some View {
        VStack {
            Spacer()
            Text(tutString)
                .padding(.horizontal,30)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .id(id)
                .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                .animation(springAnimation)
            Spacer()
            HStack {
                if skippable {
                    VStack(spacing:0) {
                        Button(action: {
                            tuengine.updtState()
                            generateHaptic(hap: .medium)
                        }, label: {
                            navBarButton(symbolName: "chevron.forward", active: true)
                                .padding(.top,5)
                                .animation(springAnimation)
                        }).buttonStyle(topBarButtonStyle())
                        .padding(.bottom,8)
                        Text("Next")
                    }.padding(.bottom,10)
                    .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                    .animation(springAnimation)
                }
                if skipVisible {
                    VStack(spacing:0) {
                        Button(action: {
                            finishTutorial=1
                            generateHaptic(hap: .medium)
                        }, label: {
                            navBarButton(symbolName: "chevron.forward.2", active: true)
                                .padding(.top,5)
                                .animation(springAnimation)
                        }).buttonStyle(topBarButtonStyle())
                        .padding(.bottom,8)
                        Text("Skip")
                    }.padding(.bottom,10)
                    .transition(.asymmetric(insertion: .offset(x: -UIScreen.main.bounds.width, y: 0), removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                    .animation(springAnimation)
                }
            }
        }
    }
}

struct TutorialTextView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialTextView(id: "", tutString: "Each puzzle consists of 4 integers between 1 and 13 and is guaranteed to have an answer.\nYour goal is to find a way to use addition, subtraction, and multiplication to get 24.", skippable: true, skipVisible: true, tuengine: tutorialEngine(), finishTutorial: Binding.constant(nil))
    }
}
