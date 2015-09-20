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
}
