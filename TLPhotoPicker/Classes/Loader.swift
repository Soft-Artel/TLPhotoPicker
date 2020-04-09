//
//  CircleAnimationView.swift
//  Simplanum 2
//
//  Created by Nikolay Ilin on 01.06.2019.
//  Copyright © 2018 Soft-Srtel. All rights reserved.
//

import UIKit

class CircleAnimationView : UIView {
    typealias Options = ( width:CGFloat, color:CGColor )
    
    struct DefaultOptions {
        static let compleate:Options = ( 2.0, UIColor.green.cgColor )
        static let fail:Options      = ( 2.0, UIColor.red.cgColor )
        static let error:Options      = ( 2.0, UIColor.red.cgColor )
        static let progress:Options  = ( 1.0, UIColor.white.cgColor )
        
        static let progressPoses = [ 0.7, 0.5, 0.3, 0.5, 0.1, 0.3, 0.7 ]
    }
    
    // ---------------------
    
    enum State {
        case hide
        case compleate
        case progress( Progress? )
        case fail( Error? )
        case error( Error? )
        
        var style:Options{
            switch self {
            case .hide:      return DefaultOptions.progress
            case .compleate: return DefaultOptions.compleate
            case .fail:      return DefaultOptions.fail
            case .error:      return DefaultOptions.error
            case .progress:  return DefaultOptions.progress
            }
        }
        
    }
    
    // ---------------------
    
    public var state:State = .compleate {
        didSet {
            
            switch self.state {
                
            case .progress( let progress ):
                self.progress = progress
                self.startAnimation()
                
            case .error:
                //            case .error(let err):
                self.stopAnimation()
                self.applayStyle( fromStyle: oldValue.style, toStyle: self.state.style, hideAfter: false )
                
            default:
                self.stopAnimation()
                self.applayStyle( fromStyle: oldValue.style, toStyle: self.state.style, hideAfter: true )
                
            }
            
        }
    }
    
    // ---------------------
    
    public var progress: Progress?
    
    // ---------------------
    
    fileprivate var circleLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var poseIndex = 0
    fileprivate var isAnimating:Bool = false
    
    // ---------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        self.layer.addSublayer( self.circleLayer )
        self.backgroundColor = .clear
        self.circleLayer.fillColor   = nil
        self.circleLayer.lineCap      = CAShapeLayerLineCap.round
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        let radius = min( self.bounds.size.width, self.bounds.size.height)/2.0 - self.circleLayer.lineWidth/2.0
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat( 2 * Double.pi ), clockwise: true)
        self.circleLayer.path = path.cgPath
        self.circleLayer.frame = bounds
    }
    
    deinit {
        self.stopAnimation()
        self.circleLayer.removeFromSuperlayer()
    }
    
    
    fileprivate func applayStyle( fromStyle:Options, toStyle:Options? = nil, hideAfter:Bool = true ){
        
        self.circleLayer.opacity = 1.0
        
        self.circleLayer.strokeEnd      = 1.0
        self.circleLayer.lineWidth   = fromStyle.width
        self.circleLayer.strokeColor = fromStyle.color
        
        guard let toStyle = toStyle else { return }
        
        let duration = 0.5
        
        var animation = CABasicAnimation(keyPath: "lineWidth" )
        animation.fromValue   = fromStyle.width
        animation.toValue     = toStyle.width
        animation.duration    = duration
        animation.repeatCount = 1
        animation.delegate       = self
        self.circleLayer.add(animation, forKey: animation.keyPath)
        
        animation = CABasicAnimation(keyPath: "strokeColor" )
        animation.fromValue   = fromStyle.color
        animation.toValue     = toStyle.color
        animation.duration    = duration
        animation.repeatCount = 1
        animation.delegate = self
        self.circleLayer.add(animation, forKey: animation.keyPath)
        
        animation = CABasicAnimation(keyPath: "strokeEnd" )
        animation.fromValue   = 1.0
        animation.toValue     = 1.0
        animation.duration    = 0.2
        animation.repeatCount = 1
        animation.delegate = self
        self.circleLayer.add(animation, forKey: animation.keyPath)
        
        if hideAfter {
            self.circleLayer.opacity = 0.0
            animation = CABasicAnimation(keyPath: "opacity" )
            animation.fromValue   = 1.0
            animation.toValue     = 0.0
            animation.duration    = duration * 2
            animation.timeOffset  = duration * 4
            animation.repeatCount = 1
            animation.delegate = self
            self.circleLayer.add(animation, forKey: animation.keyPath)
        }
        
    }
    
    
    fileprivate func startAnimation(){
        guard self.isAnimating == false else { return }
        
        self.applayStyle( fromStyle: DefaultOptions.progress )
        
        self.isAnimating = true
        let animation  = CABasicAnimation(keyPath: "transform.rotation" )
        
        animation.fromValue = 0
        animation.toValue   = 2 * CGFloat(Double.pi)
        animation.duration  = 1
        animation.repeatCount = Float.infinity
        
        
        
        self.circleLayer.add(animation, forKey: animation.keyPath)
        
        self.animatePoses( firstRun: true )
    }
    
    // ---------------------
    
    fileprivate func stopAnimation(){
        self.isAnimating = false
        self.circleLayer.removeAllAnimations()
    }
    
    // ---------------------
    
    fileprivate func animatePoses( firstRun:Bool = false ){
        let animation = CABasicAnimation(keyPath: "strokeEnd" )
        
        if firstRun {
            animation.fromValue = 0
            animation.duration = 0
        }
        
        
        if let progress = self.progress {
            animation.toValue = progress.fractionCompleted
        } else {
            animation.toValue  = DefaultOptions.progressPoses[ poseIndex ]
        }
        
        animation.duration = 0.5
        animation.repeatCount = 1
        animation.delegate = self
        
        self.circleLayer.add(animation, forKey: animation.keyPath)
    }
    
}

// ---------------------

extension CircleAnimationView: CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard
            let anim       = anim as? CABasicAnimation,
            let keyPath    = anim.keyPath
            else { return }
        
        self.circleLayer.setValue( anim.toValue , forKey: keyPath )
        
        guard self.isAnimating == true, keyPath == "strokeEnd" else { return }
        
        self.poseIndex = self.poseIndex < DefaultOptions.progressPoses.count - 1 ? self.poseIndex + 1 : 0
        self.animatePoses()
    }
    
}
