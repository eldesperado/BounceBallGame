//
//  CollisionHelper.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/20/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

enum CollisionType: String {
    case Bullet, Target, Wall
    
    func getCollisionGroup() -> String {
        return self.rawValue + "Group"
    }
}