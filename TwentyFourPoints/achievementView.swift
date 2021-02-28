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
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Button(action: {
                        tfengine.generateHaptic(hap: .medium)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .colorMultiply(Color.init("ButtonColorActive"))
                                .frame(width:45,height:45)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                                .colorMultiply(.init("TextColor"))
                                .font(.system(size:22,weight: .medium))
                                .padding(.top,3)
                        }.padding(.horizontal,20)
                    }).buttonStyle(topBarButtonStyle())
                    Spacer()
                }.padding(.top,20)
                Text("Achievements")
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .padding(.top, 13)
                    .padding(.bottom,17)
                let curLvl=tfengine.getLvlIndex(getLvl: tfengine.lvl)
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
            }.navigationBarHidden(true)
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
