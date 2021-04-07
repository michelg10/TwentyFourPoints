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

struct levelAchView: View {
    var tfengine: TFEngine
    var body: some View {
        VStack(spacing:0) {
            let curLvl=tfengine.getLvlIndex(getLvl: tfengine.levelInfo.lvl)
            if curLvl != -1 {
                PersonaDetail(persona: lvlachievement[curLvl])
                    .padding(.bottom,20)
            }
            if curLvl != lvlachievement.count-1 {
                AchievementList(curLvl: curLvl, tfengine: tfengine, listType: .upNext)
            }
            if curLvl != -1 {
                AchievementList(curLvl: curLvl, tfengine: tfengine, listType: .complete)
            }
        }
    }
}

struct speedAchView: View {
    var tfengine: TFEngine
    var body: some View {
        VStack(spacing:0) {
            
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
                            if tfengine.currentAchievementState != .questions {
                                tfengine.hapticGate(hap: .medium)
                                tfengine.currentAchievementState = .questions
                                DispatchQueue.global().async {
                                    tfengine.saveData()
                                }
                                tfengine.refresh()
                            }
                        }, label: {
                            iconDescView(locked: false, desc: "Questions", icon: Image(systemName: "rosette"), selected: tfengine.currentAchievementState == .questions)
                        }).buttonStyle(topBarButtonStyle())
                        .hoverEffect(.lift)
                        .disabled(tfengine.currentAchievementState == .questions)
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
                            iconDescView(locked: tfengine.speedAchievementsLocked, desc: "Speed", icon: Image(systemName: "stopwatch"), selected: tfengine.currentAchievementState == .speed)
                        }).buttonStyle(topBarButtonStyle())
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
                    let curAchStateDesc=tfengine.currentAchievementState == .questions ? "You've done \(String(tfengine.levelInfo.lvl)) questions" : "Your best: \(String(tfengine.bestTime.time))s / \(String(tfengine.bestTime.qspan)) Qs"
                    Text(curAchStateDesc)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top,21)
                        .padding(.bottom,39)
                        .padding(.horizontal,50)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    if tfengine.currentAchievementState == .questions {
                        levelAchView(tfengine: tfengine)
                    }
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
