//
//  personaFocusView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/28.
//

import SwiftUI

struct personaFocusView: View {
    var tfengine:TFEngine
    var focusIndex: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    generateHaptic(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: true)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }.padding(.top,20)
            .padding(.bottom,50)
            PersonaDetail(curLvl: focusIndex)
            Spacer()
            if achievement[focusIndex].specialThanks != nil {
                Text(achievement[focusIndex].specialThanks!)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,50)
                    .foregroundColor(.secondary)
            }
        }.navigationBarHidden(true)
    }
}

struct personaFocusView_Previews: PreviewProvider {
    static var previews: some View {
        personaFocusView(tfengine: TFEngine(isPreview: true),focusIndex: 7)
    }
}
