//
//  PulsingLayer.swift
//  DynamicCollectionCellExample
//
//  Created by 童星 on 2016/11/3.
//  Copyright © 2016年 童星. All rights reserved.
//

import UIKit

class PulsingLayer: CAReplicatorLayer, CAAnimationDelegate {

    var radius: CGFloat!{
    
        didSet{
        
            let diameter = radius * 2
            effect.bounds = CGRect.init(x: 0, y: 0, width: diameter, height: diameter)
            effect.cornerRadius = radius
            
        }
    }
    var fromValueForRadius: CGFloat!
    var fromValueForAlpha: CGFloat!
    var keyTimeForHalfOpacity: CGFloat!
    private var animationDur: TimeInterval?
    var animationDuration: TimeInterval?{
    
        didSet{
            if animationDuration == nil {
                animationDuration = 0
            }
            instanceDelay = (animationDuration! + pulseInterval!) / Double(haloLayerNumber!)
        }
        
        
    }
    var pulseInterval: TimeInterval?{
    
        willSet{
        
            if pulseInterval == TimeInterval.infinity {
                effect.removeAnimation(forKey: "pulse")
            }
        }
    }
    var repeatsCount: Float!
    var useTimingFunction: Bool!
    var haloLayerNumber: Int?{
    
        didSet{

            if animationDuration == nil {
                animationDuration = 0
            }
            instanceCount = haloLayerNumber!
            instanceDelay = (animationDuration! + pulseInterval!) / Double(haloLayerNumber!)
        }
    }
    var startInterval: TimeInterval!{
    
        didSet{
        
            instanceDelay = startInterval
        }
    }
    
    fileprivate var effect: CALayer!
    fileprivate var animationGroup:CAAnimationGroup!
    
    override init() {
        super.init()
        effect = CALayer()
        effect.contentsScale = UIScreen.main.scale
        effect.opacity = 0
        addSublayer(effect)
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupDefaults() {
        fromValueForRadius = 0.0
        fromValueForAlpha = 0.45
        keyTimeForHalfOpacity = 0.2
        pulseInterval = 0
        haloLayerNumber = 1
        animationDuration = 3
        useTimingFunction = true
        repeatsCount = Float.infinity
        radius = 60
        startInterval = 1
        backgroundColor = UIColor.init(colorLiteralRed: 0.8617, green: 0.0, blue: 0.3063, alpha: 0.15).cgColor
        
        
        
    }
    
    func start() {
        
        setupAnimationGroup()
        effect.add(self.animationGroup, forKey: "pulse")
    }
    
    fileprivate func setupAnimationGroup() {
        let animationGroup: CAAnimationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration! + pulseInterval!
        animationGroup.repeatCount = repeatsCount
//        if useTimingFunction {
            let defaultCurve = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
            animationGroup.timingFunction = defaultCurve
            
//        }
        
        let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = fromValueForRadius
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = animationDuration!
        
        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnimation.duration = animationDuration!
        opacityAnimation.values = [fromValueForAlpha, 0.45, 0]
        opacityAnimation.keyTimes = [0, keyTimeForHalfOpacity as NSNumber, 1]
        
        let animations = [scaleAnimation, opacityAnimation]
        animationGroup.animations = animations
        self.animationGroup = animationGroup
        self.animationGroup.delegate = self
        
    }
    
    // MARK -- CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if effect.animationKeys()?.count != 0 {
            effect.removeAllAnimations()
        }
        
        effect.removeFromSuperlayer()
        removeFromSuperlayer()
    }
    
    // MARK -- setter method

    override var frame: CGRect{
        didSet{
        
            super.frame = frame
            effect.frame = frame
        }
    }
    
    override var backgroundColor: CGColor?{
    
        didSet{
            super.backgroundColor = backgroundColor
            effect.backgroundColor = backgroundColor
        }
    }
    
    
    
    
    
    
    
    
    
}
