//
//  AchievementList.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/28.
//

import SwiftUI
enum ListType {
    case upNext
    case complete
}

struct LvlAchievementList: View {
    @State var navTag: Int?
    var curLvl: Int
    var tfengine:TFEngine
    var listType:ListType
    @State var isHovering=Array(repeating: false, count: lvlachievement.count)
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                Text(listType == .upNext ? NSLocalizedString("UpNext", comment: "upnext in the achievements menu") : NSLocalizedString("Complete", comment: "complete in the achievements menu"))
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                Spacer()
            }.padding(.horizontal,20)
            .padding(.bottom,12)
            VStack(spacing:16) {
                ForEach((listType == .upNext ? (curLvl+1..<lvlachievement.count) : (0..<curLvl+1)), id: \.self) { index in
                    if listType == .complete {
                        ZStack {
                            NavigationLink(
                                destination: personaFocusView(tfengine: tfengine, persona: lvlachievement[index]),tag: index,selection: $navTag,
                                label: {
                                    EmptyView()
                                })
                            Button(action: {
                                tfengine.hapticGate(hap: .medium)
                                navTag=index
                            }, label: {
                                lvlAchievementListItem(index: index,curLvl: curLvl, tfengine: tfengine, listType: listType)
                            }).buttonStyle(topBarButtonStyle())
                            .onHover { (hovering) in
                                isHovering[index]=hovering
                            }.brightness(isHovering[index] ? 0.03 : 0)
                        }
                    } else {
                        lvlAchievementListItem(index: index,curLvl: curLvl, tfengine: tfengine, listType: listType)
                    }
                }
            }
        }.padding(.bottom,15)
    }
}

struct listItem<icon: View, title: View, subtitle: View>: View {
    var iconView: () -> icon
    var titleView: () -> title
    var subtitleView: () -> subtitle
    var showArrow: Bool
    var body: some View {
        HStack(spacing:0) {
            iconView()
                .frame(width:54, height:54, alignment: .center)
            VStack(alignment: .leading, spacing:0) {
                titleView()
                subtitleView()
            }.padding(.leading, 14)
            Spacer()
            if showArrow {
                Image(systemName: "chevron.forward")
                    .foregroundColor(.secondary)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }.background(Color.white.opacity(0.001))
        .padding(.horizontal,30)
    }
}

struct mysteryPersonAvatar: View {
    var body: some View {
        Circle()
            .fill(Color.init("HiddenPictureBg"))
            .overlay(
                Text("?")
                    .foregroundColor(.primary)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
            )
    }
}

struct lvlAchievementListItem: View {
    var index: Int
    var curLvl: Int
    var tfengine:TFEngine
    var listType:ListType
    var body: some View {
        listItem(iconView: {
            Group {
                if lvlachievement[index].secret && listType == .upNext {
                    mysteryPersonAvatar()
                } else {
                    AchievementPropic(imageName: lvlachievement[index].title,active:listType == .complete)
                }
            }
        }, titleView: {
            Text(lvlachievement[index].secret && listType == .upNext ? "???" : lvlachievement[index].title)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
        }, subtitleView: {
            Group {
                if listType == .complete {
                    Text(NSLocalizedString("achievementListItemLvlReachedPrefix",comment:"")+String(lvlachievement[index].lvlReq)+NSLocalizedString("achievementListItemLvlReachedPostfix",comment:""))
                        .foregroundColor(.secondary)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                } else {
                    dynamicAdjustText(beginTxt: NSLocalizedString("achievementListItemLvlReqPrefix",comment:"")+String(lvlachievement[index].lvlReq)+NSLocalizedString("achievementListItemLvlReqPostfixNoflexPre",comment:""),
                                      flexTxt: NSLocalizedString("achievementListItemLvlReqPostfixFlex",comment:""),
                                      endTxt: NSLocalizedString("achievementListItemLvlReqPostfixNoflexPost",comment:"")+" • "+NSLocalizedString("achievementListItemLvlLeftPrefix",comment: "")+String(lvlachievement[index].lvlReq-tfengine.levelInfo.lvl)+NSLocalizedString("achievementListItemLvlLeftPostfix",comment: ""),
                                      font: .system(size: 15, weight: .medium, design: .rounded),
                                      txtColor: .secondary
                    )
                }
            }
        }, showArrow: listType == .complete)
    }
}

struct AchievementList_Previews: PreviewProvider {
    static var previews: some View {
        LvlAchievementList(curLvl: 7, tfengine: TFEngine(isPreview: true), listType: .upNext)
        LvlAchievementList(curLvl: 7, tfengine: TFEngine(isPreview: true), listType: .complete)
    }
}
