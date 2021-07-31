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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                HStack {
                    VStack {
                        if horizontalSizeClass == .regular {
                            Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                                .foregroundColor(Color.white)
                                .colorMultiply(foregroundColor)
                                .animation(solverCardAnimation)
                            Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                                .animation(nil)
                                .foregroundColor(Color.white)
                                .colorMultiply(foregroundColor)
                                .animation(solverCardAnimation)
                        } else {
                            Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                                .foregroundColor(foregroundColor)
                            Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                                .foregroundColor(foregroundColor)
                        }
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        if horizontalSizeClass == .regular {
                            Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                                .rotationEffect(.init(degrees: 180))
                                .animation(nil)
                                .foregroundColor(Color.white)
                                .colorMultiply(foregroundColor)
                                .animation(solverCardAnimation)
                            Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                                .rotationEffect(.init(degrees: 180))
                                .foregroundColor(Color.white)
                                .colorMultiply(foregroundColor)
                                .animation(solverCardAnimation)
                        } else {
                            Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                                .rotationEffect(.init(degrees: 180))
                                .foregroundColor(foregroundColor)
                            Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                                .rotationEffect(.init(degrees: 180))
                                .foregroundColor(foregroundColor)
                        }
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
    var active=true
    var tfengine: TFEngine
    
    @State var appliedDragGestureDelta=0
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        let foregroundColor:Color=Color.init("SolverCardForeground" + (cardicon == .diamond || cardicon == .heart ? "Red" : "Black") + (active ? "Active" : "Inactive"))
        Rectangle()
            .fill(Color.clear)
            .aspectRatio(128/177, contentMode: .fit)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        if horizontalSizeClass == .regular {
                            RoundedRectangle(cornerRadius: geometry.size.width*0.1,style: .continuous)
                                .foregroundColor(.white)
                                .colorMultiply(Color(active ? "SolverCard-Active-Bg" : "SolverCard-Inactive-Bg"))
                                .animation(solverCardAnimation)
                            RoundedRectangle(cornerRadius: geometry.size.width*0.07,style: .continuous)
                                .stroke(Color.white, style: StrokeStyle(lineWidth: geometry.size.width*0.013, lineCap: .round, lineJoin: .round))
                                .colorMultiply(foregroundColor)
                                .animation(solverCardAnimation)
                                .padding(geometry.size.width*0.025)
                            Text(numText)
                                .font(.system(size: (geometry.size.width)*0.55, weight: .medium, design: .rounded))
                                .animation(nil)
                                .foregroundColor(.white)
                                .colorMultiply(foregroundColor)
                                .animation(solverCardAnimation)
                        } else {
                            RoundedRectangle(cornerRadius: geometry.size.width*0.1,style: .continuous)
                                .foregroundColor(Color(active ? "SolverCard-Active-Bg" : "SolverCard-Inactive-Bg"))
                            RoundedRectangle(cornerRadius: geometry.size.width*0.07,style: .continuous)
                                .stroke(foregroundColor, style: StrokeStyle(lineWidth: geometry.size.width*0.013, lineCap: .round, lineJoin: .round))
                                .padding(geometry.size.width*0.025)
                            responderTextView(text: $numText, whichResponder: $whichResponder, index: index, textSize: (geometry.size.width)*0.55, textColor: UIColor(foregroundColor))
                        }
                        solverNumView(CardIcon: cardicon, numberString: getStringNameOfNum(num: Int(numText) ?? -1), foregroundColor: foregroundColor)
                    }
                }
            ).gesture(DragGesture().onChanged({ val in
                let shouldDelta=Int(floor(-val.translation.height/60))
                if shouldDelta != appliedDragGestureDelta {
                    let numTextVal=Int(numText) ?? 0
                    var furtherChange=shouldDelta-appliedDragGestureDelta
                    // clip furtherChange
                    if (numTextVal+furtherChange<0) {
                        furtherChange=numTextVal
                    }
                    if numTextVal+furtherChange>24 {
                        furtherChange=24-numTextVal
                    }
                    if furtherChange != 0 {
                        if numTextVal == -furtherChange {
                            numText=""
                        } else {
                            numText=String((Int(numText) ?? 0)+furtherChange)
                        }
                        tfengine.hapticGate(hap: .light)
                    }
                    appliedDragGestureDelta=shouldDelta
                    appliedDragGestureDelta=shouldDelta
                }
            }).onEnded({ _ in
                appliedDragGestureDelta=0
            }))
    }
}

