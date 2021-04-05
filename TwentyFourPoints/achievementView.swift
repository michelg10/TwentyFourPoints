//
//  achievementView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/25.
//

import SwiftUI

struct iconDescView: View {
    var locked: Bool
    var desc: String
    var icon: Image
    var selected: Bool
    var body: some View {
        VStack(spacing:5) {
            ZStack {
                ZStack {
                    Circle()
                        .frame(width:53,height:53)
                        .foregroundColor(.init("AchievementBubble"+(selected ? "Enabled" : "Disabled")))
                    icon
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.init(selected ? .primary : .init("AchievementBubbleDeselected")))
                }
                if locked {
                    Image(systemName: "lock.fill")
                        .frame(width:53,height:53,alignment: .bottomTrailing)
                        .foregroundColor(.init("AchievementBubbleLock"))
                }
            }
            Text(desc)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(selected ? .primary : .init("AchievementBubbleDeselected"))
        }
    }
}

struct achievementView: View {
    @ObservedObject var tfengine: TFEngine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing:0) {
                    HStack(spacing:0) {
                        Button(action: {
                            tfengine.hapticGate(hap: .medium)
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.init("ButtonColorActive"))
                                    .frame(width:horizontalSizeClass == .regular ? 55 : 45,height:horizontalSizeClass == .regular ? 65 : 45)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.primary)
                                    .font(.system(size: horizontalSizeClass == .regular ? 27 : 22,weight: .medium))
                                    .padding(.top,horizontalSizeClass == .regular ? 3 : 4)
                            }.padding(.horizontal,20)
                        }).buttonStyle(topBarButtonStyle())
                        .hoverEffect(.lift)
                        Spacer()
                    }.padding(.top,20)
                    Text(NSLocalizedString("achievements", comment: ""))
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .padding(.top, 13)
                        .padding(.bottom,21)
                    HStack(spacing:63) {
                        Button(action: {
                            
                        }, label: {
                            iconDescView(locked: false, desc: "Questions", icon: Image(systemName: "rosette"), selected: tfengine.currentAchievementState == .questions)
                        })
                        iconDescView(locked: tfengine.speedAchievementsLocked, desc: "Speed", icon: Image(systemName: "stopwatch"), selected: tfengine.currentAchievementState == .speed)
                    }
                    let curLvl=tfengine.getLvlIndex(getLvl: tfengine.levelInfo.lvl)
                    if curLvl != -1 {
                        PersonaDetail(curLvl: curLvl)
                            .padding(.bottom,20)
                    }
                    if curLvl != achievement.count-1 {
                        AchievementList(curLvl: curLvl, tfengine: tfengine, listType: .upNext)
                    }
                    if curLvl != -1 {
                        AchievementList(curLvl: curLvl, tfengine: tfengine, listType: .complete)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct achievementView_Previews: PreviewProvider {
    static var previews: some View {
        iconDescView(locked: true, desc: "Speed", icon: .init(systemName: "stopwatch"), selected: true)
        achievementView(tfengine: TFEngine(isPreview: true))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.light)
    }
}
