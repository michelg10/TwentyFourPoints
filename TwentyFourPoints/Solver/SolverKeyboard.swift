//
//  SolverKeyboard.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/7/26.
//

import SwiftUI

struct solverKeyboardRegularButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.init("SolverKeyboardAlternateKeycaps") : Color.init("SolverKeyboardRegularKeycaps"))
    }
}

struct solverKeyboardDisabledRegularButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.init("SolverKeyboardRegularKeycapsDisabled"))
    }
}

struct solverKeyboardAlternateButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.init("SolverKeyboardRegularKeycaps") : Color.init("SolverKeyboardAlternateKeycaps"))
    }
}

struct alternateButton: View {
    var text: String
    var alignment: Alignment
    var disabled: Bool
    
    var body: some View {
        ZStack(alignment: alignment) {
            if disabled {
                RoundedRectangle(cornerRadius: 9)
                    .animation(nil)
                    .foregroundColor(.init("SolverKeyboardAlternateKeycapsDisabled"))
            } else {
                RoundedRectangle(cornerRadius: 9)
                    .animation(nil)
            }
            Text(text)
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .foregroundColor(disabled ? .init("SolverKeyboardForegroundAlternateKeycapsDisabled") : .primary)
                .padding(.horizontal, 12)
        }
    }
}

struct SolverKeyboard: View {
    var numbersDisabled: [Bool]
    var deleteDisabled: Bool
    var prevNextDisabled: Bool
    var solengine: solverEngine
    
    var body: some View {
        VStack(spacing:11) {
            GeometryReader { geometry in
                let unitKeyCapWidth: CGFloat = (geometry.size.width-9.0*10.0)/1076.0*93.0
                HStack(spacing: 9.0) {
                    ForEach((1...10), id: \.self) { index in
                        let number=index%10
                        Button(action: {
                            solengine.handleKeyboardNumberPress(number: number)
                        }, label: {
                            ZStack {
                                if numbersDisabled[number] {
                                    RoundedRectangle(cornerRadius: 9)
                                        .animation(nil)
                                        .foregroundColor(.init("SolverKeyboardRegularKeycapsDisabled"))
                                } else {
                                    RoundedRectangle(cornerRadius: 9)
                                        .animation(nil)
                                }
                                Text(String(number))
                                    .font(.system(size: 22, weight: .medium, design: .rounded))
                                    .foregroundColor(numbersDisabled[number] ? .init("SolverKeyboardForegroundRegularKeycapsDisabled") : .primary)
                            }
                        }).buttonStyle(solverKeyboardRegularButtonStyle())
                        .disabled(numbersDisabled[number])
                        .keyboardShortcut(KeyEquivalent.init(.init(String(number))), modifiers: .init([]))
                    }
                    Button(action: {
                        solengine.handleKeyboardDelete()
                    }, label: {
                        alternateButton(text: NSLocalizedString("KeyboardDelete", comment: ""), alignment: .trailing, disabled: deleteDisabled)
                            .frame(width: unitKeyCapWidth*146.0/93.0)
                    }).disabled(deleteDisabled)
                    .keyboardShortcut(KeyEquivalent.delete, modifiers: .init([]))
                    .buttonStyle(solverKeyboardAlternateButtonStyle())
                }
                HStack(spacing:0) {
                    Button(action: {solengine.handleKeyboardAllDelete()}, label: {EmptyView()}).disabled(deleteDisabled).keyboardShortcut(KeyEquivalent.delete, modifiers: .command)
                    Button(action: {solengine.handleKeyboardAllDelete()}, label: {EmptyView()}).disabled(deleteDisabled).keyboardShortcut(KeyEquivalent.delete, modifiers: .option)
                }
            }.frame(height: 63)
            GeometryReader { geometry in
                let unitKeyCapWidth: CGFloat = (geometry.size.width-9.0*10.0)/1076.0*93.0
                HStack(spacing: 0) {
                    Button(action: {
                        solengine.prevResponderFocus()
                    }, label: {
                        alternateButton(text: NSLocalizedString("KeyboardPrevious", comment: ""), alignment: .leading, disabled: prevNextDisabled)
                            .frame(width: unitKeyCapWidth*179.0/93.0)
                    }).buttonStyle(solverKeyboardAlternateButtonStyle())
                    .disabled(prevNextDisabled)
                    .keyboardShortcut(KeyEquivalent.init(.init("[")), modifiers: .init([]))
                    Spacer()
                    Button(action: {
                        solengine.nextResponderFocus()
                    }, label: {
                        alternateButton(text: NSLocalizedString("KeyboardNext", comment: ""), alignment: .trailing, disabled: prevNextDisabled)
                            .frame(width: unitKeyCapWidth*179.0/93.0)
                    }).buttonStyle(solverKeyboardAlternateButtonStyle())
                    .disabled(prevNextDisabled)
                    .keyboardShortcut(KeyEquivalent.init(.init("]")), modifiers: .init([]))
                    Button(action: {solengine.nextResponderFocus()}, label: {EmptyView()}).disabled(prevNextDisabled).keyboardShortcut(KeyEquivalent.return, modifiers: .init([]))
                    Button(action: {solengine.setCardToFocus(index: 0)}, label: {EmptyView()}).disabled(prevNextDisabled).keyboardShortcut(KeyEquivalent.init(.init("[")), modifiers: .command)
                    Button(action: {solengine.setCardToFocus(index: 0)}, label: {EmptyView()}).disabled(prevNextDisabled).keyboardShortcut(KeyEquivalent.init(.init("[")), modifiers: .option)
                    Button(action: {solengine.setCardToFocus(index: 3)}, label: {EmptyView()}).disabled(prevNextDisabled).keyboardShortcut(KeyEquivalent.init(.init("]")), modifiers: .command)
                    Button(action: {solengine.setCardToFocus(index: 3)}, label: {EmptyView()}).disabled(prevNextDisabled).keyboardShortcut(KeyEquivalent.init(.init("]")), modifiers: .option)
                }
            }.frame(height: 63)
        }.padding(14)
        .padding(.bottom,100)
        .background(Color.init("SolverKeyboardDeck"))
        .cornerRadius(12.0, corners: [.topLeft, .topRight])
    }
}

struct SolverKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            VStack {
                Spacer()
                SolverKeyboard(numbersDisabled: Array(repeating: false, count: 10), deleteDisabled: false, prevNextDisabled: true, solengine: .init(isPreview: true, tfEngine: .init(isPreview: true)))
            }.edgesIgnoringSafeArea(.bottom)
            .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
