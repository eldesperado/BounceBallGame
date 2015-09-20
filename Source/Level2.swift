//
//  Level2.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/20/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Level2: CCNode {
    weak var bullet: CCNode?
    weak var target: CCNode?
    weak var blocker: CCNode?

    weak var gamePlay: CCNode? {
        return self.parent as? Gameplay
    }
    
    let time = 15
    let turn = 3
    
    // MARK: Initialization
    func didLoadFromCCB() {
        // Setup
    }
}
