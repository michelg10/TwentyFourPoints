//
//  BottomButtons.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI
import GameController

struct bottomButtonView: View {
    let buttonHei=49.0
    let buttonRadius=0.4
    let textSize=0.5
    
    var fillColor:Color
    var textColor:Color
    var text:String
    var id:String
    var ultraCompetitive: Bool
    var doSplit:Bool
        
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
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
        }.frame(maxWidth: doSplit ? CGFloat(maxButtonSize) : nil)
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

let textInpHei=49.0
let midSpace=10.0
let buttonRadius=0.4
let textField=0.65
let textFontSize=0.5
let maxButtonSize: Double=160
let buttonTooltipSize: Double=51

struct imageTooltip: View {
    var isOptional: Bool
    var name: String
    var body: some View {
        if name.count == 1 {
            if name == " " {
                Text("space")
                    .foregroundColor(isOptional ? .secondary : .secondary)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
            } else {
                Text(name.capitalized)
                    .foregroundColor(isOptional ? .secondary : .secondary)
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
            }
        } else {
            Image(systemName: name)
                .foregroundColor(isOptional ? .secondary : .secondary)
                .font(.system(size: 15, weight: .regular, design: .rounded))
        }
    }
}

let tooltipDistance=10.0 //how far it is from the button
let tooltipSpacing=3.0 //spacing between tooltips

struct TopButtonsRow: View {
    let textInset=0.65
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
    
