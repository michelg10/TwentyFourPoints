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
            .animation(.easeInOut(duration: 0.07))
    }
}

struct TopBar: View {
    @ObservedObject var tfengine: TFEngine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                    if !tfengine.konamiCheatVisible {
                        presentationMode.wrappedValue.dismiss()
                        tfengine.reset()
                    }
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: !tfengine.konamiCheatVisible)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
                Button(action: {
                    if tfengine.konamiCheatVisible {
                        tfengine.konamiLvl(lvl: nil)
                    } else {
                        tfengine.nextCardView()
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
                Text("\(tfengine.lvlName) • Question \(String(tfengine.lvl))")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }.padding(.top,25)
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(tfengine: TFEngine())
    }
}
