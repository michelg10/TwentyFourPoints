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
    var foregroundColor:Color
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0, content: {
                Image(systemName:getImageNameOfIcon(icn: CardIcon)).font(.system(size: geometry.size.width*0.12))
                    .foregroundColor(foregroundColor)
                Text(numberString).font(.system(size: geometry.size.width*0.12, weight: .medium, design: .rounded))
                    .foregroundColor(foregroundColor)
            }).frame(minWidth: 0,maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical,geometry.size.width*0.07)
            .padding(.horizontal, geometry.size.width*0.06)
        }
    }
}

struct cardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .animation(.spring())
            .saturation(configuration.isPressed ? 0.95 : 1)
            .brightness(configuration.isPressed ? 0.03 : 0) //0.05
            .animation(.easeInOut(duration: 0.07))
    }
}

struct nilButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        }
        else {
            self
        }
    }
}

struct cardView: View {
    var active: Bool
    var card: card
    var isStationary: Bool
    var body: some View {
        let foregroundColor:Color=Color.init("CardForeground" + (card.CardIcon == .diamond || card.CardIcon == .heart ? "Red" : "Black") + (active ? "Active" : "Inactive"))
        Rectangle()
            .fill(Color.clear)
            .aspectRatio(128/177, contentMode: .fit)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: geometry.size.width*0.1,style: .continuous)
                            .foregroundColor(Color(active ? "Card-Active-Bg" : "Card-Inactive-Bg"))
                        RoundedRectangle(cornerRadius: geometry.size.width*0.07,style: .continuous)
                            .stroke(foregroundColor, style: StrokeStyle(lineWidth: geometry.size.width*0.013, lineCap: .round, lineJoin: .round))
                            .padding(geometry.size.width*0.025)
                        Text(String(card.numb)).font(.system(size:(geometry.size.width)*0.55, weight: .medium, design: .rounded))
                            .foregroundColor(foregroundColor)
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                        numView(CardIcon: card.CardIcon, numberString: getStringNameOfNum(num: card.numb), foregroundColor: foregroundColor)
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                        numView(CardIcon: card.CardIcon, numberString: getStringNameOfNum(num: card.numb), foregroundColor: foregroundColor)
                            .rotationEffect(.init(degrees: 180))
                            .if (isStationary) { view in
                                view.animation(nil)
                            }
                    }
                }

            )
    }
}

struct card_Previews: PreviewProvider {
    static var previews: some View {
        cardView(active: true, card: card(CardIcon: .club, numb: 2), isStationary: false)
//        CardLayout(tfengine: TFEngine(), index: 0, primID: "")
    }
}
