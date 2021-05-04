//
//  whatsnewview.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/5/4.
//

import SwiftUI

let newVersion="1.1"
let numFeats=4

struct whatsnewview: View {
    var body: some View {
        VStack(spacing:0) {
            AppLogoTitleView()
                .padding(.top,130)
                .padding(.bottom,61)
            Text("What's New in Version "+newVersion)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(.horizontal,68)
                .multilineTextAlignment(.center)
                .padding(.bottom,19)
            VStack {
                
            }
            Spacer()
        }
    }
}

struct whatsnewview_Previews: PreviewProvider {
    static var previews: some View {
        whatsnewview()
    }
}
