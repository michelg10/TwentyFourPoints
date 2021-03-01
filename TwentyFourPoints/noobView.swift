//
//  noobView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct noobView: View {
    @State var goAction: Int?
    var tfengine: TFEngine
    
    @State var startClicked=false
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome to\n24 Points")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .padding(.bottom,10)
                Text("Add, subtract, multiply, and divide four integers to get 24")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .padding(.horizontal,50)
            }
            Spacer()
            Button(action: {
                tfengine.generateHaptic(hap: .medium)
                goAction=1
            }, label: {
                borederedButton(title: "Start", clicked: startClicked)
            }).buttonStyle(nilButtonStyle())
            .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                if buttonState == .pressed {
                    startClicked=true
                } else {
                    startClicked=false
                }
            })).padding(.bottom,150)
        }
    }
}

struct noobView_Previews: PreviewProvider {
    static var previews: some View {
        noobView(tfengine: TFEngine(isPreview: true))
    }
}
