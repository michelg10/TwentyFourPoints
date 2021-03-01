//
//  noobLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct noobLayout: View {
    var body: some View {
        VStack {
            Text("24 Points")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("Tutorial")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.init("TextColor"))
            TutorialTextView(tutString: "hi")
        }.padding(.top,25)
    }
}

struct noobLayout_Previews: PreviewProvider {
    static var previews: some View {
        noobLayout()
    }
}