    var doSplit: Bool
    var showTooltip: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing:0) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                        .fill(Color.init(resetColorEnabled ? "ButtonColorActive" : "ButtonColorInactive"))
                        .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                    Text(expr)
                        .animation(nil)
                        .foregroundColor(.white)
                        .colorMultiply(Color.init(resetColorEnabled ? "TextColor" : "ButtonInactiveTextColor"))
                        .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                        .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                        .padding(.leading, CGFloat(textInset*textField*(textInpHei-midSpace)))
                        .padding(.bottom,2)
                    Text(answerText)
                        .opacity(answerShowOpacity)
                        .animation(.easeInOut(duration: 0.3))
                        .foregroundColor(Color.init("TextColor"))
                        .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                        .padding(.leading, CGFloat(textInset*textField*(textInpHei-midSpace)))
                        .padding(.bottom,2)
                    Text(incorText)
                        .animation(nil)
                        .opacity(incorShowOpacity)
                        .animation(.easeInOut(duration: 0.2))
                        .foregroundColor(Color.init("WrongNumber"))
                        .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                        .padding(.leading, CGFloat(textInset*textField*(textInpHei-midSpace)))
                        .padding(.bottom,2)
                    HStack {
                        Spacer()
                        Button(action: {
                            tfengine.reset()
                            tfengine.hapticGate(hap: .medium)
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.init("ResetButtonColor"))
                                .font(.system(size: CGFloat(textFontSize*textInpHei*0.9)))
                                .opacity(resetActionEnabled ? 1.0 : 0)
                                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
                        }).buttonStyle(contrastBottomButtonStyle())
                        .padding(.trailing,13)
                        .disabled(!resetActionEnabled)
                        .keyboardShortcut(tfengine.getKeyboardSettings().resetButton, modifiers: .init([]))
                    }
                }.frame(width: doSplit ? CGFloat(2*maxButtonSize+midSpace) : CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .leading)
                if doSplit && showTooltip {
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().resetButton.character))
                        .padding(.leading,10)
                }
                Spacer()
                if doSplit && showTooltip {
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().storeButton.character))
                        .padding(.trailing,10)
                }
                Button(action: {
                    tfengine.doStore()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                            .fill(Color.init(storeRectColorEnabled ? "ButtonColorActive" : "ButtonColorInactive"))
                            .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveTime))
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
                    }.frame(width: doSplit ? CGFloat(2*maxButtonSize+midSpace) : CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                }).keyboardShortcut(tfengine.getKeyboardSettings().storeButton, modifiers: .init([]))
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
    var doSplit: Bool
    var showTooltip: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        HStack(spacing: doSplit ? 0 : CGFloat(midSpace)) {
            HStack(spacing:CGFloat(midSpace)) {
                ForEach((0..<2), id:\.self) { index in
                    Button(action: {
                        tfengine.handleNumberPress(index: index)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(colorActive[index] ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(colorActive[index] ? "TextColor" : "ButtonInactiveTextColor"), text: (cards[index].numb == -1 ? "" : String(cards[index].numb)), id: "BottomButtonNum"+String(index), ultraCompetitive: tfengine.getUltraCompetitive(), doSplit: doSplit)
                    }).buttonStyle(bottomButtonStyle())
                    .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                    .disabled(!actionActive[index])
                    .modifier(konamiLog(tfengine: tfengine,daBtn: daBtn.allCases[4+index]))
                    .keyboardShortcut(tfengine.getKeyboardSettings().numsButton[index], modifiers: .init([]))
                }
            }
            if doSplit {
                if showTooltip {
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().numsButton[0].character))
                        .padding(.leading,CGFloat(tooltipDistance))
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().numsButton[1].character))
                        .padding(.leading,CGFloat(tooltipSpacing))
                }
                Spacer()
                if showTooltip {
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().numsButton[2].character))
                        .padding(.trailing,CGFloat(tooltipSpacing))
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().numsButton[3].character))
                        .padding(.trailing,CGFloat(tooltipDistance))
                }
            }
            HStack(spacing:CGFloat(midSpace)) {
                ForEach((2..<4), id:\.self) { index in
                    Button(action: {
                        tfengine.handleNumberPress(index: index)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(colorActive[index] ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(colorActive[index] ? "TextColor" : "ButtonInactiveTextColor"), text: (cards[index].numb == -1 ? "" : String(cards[index].numb)), id: "BottomButtonNum"+String(index), ultraCompetitive: tfengine.getUltraCompetitive(), doSplit: doSplit)
                    }).buttonStyle(bottomButtonStyle())
                    .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                    .disabled(!actionActive[index])
                    .modifier(konamiLog(tfengine: tfengine,daBtn: daBtn.allCases[4+index]))
                    .keyboardShortcut(tfengine.getKeyboardSettings().numsButton[index], modifiers: .init([]))
                }
            }
        }.frame(maxWidth: .infinity)
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
    var doSplit: Bool
    var showTooltip: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        HStack(spacing: doSplit ? 0 : CGFloat(midSpace)) {
            HStack(spacing:CGFloat(midSpace)) {
                Button(action: {
                    tfengine.handleOprPress(Opr: .add)
                }, label: {
                    bottomButtonView(fillColor: getButtonColor(active: oprColorActive[0]), textColor: getButtonTextColor(active: oprColorActive[0]), text: "+", id: "BottomButtonAdd", ultraCompetitive: tfengine.getUltraCompetitive(), doSplit: doSplit)
                }).buttonStyle(bottomButtonStyle())
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                .disabled(!oprActionActive[0])
                .modifier(konamiLog(tfengine: tfengine,daBtn: .add))
                .keyboardShortcut(tfengine.getKeyboardSettings().oprsButton[0], modifiers: .init([]))
                Button(action: {
                    tfengine.handleOprPress(Opr: .sub)
                }, label: {
                    bottomButtonView(fillColor: getButtonColor(active: oprColorActive[1]), textColor: getButtonTextColor(active: oprColorActive[1]), text: "-", id: "BottomButtonSub", ultraCompetitive: tfengine.getUltraCompetitive(), doSplit: doSplit)
                }).buttonStyle(bottomButtonStyle())
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                .disabled(!oprActionActive[1])
                .modifier(konamiLog(tfengine: tfengine,daBtn: .sub))
                .keyboardShortcut(tfengine.getKeyboardSettings().oprsButton[1], modifiers: .init([]))
            }
            if doSplit {
                if showTooltip {
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().oprsButton[0].character))
                        .padding(.leading,CGFloat(tooltipDistance))
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().oprsButton[1].character))
                        .padding(.leading,CGFloat(tooltipSpacing))
                }
                Spacer()
                if showTooltip {
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().oprsButton[2].character))
                        .padding(.trailing,CGFloat(tooltipSpacing))
                    imageTooltip(isOptional: false, name: String(tfengine.getKeyboardSettings().oprsButton[3].character))
                        .padding(.trailing,CGFloat(tooltipDistance))
                }
            }
            HStack(spacing:CGFloat(midSpace)) {
                Button(action: {
                    tfengine.handleOprPress(Opr: .mul)
                }, label: {
                    bottomButtonView(fillColor: getButtonColor(active: oprColorActive[2]), textColor: getButtonTextColor(active: oprColorActive[2]), text: "×", id: "BottomButtonMul", ultraCompetitive: tfengine.getUltraCompetitive(), doSplit: doSplit)
                }).buttonStyle(bottomButtonStyle())
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                .disabled(!oprActionActive[2])
                .modifier(konamiLog(tfengine: tfengine,daBtn: .mul))
                .keyboardShortcut(tfengine.getKeyboardSettings().oprsButton[2], modifiers: .init([]))
                Button(action: {
                    tfengine.handleOprPress(Opr: .div)
                }, label: {
                    bottomButtonView(fillColor: getButtonColor(active: oprColorActive[3]), textColor: getButtonTextColor(active: oprColorActive[3]), text: "÷", id: "BottomButtonDiv", ultraCompetitive: tfengine.getUltraCompetitive(), doSplit: doSplit)
                }).buttonStyle(bottomButtonStyle())
                .animation(ultraCompetitive ? nil : .easeInOut(duration:competitiveButtonAnimationTime))
                .disabled(!oprActionActive[3])
                .modifier(konamiLog(tfengine: tfengine,daBtn: .div))
                .keyboardShortcut(tfengine.getKeyboardSettings().oprsButton[3], modifiers: .init([]))
            }
        }
    }
}

