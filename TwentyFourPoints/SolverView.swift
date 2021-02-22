//
//  SolverView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/22.
//

import SwiftUI

struct SolverView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedCardIndex = 0
    @State var eachCardState=[1,1,1,1]
    
    var tfengine:TFEngine
    var body: some View {
        VStack() {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    navBarButton(symbolName: "chevron.backward")
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }
            
            Spacer()
            
            Text("Problem Solver")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
            
            HStack(spacing:12) {
                ForEach((0..<4), id:\.self) { index in
                    cardView(active: index != selectedCardIndex, card: card(CardIcon: cardIcon.allCases[index], numb: eachCardState[index]))
                }
            }.padding(.horizontal,23)

            Picker(selection: $eachCardState[selectedCardIndex], label: Text("Card"), content: {
                ForEach((1...13), id:\.self) { index in
                    Text(String(index)).tag(index)
                }
            })
            Spacer()
            
        }.navigationBarHidden(true)
    }
}

struct SolverView_Previews: PreviewProvider {
    static var previews: some View {
        SolverView(tfengine: TFEngine())
    }
}
