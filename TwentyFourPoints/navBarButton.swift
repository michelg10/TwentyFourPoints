//
//  navBarButton.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/22.
//

import SwiftUI

struct navBarButton: View {
    var symbolName: String
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.init("TopButtonColor"))
                .frame(width:45,height:45)
            Image(systemName: symbolName)
                .foregroundColor(.init("TextColor"))
                .font(.system(size:22,weight: .medium))
        }.padding(.horizontal,20)
    }
}

struct navBarButton_Previews: PreviewProvider {
    static var previews: some View {
        navBarButton(symbolName: "chevron.backward")
    }
}
