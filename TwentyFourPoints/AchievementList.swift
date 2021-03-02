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
struct AchievementList: View {
    @State var navTag: Int?
    var curLvl: Int
    var tfengine:TFEngine
    var listType:ListType
    var body: some View {
        VStack {
            HStack {
                Text(listType == .upNext ? "Up Next" : "Complete")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                Spacer()
            }.padding(.horizontal,20)
            
            ForEach((listType == .upNext ? (curLvl+1..<achievement.count) : (0..<curLvl+1)), id: \.self) { index in
                if listType == .complete {
                    ZStack {
                        NavigationLink(
                            destination: personaFocusView(tfengine: tfengine, focusIndex: index),tag: index,selection: $navTag,
                            label: {
                                EmptyView()
                            })
                        Button(action: {
                            generateHaptic(hap: .medium)
                            navTag=index
                        }, label: {
                            achievementListItem(index: index,curLvl: curLvl, tfengine: tfengine, listType: listType)
                        }).buttonStyle(topBarButtonStyle())
                    }
                } else {
                    achievementListItem(index: index,curLvl: curLvl, tfengine: tfengine, listType: listType)
                }
            }
        }.padding(.bottom,15)
    }
}

struct AchievementList_Previews: PreviewProvider {
    static var previews: some View {
        AchievementList(curLvl: 7, tfengine: TFEngine(isPreview: true), listType: .upNext)
        AchievementList(curLvl: 7, tfengine: TFEngine(isPreview: true), listType: .complete)
    }
}

struct achievementListItem: View {
    var index: Int
    var curLvl: Int
    var tfengine:TFEngine
    var listType:ListType
    var body: some View {
        HStack {
            if achievement[index].secret && listType == .upNext {
                Circle()
                    .fill(Color.init("HiddenPictureBg"))
                    .overlay(
                        Text("?")
                            .foregroundColor(.init("TextColor"))
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                    )
                    .frame(width: 54, height: 54, alignment: .center)
            } else {
                AchievementPropic(imageName: achievement[index].name,active:listType == .complete)
                    .frame(width: 54, height: 54, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(achievement[index].secret && listType == .upNext ? "???" : achievement[index].name)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.init("TextColor"))
                Text("Reach \(String(achievement[index].lvlReq)) levels"+(listType == .complete ? "" : " • \(String(achievement[index].lvlReq-tfengine.levelInfo.lvl)) left"))
                    .foregroundColor(.secondary)
            }.padding(.leading,8)
            Spacer()
            if listType == .complete {
                Image(systemName: "chevron.forward")
                    .foregroundColor(.secondary)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
        }.background(Color.white.opacity(0.001))
        .padding(.bottom,8)
        .padding(.horizontal,30)
    }
}
