//
//  OverlayView.swift
//  Bonami
//
//  Created by Jiří Chlum on 25.05.16.
//  Copyright © 2016 Jiří Chlum. All rights reserved.
//
import UIKit
import SnapKit

public class LoadingOverlay {
    
    var overlayView = UIView()
    
    private var shouldAnimate: Bool = false
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView.backgroundColor = .whiteColor()
        view.addSubview(overlayView)
        
        // --- LAYOUT ---
        
        overlayView.addSubview(lupen7)
        overlayView.addSubview(lupen6)
        overlayView.addSubview(lupen5)
        overlayView.addSubview(lupen4)
        overlayView.addSubview(lupen3)
        overlayView.addSubview(lupen2)
        overlayView.addSubview(lupen1)
        
        lupen1.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        lupen2.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        lupen3.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        lupen4.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        lupen5.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        lupen6.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        lupen7.snp_makeConstraints { make in
            make.center.equalTo(overlayView)
        }
        
        // --- POČÁTEČNÍ POZICE ---
        
        lupen1.hidden = false
        lupen2.hidden = false
        lupen3.hidden = false
        lupen4.hidden = false
        lupen5.hidden = false
        lupen6.hidden = false
        lupen7.hidden = false
        
        // žlutý lupen, keyframe 1
        let t1 = CGAffineTransformMakeTranslation(-44, -58)
        lupen1.transform = t1
        
        // červený lupen, keyframe 1
        var t2 = CGAffineTransformMakeTranslation(-38, -50)
        t2 = CGAffineTransformScale(t2, 0.92, 0.92) // 2. lupen je ve skutečnosti větší než 1.
        t2 = CGAffineTransformRotate(t2, 1.05)
        lupen2.transform = t2
        
        // světle fialový lupen, keyframe 1
        var t3 = CGAffineTransformMakeTranslation(-34, -56)
        t3 = CGAffineTransformRotate(t3, 2.15)
        lupen3.transform = t3
        
        // tmavě fialový lupen, keyframe 1
        var t4 = CGAffineTransformMakeTranslation(-42, -54)
        t4 = CGAffineTransformRotate(t4, 2.95)
        lupen4.transform = t4
        
        // modrý lupen, keyframe 1
        var t5 = CGAffineTransformMakeTranslation(-36, -52)
        t5 = CGAffineTransformRotate(t5, 3.95)
        lupen5.transform = t5
        
        // zelený lupen, keyframe 1
        var t6 = CGAffineTransformMakeTranslation(-38, -58)
        t6 = CGAffineTransformRotate(t6, 4.8)
        lupen6.transform = t6
        
        // světle zelený lupen, keyframe 1
        var t7 = CGAffineTransformMakeTranslation(-34, -54)
        t7 = CGAffineTransformRotate(t7, 5.4)
        lupen7.transform = t7
        
