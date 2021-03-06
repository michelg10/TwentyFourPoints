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
    var ultraCompetitive: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(buttonHei/2.0*buttonRadius),style: .continuous)
                .fill(fillColor)
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                .id(id+"-rect")
                .frame(height:CGFloat(buttonHei))
            Text(text)
                .font(.system(size: CGFloat(buttonHei*textSize), weight: .medium, design: .rounded))
                .animation(nil)
                .foregroundColor(.white)
                .colorMultiply(textColor)
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                .id(id+"-text")
        }
    }
}

struct bottomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
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
    let tfengine:tfCallable
    let daBtn: daBtn
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
    var tfengine: tfCallable
    var storeActionEnabled: Bool
    var storeIconColorEnabled: Bool
    var storeTextColorEnabled: Bool
    var storeRectColorEnabled: Bool
    var expr: String
    
    var answerShowOpacity: Double
    var answerText: String
    
    var incorShowOpacity: Double
    var incorText: String
    
    var resetActionEnabled: Bool
    var resetColorEnabled: Bool
    var storedExpr: String?
    
    var ultraCompetitive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                        .fill(Color.init(resetColorEnabled ? "ButtonColorActive" : "ButtonColorInactive"))
                        .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                        .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                    Text(expr)
                        .animation(nil)
                        .foregroundColor(.white)
                        .colorMultiply(Color.init(resetColorEnabled ? "TextColor" : "ButtonInactiveTextColor"))
                        .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
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
                    Text(incorText)
                        .animation(nil)
                        .opacity(incorShowOpacity)
                        .animation(.easeInOut(duration: 0.2))
                        .foregroundColor(Color.init("WrongNumber"))
                        .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                        .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                        .padding(.bottom,2)
                        .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height:CGFloat(textInpHei), alignment: .leading)
                    HStack {
                        Spacer()
                        Button(action: {
                            tfengine.reset()
                            tfengine.hapticGate(hap: .medium)
                        }, label: {
                            VStack {
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.init("ResetButtonColor"))
                                    .font(.system(size: CGFloat(textFontSize*textInpHei*0.9)))
                                    .padding(.trailing,13)
                                    .opacity(resetActionEnabled ? 1.0 : 0)
                                    .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                                Spacer()
                            }.background(Color.white.opacity(0.001))
                        }).buttonStyle(contrastBottomButtonStyle())
                        .disabled(!resetActionEnabled)
                    }
                }
                Spacer()
                Button(action: {
                    tfengine.doStore()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                            .fill(Color.init(storeRectColorEnabled ? "ButtonColorActive" : "ButtonColorInactive"))
                            .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
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
                                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                        }
                    }
                })
                .id("StoreButton")
                .buttonStyle(bottomButtonStyle())
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                .disabled(!storeActionEnabled)
            }
        }.frame(height: CGFloat(textInpHei))
    }
}

struct MiddleButtonRow: View {
    var colorActive: [Bool]
    var actionActive: [Bool]
    var cards: [card]
    var tfengine: tfCallable
    var ultraCompetitive: Bool
    
    var body: some View {
        HStack(spacing:CGFloat(midSpace)) {
            ForEach((0..<4), id:\.self) { index in
                Button(action: {
                    tfengine.handleNumberPress(index: index)
                }, label: {
                    bottomButtonView(fillColor: Color.init(colorActive[index] ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(colorActive[index] ? "TextColor" : "ButtonInactiveTextColor"), text: (cards[index].numb == -1 ? "" : String(cards[index].numb)), id: "BottomButtonNum"+String(index), ultraCompetitive: tfengine.getUltraCompetitive())
                }).buttonStyle(bottomButtonStyle())
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                .disabled(!actionActive[index])
                .modifier(konamiLog(tfengine: tfengine,daBtn: daBtn.allCases[4+index]))
            }
        }
    }
}

func getButtonColor(active: Bool) -> Color {
    return Color.init(active ? "ButtonColorActive" : "ButtonColorInactive")
}

func getButtonTextColor(active: Bool) -> Color {
    return Color.init(active ? "TextColor" : "ButtonInactiveTextColor")
}

struct BottomButtonRow: View {
    var tfengine: tfCallable
    var oprActionActive: [Bool]
    var oprColorActive: [Bool]
    var ultraCompetitive: Bool
    
