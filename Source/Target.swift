//
//  Target.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Target: CCSprite {
    var rotationAngle: Float = 0
    
    func didLoadFromCCB() {
        self.physicsBody.collisionType = CollisionType.Target.rawValue
        self.physicsBody.collisionGroup = CollisionType.Target.getCollisionGroup()
    }

    func exploreThenRemove() {
        guard let parentNode = self.parent else { return }
        let explosion = CCBReader.load("Effects/Explosion") as! CCParticleSystem
        explosion.position = self.position
        parentNode.addChild(explosion)
        self.removeFromParent()
    }
    
    // MARK: Private Methods
}
