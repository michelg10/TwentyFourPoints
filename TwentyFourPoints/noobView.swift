//
//  noobView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct noobView: View {
    @State var goAction: Int?
    var tuengine: tutorialEngine
    
    @State var startClicked=false
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    Text(NSLocalizedString("NoobViewTitle", comment: "The title shown at the noob launch screen of the app"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .padding(.bottom,10)
                    Text(NSLocalizedString("NoobViewDesc", comment: "The short description shown at the noob launch screen of the app"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .padding(.horizontal,50)
                }
                Spacer()
                NavigationLink(
                    destination: noobLayout(tuengine: tuengine, tfengine: TFEngine(isPreview: false)),tag: 1,selection: $goAction,
                    label: {
                        EmptyView()
                    })
                Button(action: {
                    generateHaptic(hap: .medium)
                    goAction=1
                }, label: {
                    borederedButton(title: NSLocalizedString("Start", comment: "The start button shown at the noob launch screen of the app"), clicked: startClicked)
                }).buttonStyle(nilButtonStyle())
                .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                    if buttonState == .pressed {
                        startClicked=true
                    } else {
                        startClicked=false
                    }
                }))
                Spacer()
            }.navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
        .background(Color.init("bgColor"))
    }
}

struct noobView_Previews: PreviewProvider {
    static var previews: some View {
        noobView(tuengine: tutorialEngine())
    }
}
