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
    @State var isHovering=Array(repeating: false, count: lvlachievement.count)
    var body: some View {
        VStack {
            HStack {
                Text(listType == .upNext ? NSLocalizedString("UpNext", comment: "upnext in the achievements menu") : NSLocalizedString("Complete", comment: "complete in the achievements menu"))
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                Spacer()
            }.padding(.horizontal,20)
            
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
                            achievementListItem(index: index,curLvl: curLvl, tfengine: tfengine, listType: listType)
                        }).buttonStyle(topBarButtonStyle())
                        .onHover { (hovering) in
                            isHovering[index]=hovering
                        }.brightness(isHovering[index] ? 0.03 : 0)
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

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct TruncableText: View {
    let text: Text
    let lineLimit: Int?
    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    let isTruncatedUpdate: (_ isTruncated: Bool) -> Void
    
    var body: some View {
        text
            .lineLimit(lineLimit)
            .readSize { size in
                truncatedSize = size
                isTruncatedUpdate(truncatedSize != intrinsicSize)
            }
            .background(
                text
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .readSize { size in
                        intrinsicSize = size
                        isTruncatedUpdate(truncatedSize != intrinsicSize)
                    }
            )
    }
}

struct achievementListItem: View {
    var index: Int
    var curLvl: Int
    var tfengine:TFEngine
    var listType:ListType
    @State var isTruncated: Bool=false
    var body: some View {
        HStack {
            if lvlachievement[index].secret && listType == .upNext {
                Circle()
                    .fill(Color.init("HiddenPictureBg"))
                    .overlay(
                        Text("?")
                            .foregroundColor(.primary)
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                    )
                    .frame(width: 54, height: 54, alignment: .center)
            } else {
                AchievementPropic(imageName: lvlachievement[index].title,active:listType == .complete)
                    .frame(width: 54, height: 54, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(lvlachievement[index].secret && listType == .upNext ? "???" : lvlachievement[index].title)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                if listType == .complete {
                    Text(NSLocalizedString("achievementListItemLvlReachedPrefix",comment:"")+String(lvlachievement[index].lvlReq)+NSLocalizedString("achievementListItemLvlReachedPostfix",comment:""))
                        .foregroundColor(.secondary)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                } else {
                    HStack(spacing:0) {
                        Text(NSLocalizedString("achievementListItemLvlReqPrefix",comment:"")+String(lvlachievement[index].lvlReq)+NSLocalizedString("achievementListItemLvlReqPostfixNoflexPre",comment:""))
                            .foregroundColor(.secondary)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        if !isTruncated {
                            TruncableText(text: Text(NSLocalizedString("achievementListItemLvlReqPostfixFlex",comment:""))
                                            .font(.system(size: 15, weight: .medium, design: .rounded))
                                            .foregroundColor(.secondary),
                                          lineLimit: 1
                            ) {
                                isTruncated = $0
                            }
                        }
                        let tempText=NSLocalizedString("achievementListItemLvlReqPostfixNoflexPost",comment:"")+" • "
                        Text(tempText+NSLocalizedString("achievementListItemLvlLeftPrefix",comment: "")+String(lvlachievement[index].lvlReq-tfengine.levelInfo.lvl)+NSLocalizedString("achievementListItemLvlLeftPostfix",comment: ""))
                            .foregroundColor(.secondary)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
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
