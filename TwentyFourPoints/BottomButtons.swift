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

struct contrastBottomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? 0.1 : 0) //0.05
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
    var tfengine: TFEngine
    var storeActionEnabled: Bool
    var storeIconColorEnabled: Bool
    var storeTextColorEnabled: Bool
    var storeRectColorEnabled: Bool
    var expr: String
    
    var resetActionEnabled: Bool
    var answerText: String
    var resetColorEnabled: Bool
    var answerShowOpacity: Double
    var storedExpr: String?
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                        .fill(Color.init(resetColorEnabled ? "ButtonColorActive" : "ButtonColorInactive"))
                        .animation(.easeInOut(duration:competitiveTime))
                        .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                    Text(expr)
                        .animation(nil)
                        .foregroundColor(.white)
                        .colorMultiply(Color.init(resetColorEnabled ? "TextColor" : "ButtonInactiveTextColor"))
                        .animation(.easeInOut(duration:competitiveTime))
                        .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                        .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                        .padding(.bottom,2)
                        .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), alignment: .leading)
                    Text(answerText)
                        .opacity(answerShowOpacity)
                        .animation(.easeInOut(duration: 0.3))
                        .foregroundColor(Color.init("TextColor"))
                        .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                        .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                        .padding(.bottom,2)
                        .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height:CGFloat(textInpHei), alignment: .leading)
                    HStack {
                        Spacer()
                        Button(action: {
                            tfengine.reset()
                            tfengine.generateHaptic(hap: .medium)
                        }, label: {
                            VStack {
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.init("ResetButtonColor"))
                                    .font(.system(size: CGFloat(textFontSize*textInpHei*0.9)))
                                    .padding(.trailing,13)
                                    .opacity(resetActionEnabled ? 1.0 : 0)
                                    .animation(.easeInOut(duration: competitiveTime))
                                Spacer()
                            }.background(Color.white.opacity(0.001))
                        }).buttonStyle(contrastBottomButtonStyle())
                    }
                }
                Spacer()
                Button(action: {
                    tfengine.doStore()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                            .fill(Color.init(storeRectColorEnabled ? "ButtonColorActive" : "ButtonColorInactive"))
                            .animation(.easeIn(duration: competitiveTime))
                            .frame(width: CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                        if (storedExpr != nil) {
                            Text(storedExpr!) // important: This should and can only hold 2 decimal points
                                .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                                .frame(height: CGFloat(textInpHei), alignment: .center)
                                .animation(nil)
                                .foregroundColor(.white)
                                .colorMultiply(Color.init(storeTextColorEnabled ? "TextColor" : "ButtonInactiveTextColor"))
                        } else {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.system(size: CGFloat(textFontSize*textInpHei*0.9)))
                                .foregroundColor(.white)
                                .colorMultiply(Color.init(storeIconColorEnabled ? "TextColor" : "ButtonInactiveTextColor"))
                                .animation(.easeIn(duration: competitiveTime))
                        }
                    }
                })
                .id("StoreButton")
                .buttonStyle(bottomButtonStyle())
                .disabled(!storeActionEnabled)
            }
        }.frame(height: CGFloat(textInpHei))
    }
}

struct MiddleButtonRow: View {
    var colorActive: [Bool]
    var actionActive: [Bool]
    var cards: [card]
    var tfengine: TFEngine
    
    var body: some View {
        HStack(spacing:CGFloat(midSpace)) {
            ForEach((0..<4), id:\.self) { index in
                Button(action: {
                    tfengine.handleNumberPress(index: index)
                }, label: {
                    bottomButtonView(fillColor: Color.init(colorActive[index] ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(colorActive[index] ? "TextColor" : "ButtonInactiveTextColor"), text: String(cards[index].numb), id: "BottomButtonNum"+String(index))
                }).buttonStyle(bottomButtonStyle())
                .disabled(!actionActive[index])
                .modifier(konamiLog(tfengine: tfengine,daBtn: TFEngine.daBtn.allCases[4+index]))
            }
        }
    }
}

struct BottomButtonRow: View {
    var tfengine: TFEngine
    var generalOprActionActive: Bool
    var generalOprColorActive: Bool
    var subOprActionActive: Bool
    var subOprColorActive: Bool
    
