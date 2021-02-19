//
//  ContentView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var tfengine:TFEngine
    var body: some View {
        VStack {
            TopBar(lvl: tfengine.lvl, lvlNm: tfengine.getLvlName())
                .padding(.horizontal,20)
                .padding(.vertical,20)
            Spacer()
            CardLayout(tfengine: tfengine, isDummy: false)
                .padding(.horizontal,25)
            Spacer()
            buttons(tfengine: tfengine)
                .padding(.horizontal,15)
                .padding(.bottom,10)
                .padding(.top,20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 12")
    }
}
