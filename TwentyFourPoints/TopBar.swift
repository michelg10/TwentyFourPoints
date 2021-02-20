//
//  TopBar.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/19.
//

import SwiftUI

struct TopBar: View {
    var lvl: Int
    var lvlNm: String
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color.init("TopButtonColor"))
                        .frame(width:45,height:45)
                    Image(systemName: "questionmark")
                        .font(.system(size:25))
                }
                Spacer()
                ZStack {
                    Circle()
                        .foregroundColor(Color.init("TopButtonColor"))
                        .frame(width:45,height:45)
                    Image(systemName: "chevron.forward.2")
                        .font(.system(size:22))
                        .padding(.leading,3)
                }
            }
            VStack {
                Text("24 Points")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                Text("\(lvlNm) • Question \(String(lvl))")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }.padding(.top,25)
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(lvl:12345, lvlNm: "Name")
    }
}
