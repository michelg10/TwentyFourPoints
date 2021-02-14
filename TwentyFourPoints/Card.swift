//
//  card.swift
//  24 Points
//
//  Created by LegitMichel777 on 2020/12/9.
//

import SwiftUI

func getStringNameOfNum(num: Int) -> String {
    if num>=2&&num<=10 {
        return String(num)
    } else if num==1 {
        return "A"
    } else if num==11 {
        return "J"
    } else if num==12 {
        return "Q"
    } else if num==13 {
        return "K"
    }
    return "E"
}

func getImageNameOfIcon(icn:cardIcon) -> String {
    if icn == .club {
        return "suit.club.fill"
    } else if icn == .diamond {
        return "suit.diamond.fill"
    } else if icn == .heart {
        return "suit.heart.fill"
    }
    return "suit.spade.fill"
}
struct numView: View {
    var CardIcon: cardIcon
    var numberString:String
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                    .foregroundColor(Color.init("TextColor"))
                Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                    .foregroundColor(Color.init("TextColor"))
            }).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 0, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
            .padding(.vertical,geometry.size.width*0.07)
            .padding(.horizontal, geometry.size.width*0.06)
        }
    }
}

struct cardView: View {
    var number: Int
    var active: Bool
    var CardIcon: cardIcon
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: geometry.size.width*0.1,style: .continuous)
                    .fill(Color(active ? "Card-Active-Bg" : "Card-Inactive-Bg"))
                    .aspectRatio(128/177, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: geometry.size.width*0.07,style: .continuous)
                            .stroke(Color.black, style: StrokeStyle(lineWidth: geometry.size.width*0.013, lineCap: .round, lineJoin: .round))
                            .padding(geometry.size.width*0.025)
                    ).overlay(
                        ZStack {
                            numView(CardIcon: CardIcon, numberString: getStringNameOfNum(num: number))
                            numView(CardIcon: CardIcon, numberString: getStringNameOfNum(num: number))
                                .rotationEffect(.init(degrees: 180))
                        }
                    )
                Text(String(number)).font(.system(size:(geometry.size.width)*0.55, weight: .medium, design: .rounded))
                    .foregroundColor(Color.init("TextColor"))
            }
        }
    }
}

struct card_Previews: PreviewProvider {
    static var previews: some View {
        cardView(number:1, active: true, CardIcon: .club)
        CardLayout(card1: card(CardIcon: .diamond, numb: 13), card2: card(CardIcon: .club, numb: 1), card3: card(CardIcon: .spade, numb: 4), card4: card(CardIcon: .club, numb: 5), tfengine: TFEngine(), isDummy: false)
    }
}
