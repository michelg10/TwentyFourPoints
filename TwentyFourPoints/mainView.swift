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
                .animation(nil)
                .foregroundColor(.init(clicked ? "HomeButtonPressed" : "HomeButton"))
                .animation(.easeInOut(duration: 0.17))
            RoundedRectangle(cornerRadius: 9,style: .continuous)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .animation(nil)
                .colorMultiply(Color.init(clicked ? "CardForegroundBlackInactive" : "CardForegroundBlackActive"))
                .animation(.easeInOut(duration: 0.17))
                .frame(width:176,height:47)
            Text(title)
                .foregroundColor(.white)
                .animation(nil)
                .colorMultiply(.init(clicked ? "CardForegroundBlackInactive" : "CardForegroundBlackActive"))
                .animation(.easeInOut(duration: 0.17))
                .font(.system(size: 24, weight: .medium, design: .rounded))
        }
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
    @State var navAction: Int? = 0
    
    var tfengine: TFEngine
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Image("Icon")
                            .resizable()
                            .frame(width:72,height:72)
                            .padding(.trailing,4)
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
                                .frame(width:42,height:42)
                                .clipShape(Circle())
                                .padding(.leading,8)
                                .padding(.trailing,2)
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
                        destination: ProblemView(tfengine: tfengine),tag: 1,selection: $navAction,
                        label: {
                            EmptyView()
                        })
                    NavigationLink(
                        destination: SolverView(tfengine: tfengine),tag: 2,selection: $navAction,
                        label: {
                            EmptyView()
                        })
                    
                    Button(action: {
                        tfengine.generateHaptic(hap: .medium)
                        navAction=1
                    }, label: {
                        borederedButton(title: "Play", clicked: playClicked)
                    }).buttonStyle(nilButtonStyle())
                    .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                        if buttonState == .pressed {
                            playClicked=true
                        } else {
                            playClicked=false
                        }
                    }))
                    .padding(.bottom,12)
                    
                    Button(action: {
                        tfengine.generateHaptic(hap: .medium)
                        navAction=2
                    }, label: {
                        borederedButton(title: "Solver", clicked: solverClicked)
                    }).buttonStyle(nilButtonStyle())
                    .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
                        if buttonState == .pressed {
                            solverClicked=true
                        } else {
                            solverClicked=false
                        }
                    }))
                }.padding(.bottom,80)
                Spacer()
            }
        }
    }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView(tfengine: TFEngine())
    }
}
