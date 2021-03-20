//
//  SolverView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/22.
//

import SwiftUI
import GameKit

struct SolverView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedCardIndex = 0
    @State var eachCardState=[1,1,1,1]
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var tfengine:TFEngine
    var body: some View {
        VStack(spacing: horizontalSizeClass == .regular ? 20 : 10) {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                    tfengine.setAccessPointVisible(visible: true)
                }, label: {
                    navBarButton(symbolName: "chevron.backward", active: true)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }.padding(.top, horizontalSizeClass == .regular ? 15 : 0)
            
            Spacer()
            
            Text(NSLocalizedString("ProblemSolver", comment: "solver title"))
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
            
            HStack(spacing:12) {
                ForEach((0..<4), id:\.self) { index in
                    Button(action: {
                        if selectedCardIndex != index {
                            tfengine.hapticGate(hap: .medium)
                            selectedCardIndex=index
                        }
                    }, label: {
                        cardView(active: index != selectedCardIndex, card: card(CardIcon: cardIcon.allCases[index], numb: eachCardState[index]),isStationary: true, ultraCompetitive: false)
                    }).buttonStyle(cardButtonStyle())
                    .animation(.easeInOut(duration: competitiveButtonAnimationTime))
                    .padding(.horizontal, horizontalSizeClass == .regular ? 10 : 0)
                }
            }.padding(.horizontal,23)
            
            Picker(selection: $eachCardState[selectedCardIndex], label: Text("Card"), content: {
                ForEach((1...24), id:\.self) { index in
                    Text(String(index)).tag(index)
                }
            }).padding(.bottom,10)
            let solution=tfengine.solution(problemSet: eachCardState)
            Text(solution==nil ? NSLocalizedString("NoSolution", comment: "nosol") : NSLocalizedString("Solution", comment: "sol"))
                .font(.system(size: 32, weight: .semibold, design: .rounded))
            Text(solution == nil ? " " : solution!.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"))
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .padding(.bottom,20)
            
            Spacer()
            
        }
        .background(Color.init("bgColor"))
        .navigationBarHidden(true)
        .onAppear {
            print("Nav back")
            canNavBack=true
            tfengine.setAccessPointVisible(visible: false)
        }.onDisappear {
            print("No nav back")
            canNavBack=false
            tfengine.setAccessPointVisible(visible: true)
        }
    }
}

struct SolverView_Previews: PreviewProvider {
    static var previews: some View {
        SolverView(tfengine: TFEngine(isPreview: true))
    }
}
