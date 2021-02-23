//
//  mainView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/21.
//

import SwiftUI

struct borederedButton: View {
    let title:String
    let clicked:Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 11,style: .continuous)
                .frame(width:182,height:53)
                .foregroundColor(.init(clicked ? "HomeButtonPressed" : "HomeButton"))
            RoundedRectangle(cornerRadius: 9,style: .continuous)
                .stroke(Color.init(clicked ? "CardForegroundBlackInactive" : "CardForegroundBlackActive"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .frame(width:176,height:47)
            Text(title)
                .foregroundColor(.white)
                .colorMultiply(.init(clicked ? "CardForegroundBlackInactive" : "CardForegroundBlackActive"))
                .font(.system(size: 24, weight: .medium, design: .rounded))
        }.animation(.easeInOut(duration: 0.17))
    }
}

public enum ButtonState {
    case pressed
    case notPressed
}

public struct TouchDownUpEventModifier: ViewModifier {
    @GestureState private var isPressed = false
    
    let changeState: (ButtonState) -> Void
    
    public func body(content: Content) -> some View {
        let drag = DragGesture(minimumDistance: 0)
            .updating($isPressed) { (value, gestureState, transaction) in
                gestureState = true
            }
        
        return content
            .simultaneousGesture(drag)
            .onChange(of: isPressed, perform: { (pressed) in
                if pressed {
                    self.changeState(.pressed)
                } else {
                    self.changeState(.notPressed)
                }
            })
    }
    
    public init(changeState: @escaping (ButtonState) -> Void) {
        self.changeState = changeState
    }
}

struct mainView: View {
    @State var playClicked=false
    @State var solverClicked=false
    
    var tfengine: TFEngine
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Image("Icon")
                            .resizable()
                            .frame(width:72,height:72)
                        Text("Points")
                            .font(.system(size: 36, weight: .medium, design: .rounded))
                    }.padding(.bottom,7)
                    Text("Add, subtract, multiply, and divide four integers to get 24")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                }
                Spacer()
                VStack {
                    Text("Achievements")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .offset(x: 0, y: 5)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 9)
                            .frame(width:266,height:53)
                            .foregroundColor(.init("AchievementColor"))
                        HStack {
                            Image("ProfilePlaceholder")
                                .resizable()
                                .frame(width:53,height:53)
                                .cornerRadius(9)
                                .padding(.trailing,4)
                            VStack(alignment: .leading) {
                                Text("Placeholder")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                Text("420 questions to next rank")
                                    .font(.system(size: 12, weight: .regular, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Spacer()
                VStack {
                    NavigationLink(
                        destination: ProblemView(tfengine: tfengine),
                        label: {
                            borederedButton(title: "Play", clicked: playClicked)
                        })
                        .buttonStyle(nilButtonStyle())
                        .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                            if buttonState == .pressed {
                                playClicked=true
                            } else {
                                playClicked=false
                            }
                        }))
                        .padding(.bottom,12)
                    
                    NavigationLink(
                        destination: SolverView(tfengine: tfengine),
                        label: {
                            borederedButton(title: "Solver", clicked: solverClicked)
                        })
                        .buttonStyle(nilButtonStyle())
                        .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                            if buttonState == .pressed {
                                solverClicked=true
                            } else {
                                solverClicked=false
                            }
                        }))
                }.padding(.bottom,80)
            }
        }
    }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView(tfengine: TFEngine())
    }
}
