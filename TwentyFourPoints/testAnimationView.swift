//
//  testAnimationView.swift
//  TwentyFourPoints
//
//  Created by LegitMichel777 on 2021/3/4.
//

import SwiftUI

struct supportView: UIViewRepresentable {
//    @Binding var isWorking: Bool
    
    var emitterLayer = CAEmitterLayer()
    var emitterCell = CAEmitterCell()
    
    func setUpEmitterCell() {
      // 1
      emitterCell.contents = UIImage(named: "smallStar")?.cgImage

      // 2
      emitterCell.velocity = 50.0
      emitterCell.velocityRange = 500.0

      // 3
      emitterCell.color = UIColor.black.cgColor

      // 4
      emitterCell.redRange = 1.0
      emitterCell.greenRange = 1.0
      emitterCell.blueRange = 1.0
      emitterCell.alphaRange = 0.0
      emitterCell.redSpeed = 0.0
      emitterCell.greenSpeed = 0.0
      emitterCell.blueSpeed = 0.0
      emitterCell.alphaSpeed = -0.5
      emitterCell.scaleSpeed = 0.1

      // 5
      let zeroDegreesInRadians = CGFloat(0)
      emitterCell.spin = CGFloat(Angle.init(degrees: 130).radians)
      emitterCell.spinRange = zeroDegreesInRadians
      emitterCell.emissionLatitude = zeroDegreesInRadians
      emitterCell.emissionLongitude = zeroDegreesInRadians
        emitterCell.emissionRange = CGFloat(Angle.init(degrees: 360.0).radians)

      // 6
      emitterCell.lifetime = 1.0
      emitterCell.birthRate = 250.0

      // 7
      emitterCell.xAcceleration = -800
      emitterCell.yAcceleration = 1000
    }

    func resetEmitterCells() {
      emitterLayer.emitterCells = nil
      emitterLayer.emitterCells = [emitterCell]
    }
    
    func makeUIView(context: Context) -> UIView {
        setUpEmitterCell()
        let viewForEmitterLayer = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        // 1
        resetEmitterCells()
        emitterLayer.frame = viewForEmitterLayer.bounds
        viewForEmitterLayer.layer.addSublayer(emitterLayer)

        // 2
        emitterLayer.seed = UInt32(Date().timeIntervalSince1970)

        // 3
        emitterLayer.emitterPosition = CGPoint(x: viewForEmitterLayer.bounds.midX * 1.5, y: viewForEmitterLayer.bounds.midY)

        // 4
        emitterLayer.renderMode = .additive
        return viewForEmitterLayer
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct testAnimationView: View {
    var body: some View {
        supportView()
            .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
    }
}

struct testAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        testAnimationView()
    }
}
