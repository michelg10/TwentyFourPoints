//
//  PersonaDetail.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/28.
//

import SwiftUI

struct PersonaDetail: View {
    var curLvl: Int
    var body: some View {
        VStack {
            AchievementPropic(imageName: achievement[curLvl].name, active: true)
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.bottom, 10)
            Text(achievement[curLvl].name)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
            Text(NSLocalizedString("lvlReqPrefix",comment:"The LEVEL text in the persona detail view")+String(achievement[curLvl].lvlReq)+NSLocalizedString("lvlReqPostfix",comment:"The LEVEL text in the persona detail view"))
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .padding(.bottom,1)
            Text(achievement[curLvl].description)
                .padding(.horizontal,40)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .lineSpacing(1.2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PersonaDetail_Previews: PreviewProvider {
    static var previews: some View {
        PersonaDetail(curLvl: 7)
    }
}
