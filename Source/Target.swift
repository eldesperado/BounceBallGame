//
//  Target.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Target: CCSprite {
    
    func didLoadFromCCB() {
        self.physicsBody.collisionType = CollisionType.Target.rawValue
        self.physicsBody.collisionGroup = CollisionType.Target.getCollisionGroup()
    }
    
    // MARK: Private Methods
}
