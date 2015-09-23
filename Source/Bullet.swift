//
//  Bullet.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Bullet: CCSprite {
    var actionAfterSwipe: (()->())?
    
    // MARK: Private Attributes
    private let arrow = CCBReader.load("Objects/Arrow") as? CCSprite
    private let tail = CCBReader.load("Effects/Tail") as? CCParticleSystem
    private var isTouched = false {
        didSet {
            self.userInteractionEnabled = !self.isTouched
        }
    }
    private var touchLocation: CGPoint?
    private var touchTime: CFTimeInterval = 0
    private var flyTime: CFTimeInterval = 0
    private let minVelocity = CGPointMake(20, 20)
    private let maxVelocity = CGPointMake(80, 80)
    private let forceConstant: CGFloat = 200
    private let minFliedTime: Double = 1
    private let maxFliedTime: Double = 3.5
    private var movementAngle: Float = 0
    private var previousPostion: CGPoint?
    
    func didLoadFromCCB() {
        self.userInteractionEnabled = true
        self.physicsBody.collisionType = CollisionType.Bullet.rawValue
        self.physicsBody.collisionGroup = CollisionType.Bullet.getCollisionGroup()
        
    }
    
    override func onEnter() {
        super.onEnter()
        // Setup Arrow
        self.setupArrow()
        // Setup Tail
        self.setupTail()
        // Update Movement Angle
        self.schedule("updateMovementAngle", interval: 1 / 60)
    }
    
    override func update(delta: CCTime) {
        // Track the movement of the bullet node
        self.updatePreviousPosition()
        // If this bullet has just been touched and it's slowing down, then whenever its velocity
        // reaches 50, then do action
        self.actionWhenBulletSlowingDown()
        
        if self.isTouched {
            self.updateTailPosition()
        }
    }
    
    // MARK: Public Methods
    func stopMovement() {
        self.physicsBody.velocity = CGPointZero
        self.physicsBody.angularVelocity = 0
    }
    
    func reset() {
        self.rotation = 0
        if let myTail = self.tail {
            myTail.rotation = 0
        }
    }
    
    
    func showDisappearEffect() {
        let particle = self.createDisappearParticle()
        self.addChild(particle)
    }
    
    // MARK: Overriden Touches
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let location = self.getTouchLocationInParentNode(touch)
        self.touchLocation = location
        self.touchTime = CACurrentMediaTime()

        // Update isTouched
        self.isTouched = false
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        guard let intialTouchLocation = self.touchLocation, myArrow = self.arrow else { return }
        if let location = self.getTouchLocationInParentNode(touch) {
            let swipe = ccp(location.x - intialTouchLocation.x, location.y - intialTouchLocation.y)
            let reversedSwipe = -swipe
            // Scale the arrow depended on how hard the swipe is
            let maximumProportion = self.getMaximumProportion(swipe, self.maxVelocity)
            myArrow.scaleY = maximumProportion
            self.showArrow(reversedSwipe, position: self.position)
        }
        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        guard let intialTouchLocation = self.touchLocation, bulletPhysicsBody = self.physicsBody else { return }
        
        if let location = self.getTouchLocationInParentNode(touch) {
            let TouchTimeThreshold: CFTimeInterval = 0.1
            let TouchDistanceThreshold: CGFloat = 0.1

            if CACurrentMediaTime() - touchTime > TouchTimeThreshold {
                let swipe = ccp(location.x - intialTouchLocation.x, location.y - intialTouchLocation.y)
                let swipeLength = sqrt(swipe.x * swipe.x + swipe.y * swipe.y)
                
                if swipeLength > TouchDistanceThreshold {

                    // Create the force
                    let reversedSwipe = -swipe
                    let force = ccpMult(reversedSwipe, self.forceConstant)
                    // Apply the force created by the swipe
                    bulletPhysicsBody.applyForce(force)

                    // Save Fly time
                    self.flyTime = CACurrentMediaTime()
                    
                    #if DEBUG
                        print("Apply Force |-> Bullet: \(force)")
                    #endif

                    self.isTouched = true
                }
            }
            // Hide arrow
            if let myArrow = self.arrow {
                myArrow.visible = false
            }
        }
        
    }
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        self.touchEnded(touch, withEvent: event)
    }
    
    // MARK: Private Methods
    
    private func setupArrow() {
        guard let myArrow = self.arrow, parentNode = self.parent else { return }
        myArrow.visible = false
        let bulletPostion = self.getBulletPositionInNodeSpace()
        myArrow.position = bulletPostion
        myArrow.anchorPoint = CGPointMake(0.5, 0)
        parentNode.addChild(myArrow)
    }
    
    private func setupTail() {
        guard let myTail = self.tail else { return }
        myTail.visible = false
        let frame = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2)
        myTail.rotation = self.rotation
        myTail.position = frame
        self.addChild(myTail)
    }
    
    private func getTouchLocationInParentNode(touch: CCTouch) -> CGPoint? {
        guard let parentNode = self.parent else { return nil }
        let location = touch.locationInNode(parentNode)
        return location
    }
    
    private func showArrow(diffPoint: CGPoint, position: CGPoint) {
        guard let myArrow = self.arrow else { return }
        let angle = atan2f(Float(diffPoint.x), Float(diffPoint.y))
        myArrow.rotation = CC_RADIANS_TO_DEGREES(angle)
        #if DEBUG
            print("Rotation Angle of Arrow: \(CC_RADIANS_TO_DEGREES(angle))")
        #endif
        // Update Position
        let bulletPostion = self.getBulletPositionInNodeSpace()
        myArrow.position = bulletPostion
        myArrow.visible = true
    }

    
    private func updateTailPosition() {
        guard let myTail = self.tail else { return }
        // Make the tail visible
        myTail.visible = true
        myTail.angle = self.movementAngle
        #if DEBUG
            
        #endif

    }
    
    private func getBulletPositionInNodeSpace() -> CGPoint {
        let bulletPosition = self.physicsNode().convertToNodeSpace(self.position)
        return bulletPosition
    }
    
    private func getMaximumProportion(pointA: CGPoint, _ pointB: CGPoint) -> Float {
        return max(abs(Float(pointA.x / pointB.x)), abs(Float(pointA.y / pointB.y)))
    }
    
    private func actionWhenBulletSlowingDown() -> () {
        let fliedTime = CACurrentMediaTime() - self.flyTime
        
        // The Bullet had to flied at least the minimum fly time to be able to do Action
        if self.isTouched == true && fliedTime >= self.minFliedTime && self.flyTime != 0 {
            // If the bullet flied too long, exceeded the maximum fly time, then do Action now, after that, return
            if fliedTime >= self.maxFliedTime {
                // Do Action, then return
                self.doActionAfterSwipe()
                return
            }
            
            // Determine whether its velocity is slowing down
            let isSlowDown = self.physicsBody.velocity ~<= self.minVelocity
            
            #if DEBUG
                print("Velocity of Bullet: \(self.physicsBody.velocity) at \(fliedTime) - isSlowDown: \(isSlowDown)")
            #endif

            if isSlowDown  {
                // Do Action
                self.doActionAfterSwipe()
                return
            }

        }
    }
    
    private func doActionAfterSwipe() {
        guard let action = self.actionAfterSwipe else { return }
        action()
        // Hide the Tail
        if let myTail = self.tail {
            myTail.visible = false
        }
        self.isTouched = false
    }
    
    internal func updateMovementAngle() {
        if let prevPost = self.previousPostion {
            self.movementAngle = NodeHelper.calculateAngleBetweenTwoPoints(self.position, pointB: prevPost)
            previousPostion = self.position

        } else {
            self.previousPostion = self.position
        }
    }
}
