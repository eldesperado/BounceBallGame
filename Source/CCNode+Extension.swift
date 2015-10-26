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

extension CCNode: ParticleEffectProtocol {
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
    
    func showBlowupEffect(soundTrack: SoundTrack? = SoundTrack.Boom, removeFromParent: Bool? = false, completionAction:(()->())? = nil) {
        guard let particle = self.createExplosionParticle() else { return }
        self.displayParticle(particle, soundTrack: soundTrack, removeFromParent: removeFromParent, completionAction: completionAction)
    }
    
    func showDisappearEffect(soundTrack: SoundTrack? = nil, removeFromParent: Bool? = false, completionAction:(()->())? = nil) {
        guard let particle = self.createDisappearParticle() else { return }
        self.displayParticle(particle, soundTrack: soundTrack, removeFromParent: removeFromParent, completionAction: completionAction)
    }
    
    private func displayParticle(particle: CCParticleSystem, soundTrack: SoundTrack? = SoundTrack.Boom, removeFromParent: Bool? = false, completionAction:(()->())? = nil) {
        guard let parentNode = self.parent else { return }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            particle.position = self.position
            parentNode.addChild(particle)
            // Play Bounce sound
            if let track = soundTrack {
                SoundManager.sharedInstace.playEffectTrack(track)
            }
            if let removeAction = removeFromParent where removeAction == true {
                self.removeFromParentAndCleanup(true)
            }
            
            // Do completion Action if exists
            if let action = completionAction {
                let particleLifeTime = Double(ParticleHelper.getParticleLongestLife(particle))
                delay(particleLifeTime, closure: { () -> () in
                    action()
                })
            }

        })
    }
}
