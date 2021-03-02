//
//  konamiView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/23.
//

import SwiftUI

struct konamiButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .animation(springAnimation)
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
            .animation(.easeInOut(duration: 0.07))
    }
}

struct konamiView: View {
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator=false
        formatter.maximum=1000000000
        return formatter
    }()
    var tfengine:TFEngine
    @State var levelInput:Int
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("I solemnly swear that I am up to no good")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.bottom,15)
            HStack(spacing:14) {
                TextField("Level", value: $levelInput, formatter: formatter)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.center)
                    .padding(3)
                    .padding(.horizontal,15)
                    .background(
                        RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                            .frame(height: 42, alignment: .center)
                            .foregroundColor(.init("ButtonColorActive"))
                    )
                Button(action: {
                    tfengine.konamiLvl(setLvl: levelInput)
                    generateHaptic(hap: .medium)
                }, label: {
                    Circle()
                        .frame(width:42,height:42)
                        .foregroundColor(.init("ButtonColorActive"))
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.init("TextColor"))
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                        )
                })
                .buttonStyle(konamiButtonStyle())
            }.padding(.horizontal,30)
            Spacer()
            if tfengine.konamiLimitation() != 1 {
                Text("The level on this device must be at least \(tfengine.konamiLimitation()). If you want to further lower your level, change the level on your other devices.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }.padding(.horizontal,40)
    }
}

struct konamiView_Previews: PreviewProvider {
    static var previews: some View {
        konamiView(tfengine: TFEngine(isPreview: true), levelInput: TFEngine(isPreview: true).levelInfo.lvl)
    }
}
