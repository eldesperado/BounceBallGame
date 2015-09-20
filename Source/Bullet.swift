//
//  Bullet.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Bullet: CCSprite {
    var touchLocation: CGPoint?
    var touchTime: CFTimeInterval = 0
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let location = self.getTouchLocationInParentNode(touch)
        self.touchLocation = location
        self.touchTime = CACurrentMediaTime()
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        guard let intialTouchLocation = self.touchLocation, bulletPhysicsBody = self.physicsBody else { return }
        
        if let location = self.getTouchLocationInParentNode(touch) {
            let TouchTimeThreshold: CFTimeInterval = 0.1
            let TouchDistanceThreshold: CGFloat = 0.5

            if CACurrentMediaTime() - touchTime > TouchTimeThreshold {
                let swipe = ccp(location.x - intialTouchLocation.x, location.y - intialTouchLocation.y)
                let swipeLength = sqrt(swipe.x * swipe.x + swipe.y * swipe.y)
                
                if swipeLength > TouchDistanceThreshold {
                    let force = ccpMult(swipe, 200)
                    bulletPhysicsBody.applyForce(force)
                    #if DEBUG
                    print("Apply Force |-> Bullet: \(force)")
                    #endif
                }
            }
        }
        
    }
    
    // MARK: Setup
    
    // MARK: Helpers
    private func getTouchLocationInParentNode(touch: CCTouch) -> CGPoint? {
        guard let parentNode = self.parent else { return nil }
        let location = touch.locationInNode(parentNode)
        return location
    }
}
