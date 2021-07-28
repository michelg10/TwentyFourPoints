//
//  TopBar.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/19.
//

import SwiftUI
import GameKit

struct topBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
    }
}
struct textButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

struct topBarButtons: View {
    var konamiCheatVisible: Bool
    var rewardVisible: Bool
    var tfengine: TFEngine
    @Binding var mainViewVisible: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                tfengine.reset()
                tfengine.hapticGate(hap: .medium)
                mainViewVisible=true
                tfengine.setAccessPointVisible(visible: true)
            }, label: {
                navBarButton(symbolName: "chevron.backward", active: !konamiCheatVisible && !rewardVisible)
            }).buttonStyle(topBarButtonStyle())
            .hoverEffect(.lift)
            .disabled(konamiCheatVisible || rewardVisible)
            Spacer()
            Button(action: {
                tfengine.nextCardView(nxtCardSet: nil)
            }, label: {
                EmptyView()
            }).disabled(konamiCheatVisible || rewardVisible)
            .keyboardShortcut(KeyEquivalent.return, modifiers: .command)
            Button(action: {
                if konamiCheatVisible {
                    tfengine.konamiLvl(setLvl: nil)
                    tfengine.hapticGate(hap: .medium)
                } else if rewardVisible {
                    tfengine.dismissRank()
                } else {
                    tfengine.nxtButtonPressed()
                }
            }, label: {
                if konamiCheatVisible {
                    navBarButton(symbolName: "xmark", active: true)
                } else if rewardVisible {
                    navBarButton(symbolName: "chevron.forward", active: true)
                } else {
                    navBarButton(symbolName: "chevron.forward.2", active: true)
                }
            }).hoverEffect(.lift)
            .keyboardShortcut(KeyEquivalent.return, modifiers: konamiCheatVisible ? .shift : .init(arrayLiteral: []))
            .buttonStyle(topBarButtonStyle())
        }
    }
}

func getQuestionText(lvl: Int) -> String {
    return NSLocalizedString("questionPrefix", comment: "The string that goes in front of the level")+String(lvl)+NSLocalizedString("questionPostfix", comment: "The string that goes after the level")
}

struct TopBarText: View {
    var lvl: Int
    var lvlName: String?
    var tfengine: TFEngine
    @Binding var achPresented: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        VStack {
            Text(NSLocalizedString("24 Points", comment: "The title of the app"))
                .font(.system(size: horizontalSizeClass == .regular ? 38 : 32, weight: .bold, design: .rounded))
            Button(action: {
                tfengine.hapticGate(hap: .medium)
                achPresented=true
                tfengine.cardsOnScreen=false
            }, label: {
                if lvlName == nil {
                    Text(getQuestionText(lvl: lvl))
                        .font(.system(size: horizontalSizeClass == .regular ? 20 : 18, weight: .regular, design: .rounded))
                        .foregroundColor(.primary)
                } else {
                    Text("\(lvlName!) • "+getQuestionText(lvl: lvl))
                        .font(.system(size: horizontalSizeClass == .regular ? 20 : 18, weight: .regular, design: .rounded))
                        .foregroundColor(.primary)
                }
            }).buttonStyle(textButtonStyle())
            .disabled(lvlName==nil)
            .sheet(isPresented: $achPresented,onDismiss: {
                tfengine.cardsOnScreen=true
            }, content: {
                achievementView(tfengine: tfengine)
            })
        }
    }
}

struct TopBar: View, Equatable {
    static func == (lhs: TopBar, rhs: TopBar) -> Bool {
        return lhs.lvl == rhs.lvl && lhs.konamiCheatVisible == rhs.konamiCheatVisible && lhs.rewardVisible == rhs.rewardVisible
    }
    
    var lvl: Int
    var lvlName: String?
    var konamiCheatVisible: Bool
    var rewardVisible: Bool
    var tfengine: TFEngine
    @Binding var mainViewVisible: Bool
    @State var achPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        ZStack(alignment: .top) {
            topBarButtons(konamiCheatVisible: konamiCheatVisible, rewardVisible: rewardVisible, tfengine: tfengine, mainViewVisible: $mainViewVisible)
            TopBarText(lvl: lvl, lvlName: lvlName, tfengine: tfengine, achPresented: $achPresented)
                .padding(.top,horizontalSizeClass == .regular ? 0 : 25)
        }.padding(.top, horizontalSizeClass == .regular ? 15 : 0)
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(lvl:10,lvlName:"Jonathan", konamiCheatVisible: false, rewardVisible: false,tfengine: TFEngine(isPreview: true), mainViewVisible: .constant(false))
    }
}