        startRotation()
    }
    
    public func hideOverlayView() {
        stopAnimation()
        overlayView.removeFromSuperview()
    }
    
    private func startRotation() {
        let duration = 2.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions(rawValue: UIViewKeyframeAnimationOptions.Repeat.rawValue | UIViewKeyframeAnimationOptions.CalculationModeCubic.rawValue)
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            // --- ZAČÁTEK ROZVEŘENÍ ---
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1 / 15, animations: {
                // červený lupen, keyframe 2
                let t2 = CGAffineTransformMakeTranslation(-56, 13)
                self.lupen2.transform = t2
                
                // světle fialový lupen, keyframe 2
                var t3 = CGAffineTransformMakeTranslation(-58, 6)
                t3 = CGAffineTransformRotate(t3, 1.1)
                self.lupen3.transform = t3
                
                // tmavě fialový lupen, keyframe 2
                var t4 = CGAffineTransformMakeTranslation(-59, 15)
                t4 = CGAffineTransformRotate(t4, 1.9)
                self.lupen4.transform = t4
                
                // modrý lupen, keyframe 2
                var t5 = CGAffineTransformMakeTranslation(-55, 10)
                t5 = CGAffineTransformRotate(t5, 2.9)
                self.lupen5.transform = t5
                
                // zelený lupen, keyframe 2
                var t6 = CGAffineTransformMakeTranslation(-60, 13)
                t6 = CGAffineTransformRotate(t6, 3.75)
                self.lupen6.transform = t6
                
                // světle zelený lupen, keyframe 2
                var t7 = CGAffineTransformMakeTranslation(-55, 13)
                t7 = CGAffineTransformRotate(t7, 4.35)
                self.lupen7.transform = t7
            })
            UIView.addKeyframeWithRelativeStartTime(1 / 15, relativeDuration: 1 / 15, animations: {
                // světle fialový lupen, keyframe 3
                let t3 = CGAffineTransformMakeTranslation(-24, 61)
                self.lupen3.transform = t3
                
                // tmavě fialový lupen, keyframe 3
                var t4 = CGAffineTransformMakeTranslation(-16, 65)
                t4 = CGAffineTransformRotate(t4, 0.8)
                self.lupen4.transform = t4
                
                // modrý lupen, keyframe 3
                var t5 = CGAffineTransformMakeTranslation(-20, 58)
                t5 = CGAffineTransformRotate(t5, 1.8)
                self.lupen5.transform = t5
                
                // zelený lupen, keyframe 3
                var t6 = CGAffineTransformMakeTranslation(-22, 65)
                t6 = CGAffineTransformRotate(t6, 2.65)
                self.lupen6.transform = t6
                
                // světle zelený lupen, keyframe 3
                var t7 = CGAffineTransformMakeTranslation(-21, 60)
                t7 = CGAffineTransformRotate(t7, 3.25)
                self.lupen7.transform = t7
            })
            UIView.addKeyframeWithRelativeStartTime(2 / 15, relativeDuration: 1 / 15, animations: {
                // tmavě fialový lupen, keyframe 4
                let t4 = CGAffineTransformMakeTranslation(46, 62)
                self.lupen4.transform = t4
                
                // modrý lupen, keyframe 4
                var t5 = CGAffineTransformMakeTranslation(39, 58)
                t5 = CGAffineTransformRotate(t5, 1)
                self.lupen5.transform = t5
                
                // zelený lupen, keyframe 4
                var t6 = CGAffineTransformMakeTranslation(44, 64)
                t6 = CGAffineTransformRotate(t6, 1.85)
                self.lupen6.transform = t6
                
                // světle zelený lupen, keyframe 4
                var t7 = CGAffineTransformMakeTranslation(41, 58)
                t7 = CGAffineTransformRotate(t7, 2.45)
                self.lupen7.transform = t7
            })
            UIView.addKeyframeWithRelativeStartTime(3 / 15, relativeDuration: 1 / 15, animations: {
                // modrý lupen, keyframe 5
                let t5 = CGAffineTransformMakeTranslation(65, 19)
                self.lupen5.transform = t5
                
                // zelený lupen, keyframe 5
                var t6 = CGAffineTransformMakeTranslation(70, 19)
                t6 = CGAffineTransformRotate(t6, 0.85)
                self.lupen6.transform = t6
                
                // světle zelený lupen, keyframe 5
                var t7 = CGAffineTransformMakeTranslation(65, 19)
                t7 = CGAffineTransformRotate(t7, 1.45)
                self.lupen7.transform = t7
            })
            
            UIView.addKeyframeWithRelativeStartTime(4 / 15, relativeDuration: 1 / 15, animations: {
                // zelený lupen, keyframe 6
                let t6 = CGAffineTransformMakeTranslation(57, -25)
                self.lupen6.transform = t6
                
                // světle zelený lupen, keyframe 6
                var t7 = CGAffineTransformMakeTranslation(54, -22)
                t7 = CGAffineTransformRotate(t7, 0.6)
                self.lupen7.transform = t7
            })
            UIView.addKeyframeWithRelativeStartTime(5 / 15, relativeDuration: 1 / 15, animations: {
                // světle zelený lupen, keyframe 7
                let t7 = CGAffineTransformMakeTranslation(20, -38)
                self.lupen7.transform = t7
            })
            // --- KONEC ROZEVŘENÍ ---
            
            // --- ZAČÁTEK SEVŘENÍ ---
            UIView.addKeyframeWithRelativeStartTime(8 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 8
                var t1 = CGAffineTransformMakeTranslation(-67, 14)
                t1 = CGAffineTransformRotate(t1, -1.05)
                t1 = CGAffineTransformScale(t1, 1.02, 1.02)
                self.lupen1.transform = t1
                
                // červený lupen, keyframe 8
                var t2 = CGAffineTransformMakeTranslation(-56, 13)
                t2 = CGAffineTransformScale(t2, 0.95, 0.95) // 2. lupen je ve skutečnosti větší než 1.
                self.lupen2.transform = t2
            })
            UIView.addKeyframeWithRelativeStartTime(9 / 15, relativeDuration: 0, animations: {
                // červený lupen, keyframe 9
                self.lupen2.transform = CGAffineTransformMakeScale(0, 0)
            })
            UIView.addKeyframeWithRelativeStartTime(9 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 10
                var t1 = CGAffineTransformMakeTranslation(-21, 70)
                t1 = CGAffineTransformRotate(t1, -2.15)
                self.lupen1.transform = t1
            })
            UIView.addKeyframeWithRelativeStartTime(10 / 15, relativeDuration: 0, animations: {
                // světle fialový lupen, keyframe 11
                self.lupen3.transform = CGAffineTransformMakeScale(0, 0)
            })
            UIView.addKeyframeWithRelativeStartTime(10 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 12
                var t1 = CGAffineTransformMakeTranslation(48, 70)
                t1 = CGAffineTransformRotate(t1, -2.95)
                self.lupen1.transform = t1
            })
            UIView.addKeyframeWithRelativeStartTime(11 / 15, relativeDuration: 0, animations: {
                // tmavě fialový lupen, keyframe 13
                self.lupen4.transform = CGAffineTransformMakeScale(0, 0)
            })
            UIView.addKeyframeWithRelativeStartTime(11 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 14
                var t1 = CGAffineTransformMakeTranslation(82, 18)
                t1 = CGAffineTransformRotate(t1, -3.95)
                self.lupen1.transform = t1
            })
            UIView.addKeyframeWithRelativeStartTime(12 / 15, relativeDuration: 0, animations: {
                // modrý lupen, keyframe 15
                self.lupen5.transform = CGAffineTransformMakeScale(0, 0)
            })
            UIView.addKeyframeWithRelativeStartTime(12 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 16
                var t1 = CGAffineTransformMakeTranslation(69, -38)
                t1 = CGAffineTransformRotate(t1, -4.8)
                self.lupen1.transform = t1
            })
            UIView.addKeyframeWithRelativeStartTime(13 / 15, relativeDuration: 0, animations: {
                // zelený lupen, keyframe 17
                self.lupen6.transform = CGAffineTransformMakeScale(0, 0)
            })
            UIView.addKeyframeWithRelativeStartTime(13 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 18
                var t1 = CGAffineTransformMakeTranslation(21, -66)
                t1 = CGAffineTransformRotate(t1, -5.4)
                self.lupen1.transform = t1
            })
            UIView.addKeyframeWithRelativeStartTime(14 / 15, relativeDuration: 0, animations: {
                // světle zelený lupen, keyframe 19
                self.lupen7.transform = CGAffineTransformMakeScale(0, 0)
            })
            UIView.addKeyframeWithRelativeStartTime(14 / 15, relativeDuration: 1 / 15, animations: {
                // žlutý lupen, keyframe 20
                let t1 = CGAffineTransformMakeTranslation(-44, -58)
                self.lupen1.transform = t1
            })
            // --- KONEC SEVŘENÍ ---
            
            // --- NAVRÁCENÍ PŮVODNÍ POZICE ---
            UIView.addKeyframeWithRelativeStartTime(15 / 15, relativeDuration: 0, animations: {
                self.lupen1.hidden = false
                self.lupen2.hidden = false
                self.lupen3.hidden = false
                self.lupen4.hidden = false
                self.lupen5.hidden = false
                self.lupen6.hidden = false
                self.lupen7.hidden = false
                
                // žlutý lupen, keyframe 1
                let t1 = CGAffineTransformMakeTranslation(-44, -58)
                self.lupen1.transform = t1
                
                // červený lupen, keyframe 1
                var t2 = CGAffineTransformMakeTranslation(-38, -50)
                t2 = CGAffineTransformScale(t2, 0.92, 0.92) // 2. lupen je ve skutečnosti větší než 1.
                t2 = CGAffineTransformRotate(t2, 1.05)
                self.lupen2.transform = t2
                
                // světle fialový lupen, keyframe 1
                var t3 = CGAffineTransformMakeTranslation(-34, -56)
                t3 = CGAffineTransformRotate(t3, 2.15)
                self.lupen3.transform = t3
                
                // tmavě fialový lupen, keyframe 1
                var t4 = CGAffineTransformMakeTranslation(-42, -54)
                t4 = CGAffineTransformRotate(t4, 2.95)
                self.lupen4.transform = t4
                
                // modrý lupen, keyframe 1
                var t5 = CGAffineTransformMakeTranslation(-36, -52)
                t5 = CGAffineTransformRotate(t5, 3.95)
                self.lupen5.transform = t5
                
                // zelený lupen, keyframe 1
                var t6 = CGAffineTransformMakeTranslation(-38, -58)
                t6 = CGAffineTransformRotate(t6, 4.8)
                self.lupen6.transform = t6
                
                // světle zelený lupen, keyframe 1
                var t7 = CGAffineTransformMakeTranslation(-34, -54)
                t7 = CGAffineTransformRotate(t7, 5.4)
                self.lupen7.transform = t7
            })
            }, completion: { finished in
            // any code entered here will be applied
            // once the animation has completed
        })
    }
    
    private func stopAnimation() {
        overlayView.layer.removeAllAnimations()
    }
    
    let lupen1: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen1")
        return imageview
    }()
    
    let lupen2: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen2")
        return imageview
    }()
    let lupen3: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen3")
        return imageview
    }()
    let lupen4: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen4")
        return imageview
    }()
    let lupen5: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen5")
        return imageview
    }()
    let lupen6: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen6")
        return imageview
    }()
    let lupen7: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Lupen7")
        return imageview
    }()
}
