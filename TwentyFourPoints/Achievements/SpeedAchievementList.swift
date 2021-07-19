//
//  SpeedAchievementList.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/5/14.
//

import SwiftUI

struct SpeedAchievementListSection: View {
    @State var navTag: Int?
    var curLvl: Double?
    var tfengine:TFEngine
    var listType: ListType
    
    var range: ClosedRange<Int>
    @State var isHovering: [Bool]
    var body: some View {
        VStack(spacing:16) {
            ForEach(range, id: \.self) { index in
                ZStack {
                    NavigationLink(
                        destination: personaFocusView(tfengine: tfengine, persona: speedAchievement[index]),tag: index,selection: $navTag,
                        label: {
                            EmptyView()
                        })
                    Button(action: {
                        tfengine.hapticGate(hap: .medium)
                        navTag=index
                    }, label: {
                        speedAchievementListItem(index: index, curSpeed: nil, tfengine: tfengine, listType: listType)
                    }).buttonStyle(topBarButtonStyle())
                    .onHover { (hovering) in
                        isHovering[index]=hovering
                    }.brightness(isHovering[index] ? 0.03 : 0)
                }
            }
        }.padding(.bottom,15)
    }
}

struct speedAchievementListItem: View {
    var index: Int
    var curSpeed: Double?
    var tfengine: TFEngine
    var listType: ListType
    var body: some View {
        listItem(iconView: {
            Group {
                if speedAchievement[index].title == "__userDefinable__" {
                    if listType == .upNext {
                        mysteryPersonAvatar()
                    } else {
                        Circle()
                            .foregroundColor(.blue)
                    }
                } else {
                    AchievementPropic(imageName: speedAchievement[index].title, active: listType == .complete)
                }
            }
        }, titleView: {
            Text(speedAchievement[index].title == "__userDefinable__" && listType == .upNext ? "???" : speedAchievement[index].title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
        }, subtitleView: {
            Text("\(String(Int(speedAchievement[index].speedReq)))s / \(String(speedAchievement[index].qspan)) Qs"+(curSpeed == nil ? "" : " • \(curSpeed! - speedAchievement[index].speedReq)s to go"))
                .foregroundColor(.secondary)
                .font(.system(size: 15, weight: .medium, design: .rounded))
        }, showArrow: listType == .complete)
    }
}

struct speedAchievementSeperator: View {
    var text: String
    var body: some View {
        HStack(spacing:9.5) {
            Rectangle()
                .frame(height:2)
                .cornerRadius(.greatestFiniteMagnitude)
            Text(text)
                .font(.system(size: 14, weight: .bold, design: .rounded))
            Rectangle()
                .frame(height:2)
                .cornerRadius(.greatestFiniteMagnitude)
        }.padding(.horizontal,25)
        .foregroundColor(.init("SpeedAchievementsSeperator"))
    }
}

struct SpeedAchievementList_Previews: PreviewProvider {
    static var previews: some View {
        SpeedAchievementListSection(tfengine: TFEngine(isPreview: true), listType: .complete, range: 0...1, isHovering: Array(repeating: false, count: 2))
        speedAchievementSeperator(text: "10 Qs")
    }
}
