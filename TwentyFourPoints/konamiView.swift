//
//  konamiView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/23.
//

import SwiftUI

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
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .padding(3)
                    .padding(.horizontal,15)
                    .background(
                        RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                            .frame(height: 42, alignment: .center)
                            .foregroundColor(.init("ButtonColorActive"))
                    )
                Button(action: {
                    tfengine.konamiLvl(lvl: levelInput)
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
                .buttonStyle(bottomButtonStyle())
            }.padding(.horizontal,30)
            Spacer()
            Text("Setting your level to a lower value may cause cloud sync issues")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }.padding(.horizontal,40)
    }
}

struct konamiView_Previews: PreviewProvider {
    static var previews: some View {
        konamiView(tfengine: TFEngine(), levelInput: TFEngine().lvl)
    }
}
