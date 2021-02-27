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

struct TopBar: View {
    @State var achPresented: Bool = false
    @ObservedObject var tfengine: TFEngine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    tfengine.cardsOnScreen=false
                    tfengine.reset()
                    tfengine.generateHaptic(hap: .medium)
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: !tfengine.konamiCheatVisible)
                }).buttonStyle(topBarButtonStyle())
                .disabled(tfengine.konamiCheatVisible)
                Spacer()
                Button(action: {
                    if tfengine.konamiCheatVisible {
                        tfengine.konamiLvl(setLvl: nil)
                        tfengine.generateHaptic(hap: .medium)
                    } else {
                        tfengine.nxtButtonPressed()
                    }
                }, label: {
                    if tfengine.konamiCheatVisible {
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
                    tfengine.generateHaptic(hap: .medium)
                    achPresented=true
                    tfengine.cardsOnScreen=false
                }, label: {
                    Text("\(tfengine.lvlName) • Question \(String(tfengine.lvl))")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.init("TextColor"))
                }).buttonStyle(textButtonStyle())
                .sheet(isPresented: $achPresented,onDismiss: {
                    tfengine.cardsOnScreen=true
                }, content: {
                    achievementView()
                })
            }.padding(.top,25)
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(tfengine: TFEngine())
    }
}
