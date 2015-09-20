//
//  Level1.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

enum Level: Int {
    case Level1Scene = 1
    case Level2Scene = 2
    
    init?(levelNumber: Int) {
        self.init(rawValue: levelNumber)
    }
    
    func getLevelName() -> String {
        switch (self) {
        case .Level1Scene:
            return "Level1"
        case .Level2Scene:
            return "Level2"
        }
    }
    
    func getLevelFilePath() -> String {
        return "Levels/" + self.getLevelName()
    }
}

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    // MARK: GUI & Nodes
    weak var turnLabel: CCLabelTTF?
    weak var timeLabel: CCLabelTTF?
    weak var levelNode: CCNode?
    weak var gamePhysicsNode: CCPhysicsNode?
    weak var messageNode: Message?
    // MARK: Objects
    var walls: [Wall]?
    weak var bullet: Bullet?
    weak var target: Target?
    // MARK: Game Properties
    var currentLevel: Level?
    var remainingTime: Int? {
        willSet {
            if newValue == 0 {
                self.gameOver()
            }
        }
        didSet {
            if let timeLabel = self.timeLabel, rTime = self.remainingTime {
                timeLabel.string = "\(rTime)"
            }
        }
    }
    
    var remainingTurns: Int? {
        willSet {
            if newValue == 0 {
                self.gameOver()
            }
        }
        didSet {
            if let turnLabel = self.turnLabel, rTurn = self.remainingTurns {
                turnLabel.string = "\(rTurn)"
            }
        }
    }
    
    // MARK: Initialization
    func didLoadFromCCB() {
        // Setup Gameplay
        self.setup()
    }
    
    override init() {
        super.init()
        // Update GUI every minute
        self.schedule("updateGUI:", interval: 1.0)
    }
    
    override func onEnter() {
        super.onEnter()
    }
    
    override func update(delta: CCTime) {
        
    }
    
    // MARK: Game loop update
    func updateGUI(delta: CCTimer) {
        // Decrease the remaining time
        self.updateRemainingTimer()
    }
    
    // MARK: Gameplay
    func nextAttemp() {
        // Decrease the remaining turn by 1
        if var rTurns = self.remainingTurns {
            rTurns--
        }
        
    }
    
    func nextLevel() {
        guard let currLevel = self.currentLevel else { return }
        let nextLevelNumber = currLevel.rawValue + 1
        if let nextLevel = Level(levelNumber: nextLevelNumber) {
            self.loadLevel(nextLevel)
        }
    }
    
    func loadLevel(targetLevel: Level) {
        // Update Current Level
        self.currentLevel = targetLevel
        
        let filePath = targetLevel.getLevelFilePath()
        
        switch (targetLevel) {
            
        case .Level1Scene:
            if let scene: Level1 = CCBReader.load(filePath) as? Level1 {
                addFirstChildForLevelNode(scene)
                self.remainingTime = scene.time
                self.remainingTurns = scene.turn
            }
        case .Level2Scene:
            if let scene: Level2 = CCBReader.load(filePath) as? Level2 {
                addFirstChildForLevelNode(scene)
                self.remainingTime = scene.time
                self.remainingTurns = scene.turn
            }
        }
    }
    
    func gameOver() {
        self.showGameOverMessageForm()
    }
    
    // MARK: Collision Handle
    // Bullet collides with Target
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, Bullet aBullet: CCNode!, Target aTarget: CCNode!) {
        guard let gPhysicsNode = self.gamePhysicsNode else { return }
        let energy = pair.totalKineticEnergy
        // Ignore all collision whose energy is below 0
        if energy > 5000 {
            // Add Post Step block to run code only once
            gPhysicsNode.space.addPostStepBlock({ () -> Void in
                print("Bullet collides with Target")
                self.updateRemainingTurn()
                if let aTarget = self.target {
                    aTarget.exploreThenRemove()
                }
                }, key: aTarget)
        }
        
        
    }
    // Bullet collides with Wall
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, Bullet aBullet: CCNode!, Wall aWall: CCNode!) {
        guard let gPhysicsNode = self.gamePhysicsNode else { return }
        let energy = pair.totalKineticEnergy
        // Ignore all collision whose energy is below 0
        if energy > 5000 {
            // Add Post Step block to run code only once
            gPhysicsNode.space.addPostStepBlock({ () -> Void in
                print("Bullet collides with Wall")
                }, key: aWall)
        }
        
    }
    
    // MARK: Private Methods
    //MARK: Setup
    private func setup() {
        self.userInteractionEnabled = true
        if let pNode = self.gamePhysicsNode {
            pNode.collisionDelegate = self
            #if DEBUG
                pNode.debugDraw = true
            #else
                pNode.debugDraw = false
            #endif
        }
        
        if let messNode = self.messageNode {
            messNode.hideMessageForm()
        }
        self.currentLevel = Level.Level2Scene
        // If there is no level playing currently, then this is the show time of Level1
        if self.currentLevel == nil {
            self.currentLevel = Level.Level1Scene
        }
        
        guard let currLevel = self.currentLevel else { fatalError("Current Level is not initialized") }
        // Load current level
        self.loadLevel(currLevel)
    }
    
    
    // MARK: Initialize Nodes
    private func initializeNodes(levelNode: CCNode) {
        // Update array of wall containing in level node
        self.walls = NodeHelper.findChildrenOfClass(Wall.self, forNode: levelNode) as? [Wall]
        if let bullets = NodeHelper.findChildrenOfClass(Bullet.self, forNode: levelNode) as? [Bullet] where bullets.count > 0 {
            self.bullet = bullets.first
        }
        if let targets = NodeHelper.findChildrenOfClass(Target.self, forNode: levelNode) as? [Target] where targets.count > 0 {
            self.target = targets.first
        }
        
    }
    
    
    private func addFirstChildForLevelNode(node: CCNode) {
        guard let levelN = self.levelNode else { return }
        let nodeName = "levelNode"
        // Remove existed level node if had
        if let existedNode = levelN.getChildByName(nodeName, recursively: true) {
            levelN.removeChild(existedNode)
        }
        levelN.addChild(node, z: 0, name: nodeName)
        // Initialize Nodes
        self.initializeNodes(node)
    }
    
    private func updateRemainingTimer() {
        guard let rTime = self.remainingTime else { return }
        if rTime <= 0 {
            return
        }
        self.remainingTime!--
    }
    
    private func updateRemainingTurn() {
        guard let rTurn = self.remainingTurns else { return }
        if rTurn <= 0 {
            return
        }
        self.remainingTurns!--
    }
    
    private func showGameOverMessageForm() {
        guard let messageForm = self.messageNode else { return }
        messageForm.showMessageForm("Game Over", buttonTitle: "Replay") { [unowned self] () -> () in
            self.showMainScene()
        }
    }
    
    private func showNextLevelMessageForm() {
        
    }
    
    private func showMainScene() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        let transition = CCTransition(crossFadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(mainScene, withTransition: transition)
    }
}
