//
//  PreferencesView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/6.
//

import SwiftUI
import CoreHaptics

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
        }.frame(maxWidth:100, maxHeight:100)
        .aspectRatio(1.0, contentMode: .fit)
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
    var tfengine: TFEngine
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
            tfengine.hapticGate(hap: .medium)
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
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    tfengine.hapticGate(hap: .medium)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.init("ButtonColorActive"))
                            .frame(width:horizontalSizeClass == .regular ? 55 : 45,height:horizontalSizeClass == .regular ? 65 : 45)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.init("TextColor"))
                            .font(.system(size: horizontalSizeClass == .regular ? 27 : 22,weight: .medium))
                            .padding(.top,horizontalSizeClass == .regular ? 3 : 4)
                    }.padding(.horizontal,20)
                }).buttonStyle(topBarButtonStyle())
                .hoverEffect(.lift)
                Spacer()
            }.padding(.top,20)
            Text(NSLocalizedString("Preferences", comment: "The title of the preferences menu"))
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .padding(.top, 13)
                .padding(.bottom,17)
            List {
                if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
                    Toggle(NSLocalizedString("Haptics", comment: ""), isOn: Binding(get: {
                        tfengine.useHaptics
                    }, set: { (val) in
                        tfengine.useHaptics=val
                        tfengine.saveData()
                    }))
                }
                VStack(alignment: .leading,spacing:0) {
                    Text(NSLocalizedString("Appearance", comment: "Title for the section of preferences preferring light or dark mode"))
                        .padding(.bottom,10)
                    HStack(spacing:0) {
                        Spacer()
                        HStack(spacing:18) {
                            colorSchemeSelector(appearanceSeems: colorScheme,
                                                appearance: nil,
                                                preferredColorMode: $prefColorScheme,
                                                appearanceName: NSLocalizedString("System", comment: "Follow the system dark/light mode setting"),
                                                tfengine: tfengine
                            )
                            colorSchemeSelector(appearanceSeems: .light,
                                                appearance: .light,
                                                preferredColorMode: $prefColorScheme,
                                                appearanceName: NSLocalizedString("Light", comment: "Force light mode"),
                                                tfengine: tfengine
                            )
                            colorSchemeSelector(appearanceSeems: .dark,
                                                appearance: .dark,
                                                preferredColorMode: $prefColorScheme,
                                                appearanceName: NSLocalizedString("Dark", comment: "Force dark mode"),
                                                tfengine: tfengine
                            )
                        }.padding(.horizontal,20)
                        Spacer()
                    }
                }.padding(.bottom,10)
                HStack {
                    Text(NSLocalizedString("Keyboard", comment: "Keyboard layout settings in preferences"))
                    Spacer()
                    Picker(selection: Binding(get: {
                        tfengine.keyboardType
                    }, set: { (val) in
                        tfengine.keyboardType=val
                        tfengine.getKeyboardType()
                        tfengine.saveData()
                    }), label: Text(""), content: {
                        Text("QWERTY").tag(1)
                        Text("AZERTY").tag(2)
                    }).pickerStyle(SegmentedPickerStyle())
                    .fixedSize()
                }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Toggle(isOn: Binding(get: {
                        tfengine.useSplit
                    }, set: { (val) in
                        tfengine.useSplit=val
                        tfengine.saveData()
                    }), label: {
                        Text(NSLocalizedString("Split buttons", comment: "Whether or not to split the buttons in the problem view on iPad"))
                    })
                    if tfengine.useSplit {
                        Toggle(isOn: Binding(get: {
                            tfengine.showKeyboardTips
                        }, set: { (val) in
                            tfengine.showKeyboardTips=val
                            tfengine.saveData()
                        }), label: {
                            Text(NSLocalizedString("Show keyboard tips", comment: "Whether or not to show keyboard tips when an external keyboard is connected"))
                        }).padding(.leading,10)
                    }
                }
                Toggle(isOn: Binding(get: {
                    !tfengine.ultraCompetitive
                }, set: { (val) in
                    tfengine.ultraCompetitive = !val
                    tfengine.saveData()
                }), label: {
                    Text(NSLocalizedString("Animate number press", comment: "Enabling high performance mode"))
                })
                Toggle(isOn: Binding(get: {
                    tfengine.synciCloud
                }, set: { (val) in
                    tfengine.setiCloudSync(val: val)
                }), label: {
                    Text(NSLocalizedString("iCloud sync", comment: ""))
                })
                VStack(alignment: .leading) {
                    HStack {
                        Text(NSLocalizedString("Number Range", comment: "Set the range of the numbers for the problem"))
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
