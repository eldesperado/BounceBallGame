//
//  Level1.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var bullet: Bullet?
    weak var target: Target?
    weak var gamePhysicsNode: CCPhysicsNode?

    
    func didLoadFromCCB() {
        // Setup
        self.setup()
    }
    
    
    override func onEnter() {
        super.onEnter()
    }
    
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish()
    }
    
    
    // MARK: Private Methods
    //MARK: Setup
    private func setup() {
        guard let gPhysicsNode = self.gamePhysicsNode else { fatalError("Gameplay is not implemented!") }
        self.userInteractionEnabled = true
        gPhysicsNode.collisionDelegate = self
        // Initialize Nodes
        self.initializeNodes()

    }
    
    
    // MARK: Initialize Nodes
    private func initializeNodes() {

    }
}
