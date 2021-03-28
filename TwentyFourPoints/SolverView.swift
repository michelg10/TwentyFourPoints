//
//  SolverView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/22.
//

import SwiftUI
import GameKit

enum responderState {
    case waitingPickup
    case isResponder
    case notResponder
}

struct responderTextView: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var whichResponder: Int
        var index: Int
        
        init(text: Binding<String>,whichResponder : Binding<Int>,index: Int) {
            _text = text
            _whichResponder = whichResponder
            self.index=index
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            print("Text select changed")
            text = textField.text ?? ""
        }
        func textFieldDidBeginEditing(_ textField: UITextField) {
            print("Begins editing")
            whichResponder=index
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("Should return")
            whichResponder=(whichResponder+1)%4
            return true
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            print("End editing")
            whichResponder = -1
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, whichResponder: $whichResponder,index: index)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        print("View update")
        uiView.text = text
        let roundedFont=UIFont.systemFont(ofSize: textSize, weight: .medium)
        uiView.font=UIFont(descriptor: roundedFont.fontDescriptor.withDesign(.rounded)!, size: textSize)
        if whichResponder == index {
            print("Pick up first responder")
            uiView.becomeFirstResponder()
        }
    }
    
    @Binding var text: String
    @Binding var whichResponder : Int
    var index: Int
    var textSize: CGFloat
    var textColor: UIColor
    
    func makeUIView(context: Context) -> UITextField {
        let rturn=UITextField()
        rturn.keyboardType = .numbersAndPunctuation
        rturn.text=text
        let roundedFont=UIFont.systemFont(ofSize: textSize, weight: .medium)
        rturn.font=UIFont(descriptor: roundedFont.fontDescriptor.withDesign(.rounded)!, size: textSize)
        rturn.textColor=textColor
        
        rturn.translatesAutoresizingMaskIntoConstraints=false
        rturn.textAlignment = .center
        rturn.delegate=context.coordinator
        return rturn
    }
}

struct solverNumView: View {
    var CardIcon: cardIcon
    var numberString:String
    var foregroundColor:Color
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                HStack {
                    VStack {
                        Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                        Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                            .rotationEffect(.init(degrees: 180))
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                        Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                            .rotationEffect(.init(degrees: 180))
                            .foregroundColor(Color.white)
                            .colorMultiply(foregroundColor)
                    }
                }
            }).frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical,geometry.size.width*0.07)
            .padding(.horizontal, geometry.size.width*0.06)
        }
    }
}

struct solverCard: View {
    @Binding var numText: String
    @Binding var whichResponder: Int
    var index: Int
    var cardicon: cardIcon
    var solengine: solverEngine
    var isStationary=false
    var ultraCompetitive=false
    var active=true
    var body: some View {
        let foregroundColor:Color=Color.init("CardForeground" + (cardicon == .diamond || cardicon == .heart ? "Red" : "Black") + (active ? "Active" : "Inactive"))
        Rectangle()
            .fill(Color.clear)
            .aspectRatio(128/177, contentMode: .fit)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width*0.1,style: .continuous)
                            .foregroundColor(Color.white)
                            .colorMultiply(Color(active ? "Card-Active-Bg" : "Card-Inactive-Bg"))
                        RoundedRectangle(cornerRadius: geometry.size.width*0.07,style: .continuous)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: geometry.size.width*0.013, lineCap: .round, lineJoin: .round))
                            .colorMultiply(foregroundColor)
                            .padding(geometry.size.width*0.025)
                        responderTextView(text: $numText, whichResponder: $whichResponder, index: index, textSize: (geometry.size.width)*0.55, textColor: UIColor(foregroundColor))
                            .foregroundColor(Color.white)
                        solverNumView(CardIcon: cardicon, numberString: getStringNameOfNum(num: Int(numText) ?? -1), foregroundColor: foregroundColor)
                    }
                }
            )
    }
}

struct SolverView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var solengine: solverEngine
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var tfengine:TFEngine
    var body: some View {
        VStack(spacing: 0) {
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
            .padding(.bottom,10)
            Button(action:{
                solengine.randomProblem(upperBound: tfengine.upperBound)
            }, label: {
                Text(NSLocalizedString("ProblemSolver", comment: "solver title"))
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,3)
            }).buttonStyle(textButtonStyle())
            
            Text(solengine.showHints ? NSLocalizedString("Tap a card to get started", comment: "solver hint") : NSLocalizedString("Tap space to quickly jump to the next card", comment: "solver hint jump"))
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom,10)
                .padding(.horizontal,25)
            
            Spacer()
            HStack(spacing:horizontalSizeClass == .regular ? 24 : 12) {
                ForEach((0..<4), id:\.self) { index in
                    solverCard(numText: Binding(get: {
                        solengine.cards![index] == 0 ? "" : String(solengine.cards![index])
                    }, set: { (val) in
                        solengine.setCards(ind: index, val: val)
                    }), whichResponder: Binding(get: {
                        solengine.whichResponder
                    }, set: { (val) in
                        solengine.showHints=false
                        solengine.whichResponder=val
                    }),
                    index: index,
                    cardicon: cardIcon.allCases[index],
                    solengine: solengine)
                }
            }.padding(.horizontal,(horizontalSizeClass == .regular ? 46 : 23))
            
            Text((solengine.computedSolution ?? NSLocalizedString("NoSolution", comment: "nosol")).replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"))
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .padding(.top,15)
            
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
        SolverView(solengine: solverEngine(isPreview: true, tfEngine: TFEngine(isPreview: true)), tfengine: TFEngine(isPreview: true))
    }
}
