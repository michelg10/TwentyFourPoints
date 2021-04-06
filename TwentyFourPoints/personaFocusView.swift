//
//  personaFocusView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/28.
//

import SwiftUI

struct personaFocusView: View {
    var tfengine:TFEngine
    var persona: Persona
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: true)
                }).buttonStyle(topBarButtonStyle())
                .hoverEffect(.lift)
                Spacer()
            }.padding(.top,20)
            .padding(.bottom,50)
            PersonaDetail(persona: persona)
            Spacer()
            if persona.detailSpecialThanks != nil {
                Text(persona.detailSpecialThanks!)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,50)
                    .foregroundColor(.secondary)
                    .padding(.bottom,30)
            }
        }.navigationBarHidden(true)
    }
}

struct personaFocusView_Previews: PreviewProvider {
    static var previews: some View {
        personaFocusView(tfengine: TFEngine(isPreview: true), persona: lvlachievement[7])
    }
}