    var body: some View {
        HStack(spacing:CGFloat(midSpace)) {
            Button(action: {
                tfengine.handleOprPress(Opr: .add)
            }, label: {
                bottomButtonView(fillColor: getButtonColor(active: oprColorActive[0]), textColor: getButtonTextColor(active: oprColorActive[0]), text: "+", id: "BottomButtonAdd", ultraCompetitive: tfengine.getUltraCompetitive())
            }).buttonStyle(bottomButtonStyle())
            .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
            .disabled(!oprActionActive[0])
            .modifier(konamiLog(tfengine: tfengine,daBtn: .add))
            Button(action: {
                tfengine.handleOprPress(Opr: .sub)
            }, label: {
                bottomButtonView(fillColor: getButtonColor(active: oprColorActive[1]), textColor: getButtonTextColor(active: oprColorActive[1]), text: "-", id: "BottomButtonSub", ultraCompetitive: tfengine.getUltraCompetitive())
            }).buttonStyle(bottomButtonStyle())
            .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
            .disabled(!oprActionActive[1])
            .modifier(konamiLog(tfengine: tfengine,daBtn: .sub))
            Button(action: {
                tfengine.handleOprPress(Opr: .mul)
            }, label: {
                bottomButtonView(fillColor: getButtonColor(active: oprColorActive[2]), textColor: getButtonTextColor(active: oprColorActive[2]), text: "×", id: "BottomButtonMul", ultraCompetitive: tfengine.getUltraCompetitive())
            }).buttonStyle(bottomButtonStyle())
            .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
            .disabled(!oprActionActive[2])
            .modifier(konamiLog(tfengine: tfengine,daBtn: .mul))
            Button(action: {
                tfengine.handleOprPress(Opr: .div)
            }, label: {
                bottomButtonView(fillColor: getButtonColor(active: oprColorActive[3]), textColor: getButtonTextColor(active: oprColorActive[3]), text: "÷", id: "BottomButtonDiv", ultraCompetitive: tfengine.getUltraCompetitive())
            }).buttonStyle(bottomButtonStyle())
            .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
            .disabled(!oprActionActive[3])
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
                          answerShowOpacity: tfengine.answerShowOpacity,
                          answerText: tfengine.answerShow.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"),
                          incorShowOpacity: tfengine.incorShowOpacity,
                          incorText: tfengine.incorText,
                          resetActionEnabled: !(tfengine.expr=="" && tfengine.storedExpr == nil && tfengine.incorText == "" || allButtonsDisableSwitch),
                          resetColorEnabled: !buttonsDisabled,
                          storedExpr: tfengine.storedExpr,
                          ultraCompetitive: tfengine.getUltraCompetitive()
            )
            
            MiddleButtonRow(colorActive: buttonsDisabled ? Array(repeating: false,count: 4) : tfengine.cA,
                            actionActive: allButtonsDisableSwitch ? Array(repeating: false,count:4) : tfengine.cA,
                            cards: tfengine.cs,
                            tfengine: tfengine,
                            ultraCompetitive: tfengine.getUltraCompetitive()
            )
            let otherOprActionActive = tfengine.oprButtonActive && !allButtonsDisableSwitch
            let oprActionActive = [otherOprActionActive, !allButtonsDisableSwitch, otherOprActionActive, otherOprActionActive]
            let otherOprColorActive=tfengine.oprButtonActive && !buttonsDisabled
            let oprColorActive = [otherOprColorActive, !buttonsDisabled, otherOprColorActive, otherOprColorActive]
            
            BottomButtonRow(tfengine: tfengine,
                            oprActionActive: oprActionActive,
                            oprColorActive: oprColorActive,
                            ultraCompetitive: tfengine.getUltraCompetitive()
            )
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
        bottomButtons(tfengine: TFEngine(isPreview: true), buttonsDisabled: false)
            .preferredColorScheme(.light)
    }
}
