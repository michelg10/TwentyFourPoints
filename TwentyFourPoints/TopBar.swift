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
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                    tfengine.nextCardView()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.init("TopButtonColor"))
                            .frame(width:45,height:45)
                        Image(systemName: "questionmark")
                            .foregroundColor(.init("TextColor"))
                            .font(.system(size:25))
                    }
                }).buttonStyle(topBarButtonStyle())
                Spacer()
                Button(action: {
                    tfengine.nextCardView()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.init("TopButtonColor"))
                            .frame(width:45,height:45)
                        Image(systemName: "chevron.forward.2")
                            .foregroundColor(.init("TextColor"))
                            .font(.system(size:22))
                            .padding(.leading,3)
                    }
                }).buttonStyle(topBarButtonStyle())
            }
            VStack {
                Text("24 Points")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
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
