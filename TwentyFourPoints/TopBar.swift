//
//  TopBar.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/19.
//

import SwiftUI

struct topBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
            .animation(.easeInOut(duration: 0.14))
    }
}
struct textButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.14))
    }
}

struct TopBar: View, Equatable {
    static func == (lhs: TopBar, rhs: TopBar) -> Bool {
        return lhs.lvl == rhs.lvl && lhs.konamiCheatVisible == rhs.konamiCheatVisible
    }
    
    var lvl: Int
    var lvlName: String?
    var konamiCheatVisible: Bool
    var tfengine: TFEngine
    @State var achPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    tfengine.cardsOnScreen=false
                    tfengine.reset()
                    generateHaptic(hap: .medium)
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: !konamiCheatVisible)
                }).buttonStyle(topBarButtonStyle())
                .disabled(konamiCheatVisible)
                Spacer()
                Button(action: {
                    if konamiCheatVisible {
                        tfengine.konamiLvl(setLvl: nil)
                        generateHaptic(hap: .medium)
                    } else {
                        tfengine.nxtButtonPressed()
                    }
                }, label: {
                    if konamiCheatVisible {
                        navBarButton(symbolName: "xmark", active: true)
                    } else {
                        navBarButton(symbolName: "chevron.forward.2", active: true)
                    }
                }).buttonStyle(topBarButtonStyle())
            }
            VStack {
                Text("24 Points")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Button(action: {
                    generateHaptic(hap: .medium)
                    achPresented=true
                    tfengine.cardsOnScreen=false
                }, label: {
                    if lvlName == nil {
                        Text("Question \(String(lvl))")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .foregroundColor(.init("TextColor"))
                    } else {
                        Text("\(lvlName!) • Question \(String(lvl))")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .foregroundColor(.init("TextColor"))
                    }
                }).buttonStyle(textButtonStyle())
                .sheet(isPresented: $achPresented,onDismiss: {
                    tfengine.cardsOnScreen=true
                }, content: {
                    achievementView(tfengine: tfengine)
                })
            }.padding(.top,25)
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(lvl:10,lvlName:"Jonathan", konamiCheatVisible: false,tfengine: TFEngine(isPreview: true))
    }
}