struct bottomButtons: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @ObservedObject var rotationObserver : UIRotationObserver
    @ObservedObject var tfengine:TFEngine
    var buttonsDisabled: Bool
    var buttonsPadding: Double
    
    var body: some View {
        let showTooltip=GCKeyboard.coalesced != nil
        let doSplit: Bool=CGFloat(2*buttonsPadding+4*maxButtonSize+3*midSpace+(showTooltip ? 2*buttonTooltipSize : 0))<UIApplication.shared.windows.first!.frame.width && horizontalSizeClass == .regular
//        let doSplit=false
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
                          ultraCompetitive: tfengine.getUltraCompetitive(),
                          doSplit: doSplit,
                          showTooltip: showTooltip
            )
            
            MiddleButtonRow(colorActive: buttonsDisabled ? Array(repeating: false,count: 4) : tfengine.cA,
                            actionActive: allButtonsDisableSwitch ? Array(repeating: false,count:4) : tfengine.cA,
                            cards: tfengine.cs,
                            tfengine: tfengine,
                            ultraCompetitive: tfengine.getUltraCompetitive(),
                            doSplit: doSplit,
                            showTooltip: showTooltip
            )
            let otherOprActionActive = tfengine.oprButtonActive && !allButtonsDisableSwitch
            let oprActionActive = [otherOprActionActive, !allButtonsDisableSwitch, otherOprActionActive, otherOprActionActive]
            let otherOprColorActive=tfengine.oprButtonActive && !buttonsDisabled
            let oprColorActive = [otherOprColorActive, !buttonsDisabled, otherOprColorActive, otherOprColorActive]
            
            BottomButtonRow(tfengine: tfengine,
                            oprActionActive: oprActionActive,
                            oprColorActive: oprColorActive,
                            ultraCompetitive: tfengine.getUltraCompetitive(),
                            doSplit: doSplit,
                            showTooltip: showTooltip
            )
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
//        TopButtonsRow(tfengine: TFEngine(isPreview: true), storeActionEnabled: true, storeIconColorEnabled: true, storeTextColorEnabled: true, storeRectColorEnabled: true, expr: "Expression", answerShowOpacity: 1, answerText: "", incorShowOpacity: 0, incorText: "", resetActionEnabled: true, resetColorEnabled: true, storedExpr: nil, ultraCompetitive: false, doSplit: true)
        bottomButtons(rotationObserver: UIRotationObserver(), tfengine: TFEngine(isPreview: true), buttonsDisabled: false, buttonsPadding: 30.0)
            .preferredColorScheme(.light)
    }
}
