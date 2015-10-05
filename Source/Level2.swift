//
//  Level2.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/20/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Level2: CCNode {
    weak var bullet: CCSprite?
    weak var targetNode: CCNode?
    
    let time = 30
    let turn = 5
    
    // MARK: Initialization
    func didLoadFromCCB() {
        // Setup
    }
}
