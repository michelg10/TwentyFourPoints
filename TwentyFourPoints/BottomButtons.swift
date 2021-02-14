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
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(buttonHei/2.0*buttonRadius),style: .continuous)
                .fill(fillColor)
                .frame(height:CGFloat(buttonHei))
            Text(text)
                .font(.system(size: CGFloat(buttonHei*textSize), weight: .medium, design: .rounded))
                .foregroundColor(textColor)
        }
    }
}


struct buttons: View {
    let textInpHei=49.0
    let midSpace=10.0
    let buttonRadius=0.4
    let textField=0.65
    let textFontSize=0.5
    let textInset=0.05
    
    @ObservedObject var tfengine:TFEngine
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    ZStack {
                        Button(action: {
                            tfengine.reset()
                        }, label: {
                            RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius),style: .continuous)
                                .fill(Color.init("TopButtonColor"))
                                .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                        })
                        Text(tfengine.expr)
                            .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                            .padding(.leading, CGFloat(textInset*textField*Double(geometry.size.width-CGFloat(midSpace))))
                            .frame(width: CGFloat(textField*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .leading)
                    }
                    Spacer()
                    ZStack {
                        Button(action: {
                            tfengine.doStore()
                        }, label: {
                            RoundedRectangle(cornerRadius: CGFloat(textInpHei/2.0*buttonRadius) ,style: .continuous)
                                .fill(Color.init("TopButtonColor"))
                                .frame(width: CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                        })
                        if (tfengine.stored != nil) {
                            Text(String(round(tfengine.stored!*100)/100.0)) // important: This should and can only hold 2 decimal points
                                .font(.system(size: CGFloat(textFontSize*textInpHei),weight: .medium,design: .rounded))
                                .frame(width: CGFloat((1-textField)*Double(geometry.size.width-CGFloat(midSpace))), height: CGFloat(textInpHei), alignment: .center)
                        } else {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.system(size: CGFloat(textFontSize*textInpHei)))
                                .foregroundColor(Color.init(tfengine.oprButtonActive ? "TextColor" : "ButtonInactiveTextColor"))
                        }
                    }
                }
                HStack(spacing:CGFloat(midSpace)) {
                    Button(action: {
                        tfengine.handleOprPress(Opr: .add)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(tfengine.oprButtonActive ? "BottomButtonColorActive" : "BottomButtonColorInactive"), textColor: Color.init(tfengine.oprButtonActive ? "TextColor" : "ButtonInactiveTextColor"), text: "+")
                    })
                    Button(action: {
                        tfengine.handleOprPress(Opr: .sub)
                    }, label: {
                        bottomButtonView(fillColor: Color.init("BottomButtonColorActive"), textColor: Color.init("TextColor"), text: "-")
                    })
                    Button(action: {
                        tfengine.handleOprPress(Opr: .mul)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(tfengine.oprButtonActive ? "BottomButtonColorActive" : "BottomButtonColorInactive"), textColor: Color.init(tfengine.oprButtonActive ? "TextColor" : "ButtonInactiveTextColor"), text: "×")
                    })
                    Button(action: {
                        tfengine.handleOprPress(Opr: .div)
                    }, label: {
                        bottomButtonView(fillColor: Color.init(tfengine.expr=="" ? "BottomButtonColorActive" : "BottomButtonColorInactive"), textColor: Color.init(tfengine.oprButtonActive ? "TextColor" : "ButtonInactiveTextColor"), text: "÷")
                    })
                }
                
                HStack(spacing:CGFloat(midSpace)) {
                    ForEach((0..<4), id:\.self) { index in
                        Button(action: {
                            tfengine.handleNumberPress(index: index)
                        }, label: {
                            bottomButtonView(fillColor: Color.init(tfengine.cA[index] ? "BottomButtonColorInactive" : "BottomButtonColorActive"), textColor: Color.init(tfengine.cA[index] ? "ButtonInactiveTextColor" : "TextColor"), text: String(tfengine.cs[index].numb))
                        })
                    }
                }
            }
        }
    }
}

struct BottomButtons_Previews: PreviewProvider {
    static var previews: some View {
        buttons(tfengine: TFEngine())
            .preferredColorScheme(.light)
    }
}
