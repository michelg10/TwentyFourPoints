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
                    tfengine.generateHaptic(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: true)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }
            
            Spacer()
            
            Text("Problem Solver")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
            
            HStack(spacing:12) {
                ForEach((0..<4), id:\.self) { index in
                    Button(action: {
                        if selectedCardIndex != index {
                            tfengine.generateHaptic(hap: .medium)
                            selectedCardIndex=index
                        }
                    }, label: {
                        cardView(active: index != selectedCardIndex, card: card(CardIcon: cardIcon.allCases[index], numb: eachCardState[index]),isStationary: true)
                    }).buttonStyle(cardButtonStyle())
                }
            }.padding(.horizontal,23)

            Picker(selection: $eachCardState[selectedCardIndex], label: Text("Card"), content: {
                ForEach((1...13), id:\.self) { index in
                    Text(String(index)).tag(index)
                }
            }).padding(.bottom,10)
            let arrSrted = eachCardState.sorted()
            let solID=(arrSrted[0]-1)*13*13*13+(arrSrted[1]-1)*13*13+(arrSrted[2]-1)*13+arrSrted[3]-1
            Text(tfengine.cachedSols[solID]==nil ? "No Solution" : "Solution")
                .font(.system(size: 32, weight: .semibold, design: .rounded))
            Text(tfengine.cachedSols[solID] == nil ? " " : tfengine.cachedSols[solID]!.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"))
                .font(.system(size: 24, weight: .medium, design: .rounded))
            
            Spacer()
            
        }.navigationBarHidden(true)
    }
}

struct SolverView_Previews: PreviewProvider {
    static var previews: some View {
        SolverView(tfengine: TFEngine(isPreview: true))
    }
}
