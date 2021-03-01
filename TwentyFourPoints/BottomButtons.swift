//
//  BottomButtons.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct bottomButtonView: View {
    let buttonHei=49.0
    let buttonRadius=0.4
    let textSize=0.5
    
    var fillColor:Color
    var textColor:Color
    var text:String
    var id:String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(buttonHei/2.0*buttonRadius),style: .continuous)
                .fill(fillColor)
                .animation(.easeInOut(duration:competitiveTime))
                .id(id+"-rect")
                .frame(height:CGFloat(buttonHei))
            Text(text)
                .font(.system(size: CGFloat(buttonHei*textSize), weight: .medium, design: .rounded))
                .animation(nil)
                .foregroundColor(.white)
                .colorMultiply(textColor)
                .animation(.easeInOut(duration:competitiveTime))
                .id(id+"-text")
        }
    }
}

struct bottomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
            .animation(.easeInOut(duration: 0.07))
    }
}

struct konamiLog: ViewModifier {
    let tfengine:TFEngine
    let daBtn: TFEngine.daBtn
    public func body(content: Content) -> some View {
        content.simultaneousGesture(
            TapGesture()
                .onEnded({
                    tfengine.logButtonKonami(button: daBtn)
                })
        )
    }
}

struct TopButtonsRow: View {
    let textInpHei=49.0
    let midSpace=10.0
    let buttonRadius=0.4
    let textField=0.65
    let textFontSize=0.5
    let textInset=0.07
    
    var tfengine: TFEngine
    var allButtonsDisableSwitch: Bool
    var buttonsDisabled: Bool
    var expr: String
    var answerShowOpacity: Double
    var storedExpr: String?
    var oprButtonActive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    tfengine.reset()
                    tfengine.generateHaptic(hap: .medium)
                }, label: {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                            .fill(Color.init(buttonsDisabled ? "ButtonColorInactive" : "ButtonColorActive"))
                            .animation(.easeInOut(duration:competitiveTime))
                            .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                        Text(expr)
                            .animation(nil)
                            .foregroundColor(.white)
                            .colorMultiply(Color.init(buttonsDisabled ? "ButtonInactiveTextColor" : "TextColor"))
                            .animation(.easeInOut(duration:competitiveTime))
                            .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                            .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                            .padding(.bottom,2)
                            .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), alignment: .leading)
                        Text(tfengine.answerShow.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"))
                            .opacity(answerShowOpacity)
                            .animation(.easeInOut(duration: 0.3))
                            .foregroundColor(Color.init("TextColor"))
                            .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                            .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                            .padding(.bottom,2)
                            .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height:CGFloat(textInpHei), alignment: .leading)
                    }
                }).buttonStyle(bottomButtonStyle())
                .disabled(expr=="" && storedExpr == nil || allButtonsDisableSwitch)
                Spacer()
                Button(action: {
                    tfengine.doStore()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                            .fill(Color.init(buttonsDisabled || storedExpr == nil && !oprButtonActive ? "ButtonColorInactive" : "ButtonColorActive"))
                            .animation(.easeIn(duration: competitiveTime))
                            .frame(width: CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                        if (tfengine.storedExpr != nil) {
                            Text(storedExpr!) // important: This should and can only hold 2 decimal points
                                .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                                .frame(height: CGFloat(textInpHei), alignment: .center)
                                .animation(nil)
                                .foregroundColor(.white)
                                .colorMultiply(Color.init(buttonsDisabled ? "ButtonInactiveTextColor" : "TextColor"))
                        } else {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.system(size: CGFloat(textFontSize*textInpHei)))
                                .foregroundColor(.white)
                                .colorMultiply(Color.init(!buttonsDisabled && tfengine.oprButtonActive ? "TextColor" : "ButtonInactiveTextColor"))
                                .animation(.easeIn(duration: competitiveTime))
                        }
                    }
                })
                .id("StoreButton")
                .buttonStyle(bottomButtonStyle())
                .disabled(tfengine.storedExpr == nil && !tfengine.oprButtonActive || allButtonsDisableSwitch)
            }
        }.frame(height: CGFloat(textInpHei))
    }
}

