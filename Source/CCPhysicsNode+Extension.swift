//
//  CCPhysicsNode+Extension.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/18/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

protocol CCPhysicsNodeProtocol {
    func receivedTouchBegan(touch: CGPoint)
    func receivedTouchMoved(touch: CGPoint)
}

extension CCPhysicsNode: CCPhysicsNodeProtocol {
    func receivedTouchBegan(touch: CGPoint) {
        fatalError("receivedTouchBegan Not implemented")
    }
    func receivedTouchMoved(touch: CGPoint) {
        fatalError("receivedTouchMoved Not implemented")
    }
}