struct SolverTopBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var solengine: solverEngine
    @Binding var mainViewVisible: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var tfengine:TFEngine
    var body: some View {
        HStack {
            Button(action: {
                tfengine.hapticGate(hap: .medium)
                presentationMode.wrappedValue.dismiss()
                mainViewVisible=true
                tfengine.setAccessPointVisible(visible: true)
            }, label: {
                navBarButton(symbolName: "chevron.backward", active: true)
            }).buttonStyle(topBarButtonStyle())
            Spacer()
        }.padding(.top, horizontalSizeClass == .regular ? 15 : 0)
        .padding(.bottom,10)
        VStack(spacing:0) {
            Button(action:{
                tfengine.hapticGate(hap: .medium)
                solengine.randomProblem(upperBound: tfengine.upperBound)
            }, label: {
                Text(NSLocalizedString("ProblemSolver", comment: "solver title"))
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 3)
            }).buttonStyle(textButtonStyle())
            .padding(.top, horizontalSizeClass == .regular ? 21.0 : 0.0)
            if horizontalSizeClass != .regular {
                Text(solengine.showHints ? NSLocalizedString("Tap a card to get started", comment: "solver hint") : NSLocalizedString("Tap space to quickly jump to the next card", comment: "solver hint jump"))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom,10)
                    .padding(.horizontal,25)
            }
        }
    }
}

struct SolverView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var mainViewVisible: Bool
    @ObservedObject var solengine: solverEngine
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var tfengine:TFEngine
    var body: some View {
        VStack(spacing: 0) {
            if horizontalSizeClass == .regular {
                ZStack {
                    SolverTopBar(solengine: solengine, mainViewVisible: $mainViewVisible, tfengine: tfengine)
                }
            } else {
                SolverTopBar(solengine: solengine, mainViewVisible: $mainViewVisible, tfengine: tfengine)
            }
            
            Spacer()
            
            let sidePadding: Double=50.0
            let cardSpacing: Double=0.07
            
            HStack(spacing:horizontalSizeClass == .regular ? CGFloat((Double(UIScreen.main.bounds.width)-2*sidePadding)*cardSpacing) : 12) {
                ForEach((0..<4), id:\.self) { index in
                    if horizontalSizeClass == .regular {
                        Button(action: {
                            solengine.setCardToFocus(index: index)
                        }, label: {
                            solverCard(numText: Binding(get: {
                                solengine.cards![index] == 0 ? "" : String(solengine.cards![index])
                            }, set: { (val) in
                                solengine.setCards(ind: index, val: val)
                            }), whichResponder: Binding(get: {
                                solengine.whichCardInFocus
                            }, set: { (val) in
                                solengine.showHints=false
                                solengine.whichCardInFocus=val
                            }),
                                       index: index,
                                       cardicon: cardIcon.allCases[index],
                                       solengine: solengine,
                                       active: solengine.whichCardInFocus == index,
                                       tfengine: tfengine
                            ).frame(maxWidth: 187)
                        }).buttonStyle(topBarButtonStyle())
                        
                    } else {
                        solverCard(numText: Binding(get: {
                            solengine.cards![index] == 0 ? "" : String(solengine.cards![index])
                        }, set: { (val) in
                            solengine.setCards(ind: index, val: val)
                        }), whichResponder: Binding(get: {
                            solengine.whichCardInFocus
                        }, set: { (val) in
                            solengine.showHints=false
                            solengine.whichCardInFocus=val
                        }),
                                   index: index,
                                   cardicon: cardIcon.allCases[index],
                                   solengine: solengine,
                                   tfengine: tfengine
                        ).frame(maxWidth: 187)
                    }
                }
            }.padding(.horizontal,(horizontalSizeClass == .regular ? CGFloat(sidePadding) : 23))
            
            Text((solengine.computedSolution ?? NSLocalizedString("NoSolution", comment: "nosol")).replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"))
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .padding(.top, (horizontalSizeClass == .regular ? 24.0 : 15.0))
            
            Spacer()
            if horizontalSizeClass == .regular {
                SolverKeyboard(numbersDisabled: Array(repeating: false, count: 10), deleteDisabled: false, prevNextDisabled: solengine.whichCardInFocus == -1, solengine: solengine)
            }
        }.edgesIgnoringSafeArea(horizontalSizeClass == .regular ? [.bottom] : [])
        .background(Color.init("bgColor"))
        .navigationBarHidden(true)
        .onAppear {
            canNavBack=true
            mainViewVisible=false
            tfengine.setAccessPointVisible(visible: false)
            if horizontalSizeClass == .regular {
                solengine.whichCardInFocus=0
            }
        }.onDisappear {
            canNavBack=false
            mainViewVisible=true
            tfengine.setAccessPointVisible(visible: true)
        }
    }
}

struct SolverView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SolverView(mainViewVisible: .constant(false), solengine: solverEngine(isPreview: true, tfEngine: TFEngine(isPreview: true)), tfengine: TFEngine(isPreview: true))
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
