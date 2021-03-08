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
        }.transition(.asymmetric(insertion: .identity, removal: .offset(x: UIScreen.main.bounds.width, y: 0)))
        .animation(.spring())
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
    @State var cardsHover = Array(repeating: false, count:4)
    @ObservedObject var rotationObserver : UIRotationObserver
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        if verticalSizeClass == .regular && horizontalSizeClass == .regular && !rotationObserver.isPortrait { //&& UIScreen.main.bounds.width>UIScreen.main.bounds.height
            let cardShouldVisibleHorzMap=[2,0,3,1]
            
            let sidePadding: Double=50.0
            let cardSpacing: Double=0.07
            
            VStack(spacing:0) {
                Spacer()
                HStack(spacing: CGFloat((Double(UIScreen.main.bounds.width)-2*sidePadding)*cardSpacing)) {
                    ForEach((0..<4), id:\.self) { index in
                        cardButtonView(card: cs[index], active: cA[index], tfengine: tfengine, operational: operational, index: index, ultraCompetitive: ultraCompetitive)
                            .brightness(cardsHover[index] ? hoverBrightness : 0)
                            .offset(x: cardsShouldVisible[cardShouldVisibleHorzMap[index]] ? 0 : -UIScreen.main.bounds.width, y: 0)
                            .id(primID+"-card"+String(index+1))
                            .onHover { (isHovering) in
                                cardsHover[index]=isHovering
                            }
                    }
                }
                Spacer()
            }.padding(.horizontal,CGFloat(sidePadding))
        } else {
            GeometryReader { geometry in
                VStack(alignment: .center,spacing: 40.0, content: {
                    HStack(spacing: 30.0) {
                        GeometryReader {geometry2 in
                            let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                            cardButtonView(card: cs[0], active: cA[0], tfengine: tfengine, operational: operational, index: 0, ultraCompetitive: ultraCompetitive)
                                .brightness(cardsHover[0] ? hoverBrightness : 0)
                                .position(x: cardsShouldVisible[0] ? geometry2.frame(in: .local).width-viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[0] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .id(primID+"-card1")
                                .onHover { (isHovering) in
                                    cardsHover[0]=isHovering
                                }
                        }
                        GeometryReader {geometry2 in
                            let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                            cardButtonView(card: cs[1], active: cA[1], tfengine: tfengine, operational: operational, index: 1, ultraCompetitive: ultraCompetitive)
                                .brightness(cardsHover[1] ? hoverBrightness : 0)
                                .position(x: cardsShouldVisible[1] ? viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[1] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .id(primID+"-card2")
                                .onHover { (isHovering) in
                                    cardsHover[1]=isHovering
                                }
                        }
                    }
                    HStack(spacing: 30.0) {
                        GeometryReader {geometry2 in
                            let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                            cardButtonView(card: cs[2], active: cA[2], tfengine: tfengine, operational: operational, index: 2, ultraCompetitive: ultraCompetitive)
                                .brightness(cardsHover[2] ? hoverBrightness : 0)
                                .position(x: cardsShouldVisible[2] ? geometry2.frame(in: .local).width-viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[2] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .id(primID+"-card3")
                                .onHover { (isHovering) in
                                    cardsHover[2]=isHovering
                                }
                        }
                        GeometryReader {geometry2 in
                            let viewWidth:CGFloat=min(geometry2.frame(in: .local).width,geometry2.frame(in: .local).height/177.0*128)
                            cardButtonView(card: cs[3], active: cA[3], tfengine: tfengine, operational: operational, index: 3, ultraCompetitive: ultraCompetitive)
                                .brightness(cardsHover[3] ? hoverBrightness : 0)
                                .position(x: cardsShouldVisible[3] ? viewWidth/2 : -geometry2.frame(in: .global).minX-viewWidth+stackSpacing,y:tfengine.cardsShouldVisible[3] ? geometry2.frame(in: .local).height/2 : -geometry2.frame(in: .global).minY+geometry.frame(in: .global).midY)
                                .id(primID+"-card4")
                                .onHover { (isHovering) in
                                    cardsHover[3]=isHovering
                                }
                        }
                    }
                }).frame(width: geometry.frame(in: .local).width,height:geometry.frame(in: .local).height)
            }
        }
    }
}

struct CardLayout_Previews: PreviewProvider {
    static var previews: some View {
        let tfengine=TFEngine(isPreview: true)
        Group {
            CardLayout(tfengine: tfengine, cA:tfengine.cA,cs: tfengine.cs, cardsShouldVisible: tfengine.cardsShouldVisible,operational: true, primID: "", ultraCompetitive: false, rotationObserver: UIRotationObserver())
                .preferredColorScheme(.light)
            ProblemView(tfengine: TFEngine(isPreview: true), rotationObserver: UIRotationObserver())
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.verticalSizeClass, .regular)
                .previewLayout(.fixed(width: 1194, height: 834))
                .preferredColorScheme(.light)
            ProblemView(tfengine: TFEngine(isPreview: true), rotationObserver: UIRotationObserver())
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.verticalSizeClass, .regular)
                .previewLayout(.fixed(width: 1194*2/3, height: 834))
                .preferredColorScheme(.light)
            ProblemView(tfengine: TFEngine(isPreview: true), rotationObserver: UIRotationObserver())
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.verticalSizeClass, .regular)
                .previewLayout(.fixed(width: 1024, height: 768))
                .preferredColorScheme(.light)
        }
    }
}
