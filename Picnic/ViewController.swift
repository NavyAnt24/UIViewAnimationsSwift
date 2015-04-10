//
//  ViewController.swift
//  Picnic
//
//  Created by David Attarzadeh on 4/4/15.
//  Copyright (c) 2015 DavidAttarzadeh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var basketTop: UIImageView!
    @IBOutlet weak var basketBottom: UIImageView!
    @IBOutlet weak var fabricTop: UIImageView!
    @IBOutlet weak var fabricBottom: UIImageView!
    @IBOutlet weak var coffeeMaker: UIImageView!
    var isCoffeMakerDead = false
    let tap: UITapGestureRecognizer?
    let squishPlayer: AVAudioPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init(coder aDecoder: NSCoder) {
        let squishPath = NSBundle.mainBundle().pathForResource("squish", ofType: "caf")
        let squishURL = NSURL(fileURLWithPath: squishPath!)
        squishPlayer = AVAudioPlayer(contentsOfURL: squishURL, error: nil)
        squishPlayer.prepareToPlay()
        
        super.init(coder: aDecoder)
        tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            var basketTopFrame = self.basketTop.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height
            
            var basketBottomFrame = self.basketBottom.frame
            basketBottomFrame.origin.y += basketBottomFrame.size.height
            
            self.basketTop.frame = basketTopFrame
            self.basketBottom.frame = basketBottomFrame
        }, completion: { finished in
            println("Basket doors opened!")
        })
        
        UIView.animateWithDuration(1.0, delay: 1.2, options: .CurveEaseOut, animations: {
            var fabricTopFrame = self.fabricTop.frame
            fabricTopFrame.origin.y -= fabricTopFrame.size.height
            
            var fabricBottomFrame = self.fabricBottom.frame
            fabricBottomFrame.origin.y += fabricBottomFrame.size.height
            
            self.fabricTop.frame = fabricTopFrame
            self.fabricBottom.frame = fabricBottomFrame
            }, completion: { finished in
                println("Fabric doors opened!")
        })
        
        moveCoffeeMakerLeft()
        view.addGestureRecognizer(tap!)
    }
    
    func closeBasket() {
        UIView.animateWithDuration(0.7, delay: 0.8, options: .CurveEaseOut, animations: {
            var basketTopFrame = self.basketTop.frame
            basketTopFrame.origin.y += basketTopFrame.size.height
            
            var basketBottomFrame = self.basketBottom.frame
            basketBottomFrame.origin.y -= basketBottomFrame.size.height
            
            self.basketTop.frame = basketTopFrame
            self.basketBottom.frame = basketBottomFrame
            }, completion: { finished in
                println("Closed the basket doors!")
        })
        
        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseOut, animations: {
            var fabricTopFrame = self.fabricTop.frame
            fabricTopFrame.origin.y += fabricTopFrame.size.height
            
            var fabricBottomFrame = self.fabricBottom.frame
            fabricBottomFrame.origin.y -= fabricBottomFrame.size.height
            
            self.fabricTop.frame = fabricTopFrame
            self.fabricBottom.frame = fabricBottomFrame
            }, completion: { finished in
                println("Fabric doors closed!")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func moveCoffeeMakerLeft() {
        if isCoffeMakerDead { return }
        
        UIView.animateWithDuration(1.0,
            delay: 2.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.coffeeMaker.center = CGPoint(x: 75, y: 200)
            }, completion: { finished in
                println("Coffeemaker moved left!")
                self.faceCoffeeMakerRight()
        })
    }
    
    func faceCoffeeMakerRight() {
        if isCoffeMakerDead { return }
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.coffeeMaker.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }, completion: { finished in
                println("Coffeemaker facing right!")
                self.moveCoffeeMakerRight()
        })
    }
    
    func moveCoffeeMakerRight() {
        if isCoffeMakerDead { return }

        UIView.animateWithDuration(1.0,
            delay: 2.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.coffeeMaker.center = CGPoint(x: 230, y: 250)
            }, completion: { finished in
                println("Coffeemaker moved right!")
                self.faceCoffeeMakerLeft()
        })
    }
    
    func faceCoffeeMakerLeft() {
        if isCoffeMakerDead { return }
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.coffeeMaker.transform = CGAffineTransformMakeRotation(0.0)
            }, completion: { finished in
                println("Coffeemaker faced left!")
                self.moveCoffeeMakerLeft()
        })
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.locationInView(coffeeMaker.superview)
        if coffeeMaker.layer.presentationLayer().frame.contains(tapLocation) {
            println("Bug tapped")
            
            if isCoffeMakerDead { return }
            view.removeGestureRecognizer(tap!)
            squishPlayer.play()
            isCoffeMakerDead = true
            UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
                self.coffeeMaker.transform = CGAffineTransformMakeScale(1.5, 0.75)
                }, completion: { finished in
                    UIView.animateWithDuration(2.0, delay: 2.0, options: nil, animations: {
                        self.coffeeMaker.alpha = 0.0
                        }, completion: { finished in
                            self.coffeeMaker.removeFromSuperview()
                            self.closeBasket()
                    })
            })
            
        } else {
            println("Bug not tapped")
        }
    }
}