struct bottomButtons: View {
    let textInpHei=49.0
    let midSpace=10.0
    let buttonRadius=0.4
    let textField=0.65
    let textFontSize=0.5
    let textInset=0.07
    
    @ObservedObject var tfengine:TFEngine
    var buttonsDisabled: Bool
    
    var body: some View {
        VStack {
            let allButtonsDisableSwitch=buttonsDisabled || tfengine.nxtState != .ready
            
            TopButtonsRow(tfengine: tfengine, allButtonsDisableSwitch: allButtonsDisableSwitch, buttonsDisabled: buttonsDisabled, expr: tfengine.expr, answerShowOpacity: tfengine.answerShowOpacity, storedExpr: tfengine.storedExpr, oprButtonActive: tfengine.oprButtonActive)
            let bottomButtonFillColor=Color.init(tfengine.oprButtonActive && !buttonsDisabled ? "ButtonColorActive" : "ButtonColorInactive")
            let bottomButtonTextColor=Color.init(tfengine.oprButtonActive && !buttonsDisabled ? "TextColor" : "ButtonInactiveTextColor")
            HStack(spacing:CGFloat(midSpace)) {
                ForEach((0..<4), id:\.self) { index in
                    Button(action: {
                        tfengine.handleNumberPress(index: index)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(tfengine.cA[index] && !buttonsDisabled ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(tfengine.cA[index] && !buttonsDisabled ? "TextColor" : "ButtonInactiveTextColor"), text: String(tfengine.cs[index].numb), id: "BottomButtonNum"+String(index))
                    }).buttonStyle(bottomButtonStyle())
                    .disabled(!tfengine.cA[index] || allButtonsDisableSwitch)
                    .modifier(konamiLog(tfengine: tfengine,daBtn: TFEngine.daBtn.allCases[4+index]))
                }
            }
            HStack(spacing:CGFloat(midSpace)) {
                Button(action: {
                    tfengine.handleOprPress(Opr: .add)
                }, label: {
                    bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "+", id: "BottomButtonAdd")
                }).buttonStyle(bottomButtonStyle())
                .disabled(!tfengine.oprButtonActive || allButtonsDisableSwitch)
                .modifier(konamiLog(tfengine: tfengine,daBtn: .add))
                Button(action: {
                    tfengine.handleOprPress(Opr: .sub)
                }, label: {
                    bottomButtonView(fillColor: Color.init(buttonsDisabled ? "ButtonColorInactive" : "ButtonColorActive"), textColor: Color.init(buttonsDisabled ? "ButtonInactiveTextColor" : "TextColor"), text: "-", id: "BottomButtonSub")
                }).buttonStyle(bottomButtonStyle())
                .disabled(buttonsDisabled || tfengine.nxtState != .ready)
                .modifier(konamiLog(tfengine: tfengine,daBtn: .sub))
                Button(action: {
                    tfengine.handleOprPress(Opr: .mul)
                }, label: {
                    bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "×", id: "BottomButtonMul")
                }).buttonStyle(bottomButtonStyle())
                .disabled(!tfengine.oprButtonActive || allButtonsDisableSwitch)
                .modifier(konamiLog(tfengine: tfengine,daBtn: .mul))
                Button(action: {
                    tfengine.handleOprPress(Opr: .div)
                }, label: {
                    bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "÷", id: "BottomButtonDiv")
                }).buttonStyle(bottomButtonStyle())
                .disabled(!tfengine.oprButtonActive || allButtonsDisableSwitch)
                .modifier(konamiLog(tfengine: tfengine,daBtn: .div))
            }
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
        bottomButtons(tfengine: TFEngine(isPreview: true), buttonsDisabled: false)
            .preferredColorScheme(.light)
    }
}
