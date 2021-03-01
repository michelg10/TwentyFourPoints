//
//  SwiftUIView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/1.
//

import SwiftUI

struct TutorialTextView: View {
    var tutString: String
    var body: some View {
        VStack {
            Spacer()
            Text(tutString)
                .padding(.horizontal,30)
                .multilineTextAlignment(.center)
                .font(.system(size: 18, weight: .regular, design: .rounded))
            Spacer()
        }
    }
}

struct TutorialTextView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialTextView(tutString: "Each puzzle consists of 4 integers between 1 and 13 and is guaranteed to have an answer. Your goal is to find a way to use addition, subtraction, and multiplication to get 24.")
    }
}
