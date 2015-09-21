//
//  CCNode+Extension.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
// Found on http://stackoverflow.com/questions/24133058/is-there-a-way-to-set-associated-objects-in-swift
var AssociatedObjectHandle: UInt8 = 0

extension CCNode {    
    var previousX: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var previousY: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: Track the movement of the node
    // (http://stackoverflow.com/questions/23841286/how-to-know-when-all-physics-bodies-have-stopped-moving-in-cocos2d-v3-0-with-chi)

    func updatePreviousPosition() {
        self.previousX = self.position.x
        self.previousY = self.position.y
    }
    
    func hasntMoved() -> Bool? {
        guard let preX = self.previousX, preY = self.previousY else { return nil }
        let currentX = self.position.x
        let currentY = self.position.y
        
        if currentX == preX && currentY == preY {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Effects
    
    func blowupThenRemove(completionAction:(()->())? = nil) {
        guard let parentNode = self.parent, explosion = CCBReader.load("Effects/Explosion") as? CCParticleSystem else { return }
        explosion.position = self.position
        explosion.autoRemoveOnFinish = true
        parentNode.addChild(explosion)
        // Play Bounce sound
        SoundHelper.sharedInstace.playEffectTrack(SoundTrack.Boom)
        self.removeFromParent()
        // Do completion Action if exists
        if let action = completionAction {
            action()
        }
    }
}
