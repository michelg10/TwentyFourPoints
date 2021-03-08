//
//  achievementView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/25.
//

import SwiftUI

struct achievementView: View {
    var tfengine: TFEngine
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        NavigationView {
            ScrollView {
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
                Text(NSLocalizedString("achievements", comment: ""))
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .padding(.top, 13)
                    .padding(.bottom,17)
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
            .navigationBarHidden(true)
        }
    }
}

struct achievementView_Previews: PreviewProvider {
    static var previews: some View {
        achievementView(tfengine: TFEngine(isPreview: true))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.light)
    }
}
