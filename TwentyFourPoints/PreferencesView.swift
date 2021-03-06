//
//  PreferencesView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/6.
//

import SwiftUI


struct icon24: View {
    var appearance: ColorScheme
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: geometry.size.width*114.0/512, style: .continuous)
                    .foregroundColor(Color.init(appearance == .light ? "Card-Active-Bg-Light" : "Card-Active-Bg-Dark"))
                RoundedRectangle(cornerRadius: geometry.size.width*86.0/512,style: .continuous)
                    .stroke(Color.init(appearance == .light ? "CardForegroundBlackActive-Light" : "CardForegroundBlackActive-Dark"), style: StrokeStyle(lineWidth: geometry.size.width*0.03, lineCap: .round, lineJoin: .round))
                    .padding(geometry.size.width*0.06)
                Text("24")
                    .font(.system(size: geometry.size.width*240/512, weight: .medium, design: .rounded))
                    .foregroundColor(Color.init(appearance == .light ? "CardForegroundBlackActive-Light" : "CardForegroundBlackActive-Dark"))
            }
        }.aspectRatio(1.0, contentMode: .fit)
    }
}

struct RightTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: rect.maxX, y: 0))
        path.addLine(to: .init(x: 0, y: rect.maxY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct HalfRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path=Path()
        path.move(to: .init(x:rect.maxX,y:0))
        path.addLine(to: .init(x:rect.midX,y:0))
        path.addLine(to: .init(x:rect.midX,y:rect.maxY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct colorSchemeSelector: View {
    var appearanceSeems: ColorScheme //what the appearance is
    var appearance: ColorScheme? // what this appearance is
    @Binding var preferredColorMode: ColorScheme?
    @State var userSelected: Bool = false
    var appearanceName: String
    var body: some View {
        Button(action: {
            if appearance == .light {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            } else if appearance == .dark {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            } else {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            }
            preferredColorMode=appearance
        }, label: {
            VStack {
                if appearance == .none {
                    ZStack {
                        icon24(appearance: appearanceSeems)
                        icon24(appearance: appearanceSeems == .light ? .dark : .light)
                            .clipShape(HalfRectangle())
                    }.padding(.horizontal,15)
                } else {
                    icon24(appearance: appearanceSeems)
                        .padding(.horizontal,15)
                }
                HStack(spacing: 5) {
                    Image(systemName: preferredColorMode == appearance ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(preferredColorMode == appearance ? Color.blue : Color.secondary)
                        .overlay(
                            Circle()
                                .foregroundColor(.init("secondary"))
                                .padding(2)
                                .animation(nil)
                                .opacity(preferredColorMode == appearance || !userSelected ? 0.0 : 1.0)
                        )
                    Text(appearanceName)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                }
            }
        }).buttonStyle(nilButtonStyle())
        .modifier(TouchDownUpEventModifier(changeState: { (buttonState) in
            if buttonState == .pressed {
                userSelected=true
            } else {
                userSelected=false
            }
        }))
    }
}

struct PreferencesView: View {
    @ObservedObject var tfengine: TFEngine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var prefColorScheme: ColorScheme?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .colorMultiply(Color.init("ButtonColorActive"))
                            .frame(width:45,height:45)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .colorMultiply(.init("TextColor"))
                            .font(.system(size:22,weight: .medium))
                            .padding(.top,3)
                    }.padding(.horizontal,20)
                }).buttonStyle(topBarButtonStyle())
                Spacer()
            }.padding(.top,20)
            Text("Preferences")
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .padding(.top, 13)
                .padding(.bottom,17)
            List {
                Toggle(isOn: Binding(get: {
                    tfengine.useHaptics
                }, set: { (val) in
                    tfengine.useHaptics=val
                    tfengine.saveData()
                }), label: {
                    Text("Haptics")
                })
                VStack(alignment: .leading,spacing:0) {
                    Text("Appearance")
                        .padding(.bottom,10)
                    HStack(spacing:18) {
                        colorSchemeSelector(appearanceSeems: colorScheme,
                                            appearance: nil,
                                            preferredColorMode: $prefColorScheme,
                                            appearanceName: "System"
                        )
                        colorSchemeSelector(appearanceSeems: .light,
                                            appearance: .light,
                                            preferredColorMode: $prefColorScheme,
                                            appearanceName: "Light"
                        )
                        colorSchemeSelector(appearanceSeems: .dark,
                                            appearance: .dark,
                                            preferredColorMode: $prefColorScheme,
                                            appearanceName: "Dark"
                        )
                    }.padding(.horizontal,20)
                }.padding(.bottom,10)
                Toggle(isOn: Binding(get: {
                    !tfengine.ultraCompetitive
                }, set: { (val) in
                    tfengine.ultraCompetitive = !val
                    tfengine.saveData()
                }), label: {
                    Text("Animate number press")
                })
                Toggle(isOn: Binding(get: {
                    tfengine.synciCloud
                }, set: { (val) in
                    tfengine.setiCloudSync(val: val)
                }), label: {
                    Text("iCloud sync")
                })
                VStack(alignment: .leading) {
                    HStack {
                        Text("Number Range")
                        Spacer()
                        Text("1 ... \(String(tfengine.upperBound))")
                    }
                    Picker(selection: Binding(get: {
                        tfengine.upperBound
                    }, set: { (val) in
                        tfengine.upperBound=val
                        tfengine.saveData()
                    }), label: Text("Number Range").foregroundColor(.init("TextColor")), content: {
                        ForEach((8...24), id:\.self) { index in
                            Text("\(String(index))").tag(index)
                        }
                    }).pickerStyle(InlinePickerStyle())
                }
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        icon24(appearance: .dark)
        PreferencesView(tfengine: TFEngine(isPreview: true), prefColorScheme: .constant(nil))
    }
}
