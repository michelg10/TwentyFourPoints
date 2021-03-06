//
//  CardLayout.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

struct cardButtonView: View {
    
    var card: card
    var active: Bool
    
    var tfengine:TFEngine
    var operational:Bool
    var index:Int
    var ultraCompetitive:Bool
    var body: some View {
        ZStack {
            Button(action: {
                tfengine.handleNumberPress(index: index)
            }, label: {
                cardView(active: active, card: card, isStationary: false, ultraCompetitive: tfengine.getUltraCompetitive())
            })
            .buttonStyle(cardButtonStyle())
            .animation(ultraCompetitive ? nil : .easeInOut(duration: competitiveButtonAnimationTime))
            .disabled(!active || !operational)
        }
    }
}

struct CardLayout: View {
    var tfengine:TFEngine //tfengine should only serve as an interface
    var cA:[Bool]
    var cs:[card]
    var cardsShouldVisible: [Bool]
    var operational: Bool
    var primID: String
    var ultraCompetitive: Bool
    let stackSpacing: CGFloat = 10 // how far away the virtual card stack is from the left edge of the view
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center,spacing: 40.0, content: {
                HStack(spacing: 30.0) {
                    GeometryReader {geometry2 in
                        let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                        VStack {
                            cardButtonView(card: cs[0], active: cA[0], tfengine: tfengine, operational: operational, index: 0, ultraCompetitive: ultraCompetitive)
                                .transition(.asymmetric(insertion: .identity, removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(.spring())
                                .position(x: cardsShouldVisible[0] ? geometry2.frame(in: .local).width-viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[0] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .animation(.easeInOut(duration: 0.3))
                                .id(primID+"-card1")
                        }.frame(width: geometry2.frame(in: .local).width, height: geometry2.frame(in: .local).height, alignment: .trailing)
                    }
                    GeometryReader {geometry2 in
                        let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                        VStack {
                            cardButtonView(card: cs[1], active: cA[1], tfengine: tfengine, operational: operational, index: 1, ultraCompetitive: ultraCompetitive)
                                .transition(.asymmetric(insertion: .identity, removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(.spring())
                                .position(x: cardsShouldVisible[1] ? viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[1] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .animation(.easeInOut(duration: 0.3))
                                .id(primID+"-card2")
                        }.frame(width: geometry2.frame(in: .local).width, height: geometry2.frame(in: .local).height, alignment: .leading)
                    }
                }
                HStack(spacing: 30.0) {
                    GeometryReader {geometry2 in
                        let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                        VStack {
                            cardButtonView(card: cs[2], active: cA[2], tfengine: tfengine, operational: operational, index: 2, ultraCompetitive: ultraCompetitive)
                                .transition(.asymmetric(insertion: .identity, removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(.spring())
                                .position(x: cardsShouldVisible[2] ? geometry2.frame(in: .local).width-viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[2] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .animation(.easeInOut(duration: 0.3))
                                .id(primID+"-card3")
                        }.frame(width: geometry2.frame(in: .local).width, height: geometry2.frame(in: .local).height, alignment: .trailing)
                    }
                    GeometryReader {geometry2 in
                        let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                        VStack {
                            cardButtonView(card: cs[3], active: cA[3], tfengine: tfengine, operational: operational, index: 3, ultraCompetitive: ultraCompetitive)
                                .transition(.asymmetric(insertion: .identity, removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
                                .animation(.spring())
                                .position(x: cardsShouldVisible[3] ? viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[3] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .animation(.easeInOut(duration: 0.3))
                                .id(primID+"-card4")
                        }.frame(width: geometry2.frame(in: .local).width, height: geometry2.frame(in: .local).height, alignment: .leading)
                    }
                }
            }).frame(width: geometry.frame(in: .local).width,height:geometry.frame(in: .local).height)
        }
    }
}

struct CardLayout_Previews: PreviewProvider {
    static var previews: some View {
        let tfengine=TFEngine(isPreview: true)
        Group {
            CardLayout(tfengine: tfengine, cA:tfengine.cA,cs: tfengine.cs, cardsShouldVisible: tfengine.cardsShouldVisible,operational: true, primID: "", ultraCompetitive: false)
                .preferredColorScheme(.light)
            CardLayout(tfengine: tfengine, cA:tfengine.cA,cs: tfengine.cs, cardsShouldVisible: tfengine.cardsShouldVisible,operational: true, primID: "", ultraCompetitive: false)
                .previewLayout(.fixed(width: 500, height: 100.0))
                .preferredColorScheme(.light)
        }
    }
}
