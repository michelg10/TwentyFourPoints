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
    var doSplit:Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
//        print("Render view \(text)")
        return ZStack {
            RoundedRectangle(cornerRadius: CGFloat(buttonHei/2.0*buttonRadius),style: .continuous)
                .fill(fillColor)
                .animation(nil)
                .frame(height:CGFloat(buttonHei))
            Text(text)
                .font(.system(size: CGFloat(buttonHei*textSize), weight: .medium, design: .rounded))
                .foregroundColor(textColor)
                .animation(nil)
        }.frame(maxWidth: doSplit ? CGFloat(maxButtonSize) : nil)
    }
}

struct bottomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
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
let maxButtonSize: Double=140
let buttonTooltipSize: Double=51

struct imageTooltip: View {
    var name: String
    var body: some View {
        let actualDisplay=(name == " " ? "space" : (name == "." ? "dot" : name))
        
        Text(actualDisplay)
            .foregroundColor(.secondary)
            .font(.system(size: 15, weight: .regular, design: .monospaced))
    }
}

let tooltipDistance=10.0 //how far it is from the button
let tooltipSpacing=3.0 //spacing between tooltips
let tooltipOpacity=0.5

let autocompleteTextColor=Color.init("AutocompleteText")
let wrongNumberColor=Color.init("WrongNumber")
let resetButtonColor=Color.init("ResetButtonColor")
struct TopButtonsRow: View {
    let textInset=0.65
    var tfengine: tfCallable
    var storeActionEnabled: Bool
    var storeIconColorEnabled: Bool
    var storeTextColorEnabled: Bool
    var storeRectColorEnabled: Bool
    var expr: String
    var autocompleteHintExpression: String?
    
    var answerShowOpacity: Double
    var answerText: String
    
    var incorShowOpacity: Double
    var incorText: String
    
    var resetActionEnabled: Bool
    var resetColorEnabled: Bool
    var storedExpr: String?
        
    var doSplit: Bool
    var showTooltip: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing:0) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                        .fill(getButtonColor(active: resetColorEnabled))
                        .animation(nil)
                    ZStack(alignment: .leading) {
                        Text(resetColorEnabled ? (autocompleteHintExpression ?? " ") : " ")
                            .foregroundColor(autocompleteTextColor)
                            .animation(nil)
                        Text(expr)
                            .animation(nil)
                            .foregroundColor(getButtonTextColor(active: resetColorEnabled))
                        Text(answerText == "" ? " " : answerText)
                            .opacity(answerShowOpacity)
                            .animation(.easeInOut(duration: 0.3))
                            .foregroundColor(Color.primary)
                        Text(incorText == "" ? " " : incorText)
                            .animation(nil)
                            .opacity(incorShowOpacity)
                            .animation(.easeInOut(duration: 0.2))
                            .foregroundColor(wrongNumberColor)
                    }.font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                    .padding(.leading, CGFloat(textInset*textField*(textInpHei-midSpace)))
                    .padding(.bottom,2)
                    HStack(spacing:0) {
                        Spacer()
                        Button(action: {
                            tfengine.reset()
                            tfengine.hapticGate(hap: .medium)
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(resetButtonColor)
                                .font(.system(size: CGFloat(textFontSize*textInpHei*0.9)))
                                .opacity(resetActionEnabled ? 1.0 : 0)
                                .animation(nil)
                        }).buttonStyle(contrastBottomButtonStyle())
                            .padding(.trailing,13)
                            .disabled(!resetActionEnabled)
                            .keyboardShortcut(KeyEquivalent.delete, modifiers: .init([]))
                        Button(action: {tfengine.reset(); tfengine.hapticGate(hap: .medium)}, label: {EmptyView()}).disabled(!resetActionEnabled).keyboardShortcut(KeyEquivalent.space, modifiers: .init([]))
                    }
                }.frame(width: doSplit ? CGFloat(2*maxButtonSize+midSpace) : CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .leading)
                if doSplit && showTooltip {
                    imageTooltip(name: "delete")
                        .opacity(resetActionEnabled ? 1 : tooltipOpacity)
                        .animation(nil)
                        .padding(.leading,10)
                }
                Spacer()
                if doSplit && showTooltip {
                    imageTooltip(name: ".")
                        .padding(.trailing,10)
                        .opacity(storeActionEnabled ? 1 : tooltipOpacity)
                        .animation(nil)
                }
                Button(action: {
                    tfengine.doStore()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                            .fill(getButtonColor(active: storeRectColorEnabled))
                            .animation(nil)
                        if (storedExpr != nil) {
                            Text(storedExpr!) // important: This should and can only hold 2 decimal points
                                .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                                .frame(height: CGFloat(textInpHei), alignment: .center)
                                .animation(nil)
                                .foregroundColor(getButtonTextColor(active: storeTextColorEnabled))
                        } else {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.system(size: CGFloat(textFontSize*textInpHei*0.9)))
                                .foregroundColor(getButtonTextColor(active: storeIconColorEnabled))
                        }
                    }.frame(width: doSplit ? CGFloat(2*maxButtonSize+midSpace) : CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                }).keyboardShortcut(".", modifiers: .init([]))
                    .buttonStyle(bottomButtonStyle())
                    .animation(nil)
                    .disabled(!storeActionEnabled)
                Button(action: {tfengine.doStore()}, label: {EmptyView()}).disabled(!storeActionEnabled).keyboardShortcut("v", modifiers: .init([]))
                Button(action: {tfengine.doStore()}, label: {EmptyView()}).disabled(!storeActionEnabled).keyboardShortcut("m", modifiers: .init([]))
            }
        }.frame(height: CGFloat(textInpHei))
    }
}

