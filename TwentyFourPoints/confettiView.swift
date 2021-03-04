//
//  ContentView.swift
//  confettiTest
//
//  Created by LegitMichel777 on 2021/3/3.
//

// reference: https://bryce.co/recreating-imessage-confetti/

import SwiftUI
class ConfettiType {
    let shape: ConfettiShape
    let position: ConfettiPosition

    init(shape: ConfettiShape, position: ConfettiPosition) {
        self.shape = shape
        self.position = position
    }
    
    lazy var name = UUID().uuidString
    
    lazy var image: UIImage = {
        var rturn:UIImage
        switch shape {
        case .club:
            rturn = UIImage(named: "club")!
        case .diamond:
            rturn = UIImage(named: "diamond")!
        case .heart:
            rturn = UIImage(named: "heart")!
        case .spade:
            rturn = UIImage(named: "spade")!
        }
        
        return rturn
    }()
}

enum ConfettiShape {
    case heart
    case diamond
    case club
    case spade
}

enum ConfettiPosition {
    case foreground
    case background
}

let wtfDelay:Double = 0.1

struct EmitterView: UIViewRepresentable {
    var confettiTypes: [ConfettiType]
    
    func createConfettiCells() -> [CAEmitterCell] {
        return confettiTypes.map { confettiType in
            let cell = CAEmitterCell()
            cell.name = confettiType.name
            
            cell.beginTime = 0.1
            cell.birthRate = 100
            cell.contents = confettiType.image.cgImage
            cell.emissionRange = CGFloat(Double.pi)
            cell.lifetime = 10
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 0
            cell.yAcceleration = 0
            
            // Step 3: A _New_ Spin On Things
            
            cell.setValue("plane", forKey: "particleType")
            cell.setValue(Double.pi, forKey: "orientationRange")
            cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
            cell.setValue(Double.pi / 2, forKey: "orientationLatitude")
            
            return cell
        }
    }

    func createConfettiLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        
        emitterLayer.birthRate = 0
        emitterLayer.emitterCells = createConfettiCells()
        emitterLayer.emitterPosition = CGPoint(x: UIScreen.main.bounds.minX-100, y: UIScreen.main.bounds.midY*0.8)
        emitterLayer.emitterSize = CGSize(width: 100, height: 100)
        emitterLayer.emitterShape = .sphere
        emitterLayer.frame = UIScreen.main.bounds

        print("Init confetti layer")
        
        emitterLayer.beginTime = CACurrentMediaTime()+wtfDelay
        return emitterLayer
    }

    func createBehavior(type: String) -> NSObject {
        let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
        let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
        let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to:(@convention(c)(Any?, Selector, Any?) -> NSObject).self)
        return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
    }

    func horizontalWaveBehavior() -> Any {
        let behavior = createBehavior(type: "wave")
        behavior.setValue([100, 0, 0], forKeyPath: "force")
        behavior.setValue(0.5, forKeyPath: "frequency")
        return behavior
    }

    func verticalWaveBehavior() -> Any {
        let behavior = createBehavior(type: "wave")
        behavior.setValue([0, 500, 0], forKeyPath: "force")
        behavior.setValue(3, forKeyPath: "frequency")
        return behavior
    }

    func attractorBehavior(for emitterLayer: CAEmitterLayer) -> Any {
        let behavior = createBehavior(type: "attractor")
        behavior.setValue("attractor", forKeyPath: "name")

        // Attractiveness
        behavior.setValue(-290, forKeyPath: "falloff")
        behavior.setValue(250, forKeyPath: "radius")
        behavior.setValue(10, forKeyPath: "stiffness")

        // Position
        behavior.setValue(CGPoint(x: emitterLayer.emitterPosition.x-20,
                                  y: emitterLayer.emitterPosition.y),
                          forKeyPath: "position")
        behavior.setValue(-70, forKeyPath: "zPosition")

        return behavior
    }

    func addBehaviors(to layer: CAEmitterLayer) {
        layer.setValue([
            horizontalWaveBehavior(),
            verticalWaveBehavior(),
            attractorBehavior(for: layer)
        ], forKey: "emitterBehaviors")
    }
    
    func addAttractorAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = 3
        animation.keyTimes = [0, 0.4]
        animation.values = [80, 5]

        layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }

    func addBirthrateAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 1
        animation.fromValue = 1
        animation.toValue = 0

        layer.add(animation, forKey: "birthRate")
    }

    func addAnimations(to layer: CAEmitterLayer) {
        addAttractorAnimation(to: layer)
        addBirthrateAnimation(to: layer)
        addGravityAnimation(to: layer)
    }

    func dragBehavior() -> Any {
        let behavior = createBehavior(type: "drag")
        behavior.setValue("drag", forKey: "name")
        behavior.setValue(2, forKey: "drag")

        return behavior
    }

    func addDragAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 0.35
        animation.fromValue = 0
        animation.toValue = 2
        
        layer.add(animation, forKey:  "emitterBehaviors.drag.drag")
    }

    func addGravityAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.duration = 6
        animation.keyTimes = [0.05, 0.1, 0.5, 1]
        animation.values = [0, 100, 1700, 4000]
        
        for image in confettiTypes {
            layer.add(animation, forKey: "emitterCells.\(image.name).yAcceleration")
        }
    }
    
    init() {
        print("Reinit")
        confettiTypes = {
            // For each position x shape x color, construct an image
            return [ConfettiPosition.foreground, ConfettiPosition.background].flatMap { position in
                return [ConfettiShape.club, ConfettiShape.diamond, ConfettiShape.heart, ConfettiShape.spade].compactMap { shape in
                    return ConfettiType(shape: shape, position: position)
                }
            }
        }()
        foregroundConfettiLayer=createConfettiLayer()
        backgroundConfettiLayer=createConfettiLayer()
    }
    
    var foregroundConfettiLayer: CAEmitterLayer=CAEmitterLayer()
    var backgroundConfettiLayer: CAEmitterLayer=CAEmitterLayer()
    
    func makeUIView(context: Context) -> UIView {
        
        let host = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        host.backgroundColor=UIColor.clear
        
        host.layer.addSublayer(foregroundConfettiLayer)
        addBehaviors(to: foregroundConfettiLayer)
        foregroundConfettiLayer.removeAllAnimations()
        
        for emitterCell in backgroundConfettiLayer.emitterCells ?? [] {
            emitterCell.scale = 0.5
        }
        backgroundConfettiLayer.opacity = 0.5
        backgroundConfettiLayer.speed = 0.95
        host.layer.addSublayer(backgroundConfettiLayer)
        addBehaviors(to: backgroundConfettiLayer)
        
        host.isUserInteractionEnabled=false
        host.isExclusiveTouch=false
        print("Startup Confetti")
        return host
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("uiView")
        DispatchQueue.main.asyncAfter(deadline: .now()+wtfDelay) {
            if foregroundConfettiLayer.animationKeys()?.count == nil {
                addAnimations(to: foregroundConfettiLayer)
            }
            if backgroundConfettiLayer.animationKeys()?.count == nil {
                addAnimations(to: backgroundConfettiLayer)
            }
            print(foregroundConfettiLayer.animationKeys()?.count)
        }
    }
}
