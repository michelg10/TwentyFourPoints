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
                .foregroundColor(.white)
                .animation(nil)
                .colorMultiply(.init(clicked ? "HomeButtonPressed" : "HomeButton"))
                .animation(.easeInOut(duration: 0.1))
            RoundedRectangle(cornerRadius: 9,style: .continuous)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .animation(nil)
                .colorMultiply(Color.init(clicked ? "HomeButtonForegroundActive" : "HomeButtonForegroundInactive"))
                .animation(.easeInOut(duration: 0.1))
                .frame(width:176,height:47)
            Text(title)
                .foregroundColor(.white)
                .animation(nil)
                .colorMultiply(.init(clicked ? "HomeButtonForegroundActive" : "HomeButtonForegroundInactive"))
                .animation(.easeInOut(duration: 0.1))
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

struct achievementButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
            .animation(.easeInOut(duration: 0.1))
    }
}

struct mainView: View {
    @State var playClicked=false
    @State var solverClicked=false
    @State var navAction: Int? = 0
    @State var achPresented: Bool = false
    @State var prefPresented: Bool = false
    @State var viewDidLoad: Bool = false
    @State var achievementHover: Bool = false
    @State var playHover: Bool = false
    @State var solverHover: Bool = false
    @State var prefHover: Bool = false
    
    @ObservedObject var rotationObserver: UIRotationObserver
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var tfengine: TFEngine
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        tfengine.snapshotUBound()
                        tfengine.hapticGate(hap: .medium)
                        prefPresented=true
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.init("ButtonColorActive"))
                                .frame(width:horizontalSizeClass == .regular ? 55 : 45,height:horizontalSizeClass == .regular ? 65 : 45)
                            Image(systemName: "gearshape.fill")
                                .animation(nil)
                                .rotationEffect(.init(degrees: prefPresented ? -540:0), anchor: .center)
                                .animation(viewDidLoad ? springAnimation : nil)
                                .foregroundColor(.init("TextColor"))
                                .font(.system(size: horizontalSizeClass == .regular ? 27 : 22,weight: .medium))
                                .animation(nil)
                        }
                    }).buttonStyle(topBarButtonStyle())
                    .onHover(perform: { (hovering) in
                        prefHover=hovering
                    }).brightness(prefHover ? 0.03 : 0)
                    .sheet(isPresented: $prefPresented, onDismiss: {
                        tfengine.commitSnap()
                    }, content: {
                        PreferencesView(tfengine: tfengine, prefColorScheme: Binding(get: {
                            tfengine.preferredColorMode
                        }, set: { (value) in
                            tfengine.preferredColorMode=value
                            tfengine.saveData()
                            print("go")
                        }))
                    }).padding(.horizontal,20)
                }.padding(.top,20)
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
                if tfengine.getLvlIndex(getLvl: tfengine.levelInfo.lvl) == -1 {
                    Text("Reach Question \(String(achievement[0].lvlReq)) to unlock achievements")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,30)
                } else {
                    VStack {
                        Text("Achievements")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .offset(x: 0, y: 2)
                        Button(action: {
                            tfengine.hapticGate(hap: .medium)
                            achPresented=true
                            canNavBack=true
                            print("Nav back")
                        }, label: {
                            ZStack(alignment: .leading) {
                                HStack {
                                    AchievementPropic(imageName:tfengine.levelInfo.lvlName!, active: true)
                                        .animation(nil)
                                        .frame(width:42,height:42)
                                        .padding(.leading,8)
                                        .padding(.trailing,2)
                                    VStack(alignment: .leading) {
                                        Text(tfengine.levelInfo.lvlName!)
                                            .animation(nil)
                                            .foregroundColor(.init("TextColor"))
                                            .font(.system(size: 18, weight: .medium, design: .rounded))
                                        let myRank=tfengine.getLvlIndex(getLvl: tfengine.levelInfo.lvl)
                                        Text(myRank == achievement.count-1 ? "You've reached the final rank 😎" : "\(String(achievement[myRank+1].lvlReq-tfengine.levelInfo.lvl)) question"+(achievement[myRank+1].lvlReq-tfengine.levelInfo.lvl==1 ? "" : "s")+" to next rank")
                                            .animation(nil)
                                            .font(.system(size: 12, weight: .regular, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                }.padding(.trailing,25)
                            }.background(
                                RoundedRectangle(cornerRadius: 9)
                                    .animation(nil)
                                    .frame(height:55)
                                    .foregroundColor(.init("AchievementColor"))
                            )
                        })
                        .onHover(perform: { hovering in
                            achievementHover=hovering
                        })
                        .brightness(achievementHover ? 0.03 : 0) //0.05
                        .buttonStyle(achievementButtonStyle())
                        .sheet(isPresented: $achPresented,onDismiss: {
                            canNavBack=false
                            print("No nav back")
                        }, content: {
                            achievementView(tfengine: tfengine)
                        })
                    }
                }
                Spacer()
                VStack {
                    NavigationLink(
                        destination: ProblemView(tfengine: tfengine, rotationObserver: rotationObserver),tag: 1,selection: $navAction,
                        label: {
                            EmptyView()
                        })
                    NavigationLink(
                        destination: SolverView(tfengine: tfengine),tag: 2,selection: $navAction,
                        label: {
                            EmptyView()
                        })
                    
                    Button(action: {
                        tfengine.hapticGate(hap: .medium)
                        navAction=1
                        tfengine.cardsOnScreen=true
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
                    .onHover(perform: { hovering in
                        playHover=hovering
                    })
                    .brightness(playHover ? 0.03 : 0)
                    .padding(.bottom,12)
                    
                    Button(action: {
                        tfengine.hapticGate(hap: .medium)
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
                    .onHover(perform: { hovering in
                        solverHover=hovering
                    })
                    .brightness(solverHover ? 0.03 : 0)
                }.padding(.bottom,80)
                Spacer()
            }.navigationBarHidden(true)
            .background(Color.init("bgColor"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            tfengine.updtColorScheme()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                viewDidLoad=true
            }
            canNavBack=false
            print("No nav back")
            tfengine.cardsOnScreen=false
        }
    }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView(rotationObserver: UIRotationObserver(), tfengine: TFEngine(isPreview: true))
            .previewLayout(.device)
            .previewDevice("iPad Pro (11-inch) (2nd generation)")
    }
}
