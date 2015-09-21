//
//  Wall.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/19/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Wall: CCSprite {
    func didLoadFromCCB() {
        self.physicsBody.collisionType = CollisionType.Wall.rawValue
        self.physicsBody.collisionGroup = CollisionType.Wall.getCollisionGroup()
    }
    
    func showCollisionContactEffect(contactLocation: CGPoint) {
        guard let parentNode = self.parent, explosion = CCBReader.load("Effects/Bounce") as? CCParticleSystem else { return }
        explosion.position = contactLocation
        parentNode.addChild(explosion)
    }
}
