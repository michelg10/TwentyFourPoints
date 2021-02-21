//
//  ContentView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/2/14.
//

import SwiftUI

extension AnyTransition {
    static var cardLayoutTrans: AnyTransition { get {
        AnyTransition.modifier(active: myTransitionModifier(ctrl: 1)
            ,identity: myTransitionModifier(ctrl: 0)
        )
    }}
}

struct myTransitionModifier: ViewModifier {
    let ctrl: Double
    func body(content: Content) -> some View {
        content.offset(x: CGFloat(-100*ctrl), y: 0)
    }
}



struct ContentView: View {
    @ObservedObject var tfengine:TFEngine
    @State var draggedAmt: CGSize = .zero
    var body: some View {
        VStack {
            TopBar(tfengine:tfengine)
                .padding(.horizontal,20)
                .padding(.bottom,20)
            ZStack {
                ForEach((0..<2), id:\.self) { index in
                    CardLayout(tfengine: tfengine, index: index, primID: "CardLayout"+String(index))
                        .padding(.horizontal,30)
                        .id("MasterCardLayoutView"+String(index))
                        .offset(x: CGFloat(tfengine.offset[index])*UIScreen.main.bounds.width, y: 0)
                        .offset(x: (draggedAmt.width < 0 ? -2*sqrt(-draggedAmt.width) : draggedAmt.width), y: 0)
                }
            }.background(Color.init("bgColor"))
            .simultaneousGesture(DragGesture()
                        .onChanged({ (value) in
                            draggedAmt=value.translation
                            tfengine.viewState[tfengine.curActiveView] = .retired
                            print("gesture")
                        }).onEnded({ (value) in
                            if value.predictedEndTranslation.width > UIScreen.main.bounds.width*0.6 {
                                withAnimation(.easeInOut(duration: 2)) {
                                    draggedAmt = .zero
                                    tfengine.nextCardView()
                                }
                            } else {
                                tfengine.viewState[tfengine.curActiveView] = .mature
                                draggedAmt = .zero
                            }
                        }))
            buttons(tfengine: tfengine)
                .padding(.horizontal,15)
                .padding(.bottom,50)
                .padding(.top,23)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 8")
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 12")
        ContentView(tfengine: TFEngine())
            .previewDevice("iPhone 12 Pro Max")
    }
}
