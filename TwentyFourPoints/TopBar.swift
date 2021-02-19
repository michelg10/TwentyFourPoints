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
                        .frame(width:52,height:52)
                    Image(systemName: "gear")
                        .font(.system(size:32))
                }
                Spacer()
                ZStack {
                    Circle()
                        .foregroundColor(Color.init("TopButtonColor"))
                        .frame(width:52,height:52)
                    Image(systemName: "chevron.forward.2")
                        .font(.system(size:27))
                }
            }
            VStack {
                Text("24 Points")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                Text("\(lvlNm) • Question \(String(lvl))")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }.padding(.top,30)
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(lvl:12345, lvlNm: "Name")
    }
}