    var body: some View {
        let bottomButtonFillColor=Color.init(generalOprColorActive ? "ButtonColorActive" : "ButtonColorInactive")
        let bottomButtonTextColor=Color.init(generalOprColorActive ? "TextColor" : "ButtonInactiveTextColor")
        HStack(spacing:CGFloat(midSpace)) {
            Button(action: {
                tfengine.handleOprPress(Opr: .add)
            }, label: {
                bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "+", id: "BottomButtonAdd")
            }).buttonStyle(bottomButtonStyle())
            .disabled(!generalOprActionActive)
            .modifier(konamiLog(tfengine: tfengine,daBtn: .add))
            Button(action: {
                tfengine.handleOprPress(Opr: .sub)
            }, label: {
                bottomButtonView(fillColor: Color.init(subOprColorActive ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(subOprColorActive ? "TextColor" : "ButtonInactiveTextColor"), text: "-", id: "BottomButtonSub")
            }).buttonStyle(bottomButtonStyle())
            .disabled(!subOprActionActive)
            .modifier(konamiLog(tfengine: tfengine,daBtn: .sub))
            Button(action: {
                tfengine.handleOprPress(Opr: .mul)
            }, label: {
                bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "×", id: "BottomButtonMul")
            }).buttonStyle(bottomButtonStyle())
            .disabled(!generalOprActionActive)
            .modifier(konamiLog(tfengine: tfengine,daBtn: .mul))
            Button(action: {
                tfengine.handleOprPress(Opr: .div)
            }, label: {
                bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "÷", id: "BottomButtonDiv")
            }).buttonStyle(bottomButtonStyle())
            .disabled(!generalOprActionActive)
            .modifier(konamiLog(tfengine: tfengine,daBtn: .div))
        }
    }
}

struct bottomButtons: View {
    
    @ObservedObject var tfengine:TFEngine
    var buttonsDisabled: Bool
    
    var body: some View {
        VStack {
            let allButtonsDisableSwitch=buttonsDisabled || tfengine.nxtState != .ready
            
            TopButtonsRow(tfengine: tfengine,
                          storeActionEnabled: !(tfengine.storedExpr == nil && !tfengine.oprButtonActive || allButtonsDisableSwitch),
                          storeIconColorEnabled: !buttonsDisabled && tfengine.oprButtonActive,
                          storeTextColorEnabled: !buttonsDisabled,
                          storeRectColorEnabled: !buttonsDisabled && !(tfengine.storedExpr == nil && !tfengine.oprButtonActive),
                          expr: tfengine.expr,
                          resetActionEnabled: !(tfengine.expr=="" && tfengine.storedExpr == nil || allButtonsDisableSwitch),
                          answerText: tfengine.answerShow.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"),
                          resetColorEnabled: !buttonsDisabled,
                          answerShowOpacity: tfengine.answerShowOpacity,
                          storedExpr: tfengine.storedExpr
            )
            
            MiddleButtonRow(colorActive: buttonsDisabled ? Array(repeating: false,count: 4) : tfengine.cA,
                            actionActive: allButtonsDisableSwitch ? Array(repeating: false,count:4) : tfengine.cA,
                            cards: tfengine.cs,
                            tfengine: tfengine
            )
            
            BottomButtonRow(tfengine: tfengine, generalOprActionActive: tfengine.oprButtonActive && !allButtonsDisableSwitch, generalOprColorActive: tfengine.oprButtonActive && !buttonsDisabled, subOprActionActive: !allButtonsDisableSwitch, subOprColorActive: !buttonsDisabled)
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
        bottomButtons(tfengine: TFEngine(isPreview: true), buttonsDisabled: false)
            .preferredColorScheme(.light)
    }
}