struct MiddleButtonRow: View {
    var colorActive: [Bool]
    var actionActive: [Bool]
    var cards: [card]
    var tfengine: tfCallable
    var doSplit: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        ZStack {
            HStack(spacing:0) {
                ForEach((0...9), id: \.self) { index in
                    Button(action: {
                        tfengine.handleKeyboardNumberPress(number: index)
                    }, label: {EmptyView()})
                        .keyboardShortcut(.init(.init(String(index))), modifiers: .init([]))
                }
                Button(action: {
                    tfengine.handleKeyboardNumberPress(number: nil)
                }, label: {EmptyView()})
                    .keyboardShortcut(.init(.init("`")), modifiers: .init([]))
            }
            HStack(spacing: doSplit ? 0 : CGFloat(midSpace)) {
                HStack(spacing:CGFloat(midSpace)) {
                    ForEach((0..<2), id:\.self) { index in
                        Button(action: {
                            tfengine.handleNumberPress(index: index)
                        }, label: {
                            bottomButtonView(fillColor: getButtonColor(active: colorActive[index]), textColor: getButtonTextColor(active: colorActive[index]), text: (cards[index].numb == -1 ? "" : String(cards[index].numb)), doSplit: doSplit)
                        }).buttonStyle(bottomButtonStyle())
                            .animation(nil)
                            .disabled(!actionActive[index])
#if KONAMI
                            .modifier(konamiLog(tfengine: tfengine,daBtn: daBtn.allCases[4+index]))
#endif
                    }
                }
                if doSplit {
                    Spacer()
                }
                HStack(spacing:CGFloat(midSpace)) {
                    ForEach((2..<4), id:\.self) { index in
                        Button(action: {
                            tfengine.handleNumberPress(index: index)
                        }, label: {
                            bottomButtonView(fillColor: getButtonColor(active: colorActive[index]), textColor: getButtonTextColor(active: colorActive[index]), text: (cards[index].numb == -1 ? "" : String(cards[index].numb)), doSplit: doSplit)
                        }).buttonStyle(bottomButtonStyle())
                            .animation(nil)
                            .disabled(!actionActive[index])
#if KONAMI
                            .modifier(konamiLog(tfengine: tfengine,daBtn: daBtn.allCases[4+index]))
#endif
                    }
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

let getButtonColorActive=Color.init("ButtonColorActive")
let getButtonColorInactive=Color.init("ButtonColorInactive")
func getButtonColor(active: Bool) -> Color {
    return active ? getButtonColorActive : getButtonColorInactive
}

let getButtonTextColorActive=Color.primary
let getButtonTextColorInactive=Color.init("ButtonInactiveTextColor")
func getButtonTextColor(active: Bool) -> Color {
    return active ? getButtonTextColorActive : getButtonTextColorInactive
}

struct BottomButtonRow: View {
    var tfengine: tfCallable
    var oprActionActive: [Bool]
    var oprColorActive: [Bool]
    var doSplit: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        ZStack {
            HStack(spacing:0) {
                // addition keyboard shortcuts
                Button(action: {tfengine.handleOprPress(Opr: .add)}, label: {EmptyView()}).disabled(!oprActionActive[0]).keyboardShortcut(.init("="), modifiers: .init([.shift]))
                // subtraction keyboard shortcuts
                Button(action: {tfengine.handleOprPress(Opr: .sub)}, label: {EmptyView()}).disabled(!oprActionActive[1]).keyboardShortcut(.init("-"), modifiers: .init([.shift]))
                // multiplication keyboard shortcuts
                Button(action: {tfengine.handleOprPress(Opr: .mul)}, label: {EmptyView()}).disabled(!oprActionActive[2]).keyboardShortcut(.init("x"), modifiers: .init([]))
            }
            HStack(spacing: doSplit ? 0 : CGFloat(midSpace)) {
                HStack(spacing:CGFloat(midSpace)) {
                    Button(action: {
                        tfengine.handleOprPress(Opr: .add)
                    }, label: {
                        bottomButtonView(fillColor: getButtonColor(active: oprColorActive[0]), textColor: getButtonTextColor(active: oprColorActive[0]), text: "+", doSplit: doSplit)
                    }).buttonStyle(bottomButtonStyle())
                        .animation(nil)
                        .disabled(!oprActionActive[0])
#if KONAMI
                        .modifier(konamiLog(tfengine: tfengine,daBtn: .add))
#endif
                        .keyboardShortcut(.init("="), modifiers: .init([]))
                    Button(action: {
                        tfengine.handleOprPress(Opr: .sub)
                    }, label: {
                        bottomButtonView(fillColor: getButtonColor(active: oprColorActive[1]), textColor: getButtonTextColor(active: oprColorActive[1]), text: "-", doSplit: doSplit)
                    }).buttonStyle(bottomButtonStyle())
                        .animation(nil)
                        .disabled(!oprActionActive[1])
#if KONAMI
                        .modifier(konamiLog(tfengine: tfengine,daBtn: .sub))
#endif
                        .keyboardShortcut(.init("-"), modifiers: .init([]))
                }
                if doSplit {
                    Spacer()
                }
                HStack(spacing:CGFloat(midSpace)) {
                    Button(action: {
                        tfengine.handleOprPress(Opr: .mul)
                    }, label: {
                        bottomButtonView(fillColor: getButtonColor(active: oprColorActive[2]), textColor: getButtonTextColor(active: oprColorActive[2]), text: "×", doSplit: doSplit)
                    }).buttonStyle(bottomButtonStyle())
                        .animation(nil)
                        .disabled(!oprActionActive[2])
#if KONAMI
                        .modifier(konamiLog(tfengine: tfengine,daBtn: .mul))
#endif
                        .keyboardShortcut(.init("8"), modifiers: .shift)
                    Button(action: {
                        tfengine.handleOprPress(Opr: .div)
                    }, label: {
                        bottomButtonView(fillColor: getButtonColor(active: oprColorActive[3]), textColor: getButtonTextColor(active: oprColorActive[3]), text: "÷", doSplit: doSplit)
                    }).buttonStyle(bottomButtonStyle())
                        .animation(nil)
                        .disabled(!oprActionActive[3])
#if KONAMI
                        .modifier(konamiLog(tfengine: tfengine,daBtn: .div))
#endif
                        .keyboardShortcut(.init("/"), modifiers: .init([]))
                }
            }
        }
    }
}

struct bottomButtons: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @ObservedObject var rotationObserver : UIRotationObserver
    @ObservedObject var tfengine:TFEngine
    @ObservedObject var tfcalcengine: TFCalcEngine
    var buttonsDisabled: Bool
    var buttonsPadding: Double
    
    var body: some View {
        let showTooltip=GCKeyboard.coalesced != nil && tfengine.showKeyboardTips
        let doSplit: Bool=CGFloat(2*buttonsPadding+4*maxButtonSize+3*midSpace+(showTooltip ? 2*buttonTooltipSize : 0))<UIApplication.shared.windows.first!.frame.width && horizontalSizeClass == .regular && tfengine.getDoSplit()
        VStack {
            let allButtonsDisableSwitch=buttonsDisabled || tfengine.nxtState != .ready
            TopButtonsRow(tfengine: tfengine,
                          storeActionEnabled: !(tfcalcengine.storedExpression == nil && !tfcalcengine.oprButtonActive || allButtonsDisableSwitch),
                          storeIconColorEnabled: !allButtonsDisableSwitch && tfcalcengine.oprButtonActive,
                          storeTextColorEnabled: !allButtonsDisableSwitch,
                          storeRectColorEnabled: !allButtonsDisableSwitch && !(tfcalcengine.storedExpression == nil && !tfcalcengine.oprButtonActive),
                          expr: tfcalcengine.expression,
                          autocompleteHintExpression: tfcalcengine.autocompleteHintExpression,
                          answerShowOpacity: tfengine.answerShowOpacity,
                          answerText: tfengine.answerShow.replacingOccurrences(of: "/", with: "÷").replacingOccurrences(of: "*", with: "×"),
                          incorShowOpacity: tfcalcengine.incorShowOpacity,
                          incorText: tfcalcengine.incorText,
                          resetActionEnabled: !(tfcalcengine.expression=="" && tfcalcengine.storedExpression == nil && tfcalcengine.incorText == "" || allButtonsDisableSwitch),
                          resetColorEnabled: !buttonsDisabled,
                          storedExpr: tfcalcengine.storedExpression,
                          doSplit: doSplit,
                          showTooltip: showTooltip
            )
            
            MiddleButtonRow(colorActive: allButtonsDisableSwitch ? Array(repeating: false,count: 4) : tfcalcengine.cardActive,
                            actionActive: allButtonsDisableSwitch ? Array(repeating: false,count:4) : tfcalcengine.cardActive,
                            cards: tfengine.curQ.cs,
                            tfengine: tfengine,
                            doSplit: doSplit
            )
            let otherOprActionActive = tfcalcengine.oprButtonActive && !allButtonsDisableSwitch
            let oprActionActive = [otherOprActionActive, !allButtonsDisableSwitch, otherOprActionActive, otherOprActionActive]
            let otherOprColorActive=tfcalcengine.oprButtonActive && !allButtonsDisableSwitch
            let oprColorActive = [otherOprColorActive, !allButtonsDisableSwitch, otherOprColorActive, otherOprColorActive]
            
            BottomButtonRow(tfengine: tfengine,
                            oprActionActive: oprActionActive,
                            oprColorActive: oprColorActive,
                            doSplit: doSplit
            )
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
        bottomButtons(rotationObserver: UIRotationObserver(), tfengine: TFEngine(isPreview: true), tfcalcengine: TFCalcEngine(isPreview: true), buttonsDisabled: false, buttonsPadding: 30.0)
            .preferredColorScheme(.light)
    }
}
