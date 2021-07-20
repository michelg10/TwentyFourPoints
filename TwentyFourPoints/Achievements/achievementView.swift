//
//  achievementView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/25.
//

import SwiftUI

struct iconDescView: View {
    var locked: Bool
    var title: String
    var desc: String
    var icon: Image
    var selected: Bool
    var body: some View {
        VStack() {
            ZStack {
                ZStack {
                    Circle()
                        .frame(width:69,height:69)
                        .foregroundColor(.init("AchievementBubble"+(selected ? "Selected" : "Deselected")))
                    icon
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                        .foregroundColor(.init(selected ? .primary : .init("AchievementBubbleIconDeselected")))
                }
                if locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .frame(width:69,height:69,alignment: .bottomTrailing)
                        .foregroundColor(.init("AchievementBubbleLock"))
                }
            }.padding(.bottom,7)
            Text(title)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundColor(selected ? .primary : .init("AchievementBubbleTextDeselected"))
            Text(desc)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(selected ? .primary : .init("AchievementBubbleTextDeselected"))
        }
    }
}

struct levelAchView: View {
    var tfengine: TFEngine
    var body: some View {
        VStack(spacing:0) {
            let curLvl=getQuestionLvlIndex(getLvl: tfengine.levelInfo.lvl)
            if curLvl != -1 {
                PersonaDetail(persona: lvlachievement[curLvl])
                    .padding(.bottom,20)
            }
            if curLvl != lvlachievement.count-1 {
                LvlAchievementList(curLvl: curLvl, tfengine: tfengine, listType: .upNext)
            }
            if curLvl != -1 {
                LvlAchievementList(curLvl: curLvl, tfengine: tfengine, listType: .complete)
            }
        }
    }
}

/*
struct speedAchView: View {
    var tfengine: TFEngine
    var body: some View {
        VStack(spacing:0) {
            let curLvl=getSpeedLvlIndex(getLvl: tfengine.bestTime.time)
            if curLvl != -1 {
                PersonaDetail(persona: lvlachievement[curLvl])
                    .padding(.bottom,20)
            }
            if curLvl != speedAchievement.count-1 {
                LvlAchievementList(curLvl: curLvl, tfengine: tfengine, listType: .upNext)
            }
            if curLvl != -1 {
                LvlAchievementList(curLvl: curLvl, tfengine: tfengine, listType: .complete)
            }
        }
    }
}
 */

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
                        .padding(.bottom,31)
                    /*
                    HStack(spacing:48) {
                        VStack(spacing:0) {
                            Button(action: {
                                if tfengine.currentAchievementState != .questions {
                                    tfengine.hapticGate(hap: .medium)
                                    tfengine.currentAchievementState = .questions
                                    DispatchQueue.global().async {
                                        tfengine.saveData()
                                    }
                                    tfengine.refresh()
                                }
                            }, label: {
                                iconDescView(locked: false,
                                             title: "Questions",
                                             desc: String(tfengine.levelInfo.lvl)+" Qs",
                                             icon: Image(systemName: "rosette"),
                                             selected: tfengine.currentAchievementState == .questions
                                )
                            }).animation(nil)
                            .buttonStyle(topBarButtonStyle())
                            .hoverEffect(.lift)
                            .disabled(tfengine.currentAchievementState == .questions)
                        }
                        Button(action: {
                            if tfengine.currentAchievementState != .speed {
                                tfengine.hapticGate(hap: .medium)
                                tfengine.currentAchievementState = .speed
                                DispatchQueue.global().async {
                                    tfengine.saveData()
                                }
                                tfengine.refresh()
                            }
                        }, label: {
                            iconDescView(locked: tfengine.speedAchievementsLocked,
                                         title: "Speed",
                                         desc: tfengine.speedAchievementsLocked ? "Locked" : (String(tfengine.bestTime.time)+" / " + String(tfengine.bestTime.qspan) + " Qs"),
                                         icon: Image(systemName: "stopwatch"),
                                         selected: tfengine.currentAchievementState == .speed
                            )
                        }).animation(nil)
                        .buttonStyle(topBarButtonStyle())
                        .hoverEffect(.lift)
                        .disabled(tfengine.speedAchievementsLocked || tfengine.currentAchievementState == .speed)
                    }
                    if tfengine.speedAchievementsLocked {
                        Text("Complete \(tfengine.speedAchievementsLockedThreshold-tfengine.levelInfo.lvl) more questions to unlock speed achievements")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.init("AchievementBubbleDeselected"))
                            .padding(.horizontal,55)
                            .padding(.top,16)
                    }
                     */
                    Group {
                        if tfengine.currentAchievementState == .questions {
                            levelAchView(tfengine: tfengine)
                                .animation(springAnimation)
                                .transition(.offset(x: -UIScreen.main.bounds.width, y: 0))
                        } else {
                            levelAchView(tfengine: tfengine)
                                .animation(springAnimation)
                                .transition(.offset(x: UIScreen.main.bounds.width, y: 0))
                        }
                    }.padding(.top,41)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct achievementView_Previews: PreviewProvider {
    static var previews: some View {
        levelAchView(tfengine: TFEngine(isPreview: true))
            .previewLayout(.sizeThatFits)
        achievementView(tfengine: TFEngine(isPreview: true))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.light)
    }
}
