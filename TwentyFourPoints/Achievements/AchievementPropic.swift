//
//  AchievementPropic.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/28.
//

import SwiftUI

struct AchievementPropic: View {
    var imageName:String
    var active:Bool
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .saturation(active ? 1 : 0)
                .opacity(active ? 1 : 0.4)
                .background(Color.init("PropicBg"))
                .clipShape(Circle())
        }
    }
}

struct AchievementPropic_Previews: PreviewProvider {
    static var previews: some View {
        AchievementPropic(imageName: "Max", active: false)
        AchievementPropic(imageName: "Alyx",active: false)
    }
}
