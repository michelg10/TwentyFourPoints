//
//  navBarButton.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/22.
//

import SwiftUI

struct navBarButton: View {
    var symbolName: String
    var active: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.init(active ? "ButtonColorActive" : "ButtonColorInactive"))
                .frame(width:horizontalSizeClass == .regular ? 55 : 45,height:horizontalSizeClass == .regular ? 65 : 45)
            Image(systemName: symbolName)
                .foregroundColor(.init(active ? "TextColor" : "ButtonInactiveTextColor"))
                .font(.system(size: horizontalSizeClass == .regular ? 27 : 22,weight: .medium))
        }.padding(.horizontal,20)
    }
}

struct navBarButton_Previews: PreviewProvider {
    static var previews: some View {
        navBarButton(symbolName: "chevron.backward", active: true)
    }
}
