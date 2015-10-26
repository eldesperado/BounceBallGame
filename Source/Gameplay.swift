//
//  Level1.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    // MARK: GUI & Nodes
    weak var turnLabel: CCLabelTTF?
    weak var timeLabel: CCLabelTTF?
    weak var gameLevelNode: CCNode?
    weak var gamePhysicsNode: CCPhysicsNode?
    weak var messageNode: Message?
    
    weak var testLabel: CCLabelTTF?
    
    // MARK: Objects
    weak var bullet: Bullet?
    weak var targetNode: CCNode?
    // MARK: Game Properties
    var currentLevel: Level?
    
    // MARK: Private Attributes
    private var initialBulletPosition: CGPoint?
    private var timer: NSTimer?
    
    private var isPlayable = true {
        didSet {
            if let myBullet = self.bullet {
                myBullet.userInteractionEnabled = self.isPlayable
            }
        }
    }
    
    private var remainingTime: Int? {
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
    
    private var remainingTurns: Int? {
        willSet {
            if newValue == 0 && self.isPlayable == true {
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

    
    override func onEnter() {
        super.onEnter()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateGUI:", userInfo: nil, repeats: true)
    }
    
    override func onExit() {
        super.onExit()
        timer?.invalidate()
        
        if let currLevel = self.currentLevel, rTurns = self.remainingTurns {
            Answers.logLevelEnd(currLevel.getLevelName(),
                score: rTurns,
                success: true,
                customAttributes: [:])
        }
    }
    
    // MARK: Public Methods
    func loadLevel(targetLevel: Level) {
        Answers.logLevelStart(targetLevel.getLevelName(),
            customAttributes: [:])
        
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
        // Allow this game being playing
        self.isPlayable = true
        
        // Resume the background sound
        SoundManager.sharedInstace.resumeBGAndStopEffect()
    }
    
    // MARK: Game loop update
    func updateGUI(delta: CCTimer) {
        if self.isPlayable {
            // Decrease the remaining time
            self.updateRemainingTimer()
        }
    }
    
    // MARK: Gameplay
    func nextAttemp() {
        bulletBackToInitialPosition()
    }
    
    internal func gameOver() {
        // Prevent this game from playing
        self.isPlayable = false
        // Stop the bullet moving
        bullet?.stopMovement()
        // Show Game Over message form
        self.showGameOverMessageForm()
        SoundManager.sharedInstace.playEffectTrack(SoundTrack.GameOver, loop: false)
        
        logAnswerEvent("Game Over")
    }
    
    internal func wonLevel() {
        // Prevent this game from playing
        self.isPlayable = false
        // Stop the bullet moving
        bullet?.stopMovement()
        self.showWinMessageForm()
        SoundManager.sharedInstace.playEffectTrack(SoundTrack.Won, loop: false)
        
        logAnswerEvent("Won Level")
    }
    
    internal func nextLevel() {
        guard let currLevel = self.currentLevel else { return }
        // Move to next level
        let nextLevelNumber = currLevel.rawValue + 1
        if let nextLevel = Level(levelNumber: nextLevelNumber) {
            self.loadLevel(nextLevel)
        }
        // Hide MessageForm
        if let messNode = self.messageNode {
            messNode.hideMessageForm()
        }
        
        logAnswerEvent("Next Level")
    }
    
    // MARK: Collision Handle
    // Bullet collides with Target
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, Bullet aBullet: Bullet!, Target aTarget: Target!) {
        guard let gPhysicsNode = self.gamePhysicsNode else { return }
        let energy = pair.totalKineticEnergy
        // Ignore all collision whose energy is below 0
        if energy > 5000 {
            // Add Post Step block to run code only once
            gPhysicsNode.space.addPostStepBlock({ [weak self] () -> Void in
                if let aTargetNode = self?.targetNode {
                  aTargetNode.showBlowupEffect(SoundTrack.Boom, removeFromParent: true, completionAction: { [weak self] () -> () in
                        self?.wonLevel()
                        })
                }
                
                self?.bulletBackToInitialPosition(true)
                
                }, key: aTarget)
        }
        
        
    }
    // Bullet collides with Wall
    func ccPhysicsCollisionPostSolve(pair: CCPhysicsCollisionPair!, Bullet aBullet: Bullet!, Wall aWall: Wall!) {
        guard let gPhysicsNode = self.gamePhysicsNode else { return }
        let energy = pair.totalKineticEnergy
        // Ignore all collision whose energy is below 0

        if energy > 5000 {
            // Add Post Step block to run code only once
            gPhysicsNode.space.addPostStepBlock({ () -> Void in
                // Play Bounce sound
                SoundManager.sharedInstace.playEffectTrack(SoundTrack.Bounce)
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
        
        // Hide Message Form if existed
        self.messageNode?.hideMessageForm()
        
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
        // Get Bullet
        if let gameLevelNode = gameLevelNode {
            bullet = gameLevelNode.getChildByName("Bullet", recursively: true) as? Bullet
        }
        // Get Target Node
        if let targetNodes = NodeHelper.findChildrenOfClass(TargetNode.self, forNode: levelNode) as? [TargetNode] where targetNodes.count > 0 {
            self.targetNode = targetNodes.first
        }
        // Setup the bullet node
        self.setupBulletNode()

    }
    
    private func setupBulletNode() {
        guard let bulletNode = self.bullet else { return }
        // Save the intial position of this bullet for later
        self.initialBulletPosition = bulletNode.position
        // Setup action after every time the bullet is swiped
        bulletNode.actionAfterSwipe = { [weak self] in
            // Update the remaining turn, every time you swiped, decrease the remaining turns by 1
            // Track the movement of the bullet, as soon as the bullet stops moving, then updates the remaining turns
            
            self?.updateRemainingTurn()
            if let strongSelf = self where strongSelf.isPlayable {
                strongSelf.nextAttemp()
            }


        }
    }
    
    private func addFirstChildForLevelNode(node: CCNode) {
        guard let gameLevelNode = gameLevelNode else { return }
        // Remove existed level node if had
        if let existedNode = gameLevelNode.getChildByName("gameLevelNode", recursively: true) {
            gameLevelNode.removeChild(existedNode)
        }
        gameLevelNode.addChild(node, z: 0, name: "gameLevelNode")
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
        messageForm.applyStyle(MessageStyle.GameOver) { [weak self] _ in
            self?.showMainScene()
        }
    }
    
    private func showWinMessageForm() {
        guard let messageForm = self.messageNode, currLevel = self.currentLevel else { return }

        let messageStyle = MessageStyle(level: currLevel)
        // Set those above attributes to message form and display
        messageForm.applyStyle(messageStyle) { [weak self] (style: MessageStyle?) -> () in
            if let myStyle = style {
                switch myStyle {
                case .NextLevel:
                    self?.nextLevel()
                case .GameOver, .Won:
                    self?.showMainScene()
                }

            }
        }
    }
    
    private func showMainScene() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        let transition = CCTransition(crossFadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(mainScene, withTransition: transition)
    }
    
    // MARK: Helpers
    private func logAnswerEvent(eventName: String) {
        if let rTurns = remainingTurns, rTime = self.remainingTime {
            Answers.logCustomEventWithName(eventName, customAttributes: ["Time": rTime, "Turns" : rTurns])
        } else {
            Answers.logCustomEventWithName(eventName, customAttributes: ["Time": -1, "Turns" : -1])
        }
    }
    
    
    private func bulletBackToInitialPosition(removeFromParent: Bool = false) {
        guard let bullet = bullet, initialBulletPosition = initialBulletPosition else { return }
        
        // Stop this bullet from moving
        bullet.stopMovement()
        
        bullet.visible = false
        // Display Disappear Particle
        bullet.showDisappearEffect(removeFromParent: removeFromParent) { [weak self] () -> () in
            // Reset Bullet
            bullet.reset()
            // Return the bullet to the initial position
            bullet.position = initialBulletPosition
            
            bullet.visible = true
            
            self?.logAnswerEvent("Next Attemp")
        }

    }
}
