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
                .id(id+"-rect")
                .animation(.easeInOut)
                .frame(height:CGFloat(buttonHei))
            Text(text)
                .font(.system(size: CGFloat(buttonHei*textSize), weight: .medium, design: .rounded))
                .foregroundColor(textColor)
                .id(id+"-text")
                .animation(nil)
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

struct buttons: View {
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
            GeometryReader { geometry in
                HStack {
                    Button(action: {
                        tfengine.reset()
                        tfengine.generateHaptic(hap: .medium)
                    }, label: {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                                .fill(Color.init(buttonsDisabled ? "ButtonColorInactive" : "ButtonColorActive"))
                                .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                            Text(tfengine.expr)
                                .animation(nil)
                                .foregroundColor(.white)
                                .colorMultiply(Color.init(buttonsDisabled ? "ButtonInactiveTextColor" : "TextColor"))
                                .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                                .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                                .padding(.bottom,2)
                                .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), alignment: .leading)
                            Text(tfengine.answerShow)
                                .opacity(tfengine.answerShowOpacity)
                                .animation(.easeInOut(duration: 0.3))
                                .foregroundColor(Color.init("TextColor"))
                                .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                                .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                                .padding(.bottom,2)
                                .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height:CGFloat(textInpHei), alignment: .leading)
                        }
                    }).buttonStyle(bottomButtonStyle())
                    .disabled(tfengine.expr=="" && tfengine.storedExpr == nil || buttonsDisabled || tfengine.nxtState != .ready)
                    Spacer()
                    Button(action: {
                        tfengine.doStore()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                                .fill(Color.init(buttonsDisabled || tfengine.storedExpr == nil && !tfengine.oprButtonActive ? "ButtonColorInactive" : "ButtonColorActive"))
                                .frame(width: CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                            if (tfengine.storedExpr != nil) {
                                Text(tfengine.storedExpr!) // important: This should and can only hold 2 decimal points
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
                            }
                        }
                    })
                    .id("StoreButton")
                    .buttonStyle(bottomButtonStyle())
                    .disabled(tfengine.storedExpr == nil && !tfengine.oprButtonActive || buttonsDisabled || tfengine.nxtState != .ready)
                }
            }.frame(height: CGFloat(textInpHei))
            let bottomButtonFillColor=Color.init(tfengine.oprButtonActive && !buttonsDisabled ? "ButtonColorActive" : "ButtonColorInactive")
            let bottomButtonTextColor=Color.init(tfengine.oprButtonActive && !buttonsDisabled ? "TextColor" : "ButtonInactiveTextColor")
            HStack(spacing:CGFloat(midSpace)) {
                Button(action: {
                    tfengine.handleOprPress(Opr: .add)
                }, label: {
                    bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "+", id: "BottomButtonAdd")
                }).buttonStyle(bottomButtonStyle())
                .disabled(!tfengine.oprButtonActive || buttonsDisabled || tfengine.nxtState != .ready)
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
                .disabled(!tfengine.oprButtonActive || buttonsDisabled || tfengine.nxtState != .ready)
                .modifier(konamiLog(tfengine: tfengine,daBtn: .mul))
                Button(action: {
                    tfengine.handleOprPress(Opr: .div)
                }, label: {
                    bottomButtonView(fillColor: bottomButtonFillColor, textColor: bottomButtonTextColor, text: "÷", id: "BottomButtonDiv")
                }).buttonStyle(bottomButtonStyle())
                .disabled(!tfengine.oprButtonActive || buttonsDisabled || tfengine.nxtState != .ready)
                .modifier(konamiLog(tfengine: tfengine,daBtn: .div))
            }
            
            HStack(spacing:CGFloat(midSpace)) {
                ForEach((0..<4), id:\.self) { index in
                    Button(action: {
                        tfengine.handleNumberPress(index: index)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(tfengine.cA[index] && !buttonsDisabled ? "ButtonColorActive" : "ButtonColorInactive"), textColor: Color.init(tfengine.cA[index] && !buttonsDisabled ? "TextColor" : "ButtonInactiveTextColor"), text: String(tfengine.cs[index].numb), id: "BottomButtonNum"+String(index))
                    }).buttonStyle(bottomButtonStyle())
                    .disabled(!tfengine.cA[index] || buttonsDisabled || tfengine.nxtState != .ready)
                    .modifier(konamiLog(tfengine: tfengine,daBtn: TFEngine.daBtn.allCases[4+index]))
                }
            }
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
        buttons(tfengine: TFEngine(), buttonsDisabled: false)
            .preferredColorScheme(.light)
    }
}
