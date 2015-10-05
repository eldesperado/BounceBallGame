//
//  Message.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/20/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

typealias MessageButtonActionClosure = ((MessageStyle?) -> ())

class Message: CCNode {
    weak var button: CCButton?
    weak var messageLabel: CCLabelTTF?
    var buttonActionClosure: MessageButtonActionClosure?
    internal var style: MessageStyle?
    func didLoadFromCCB() {
        
    }
    
    func buttonDidTap() {
        if let actionClosure = self.buttonActionClosure {
            actionClosure(self.style)
        }
    }    
}
