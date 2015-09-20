//
//  Message.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/20/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class Message: CCNode {
    weak var button: CCButton?
    weak var messageLabel: CCLabelTTF?
    typealias ButtonActionClosure = () -> ()
    var buttonActionClosure: ButtonActionClosure?
    
    func didLoadFromCCB() {
        
    }
    
    func buttonDidTap() {
        if let actionClosure = self.buttonActionClosure {
            actionClosure()
        }
    }
    
    func showMessageForm(message: String, buttonTitle: String, actionClosure: ButtonActionClosure? = nil) {
        if let label = self.messageLabel {
            label.string = message
        }
        if let btn = self.button {
            btn.title = buttonTitle
        }
        if let _ = self.button, closure = actionClosure {
            self.buttonActionClosure = closure
        }
        self.visible = true
    }
    
    func hideMessageForm() {
        self.visible = false
    }
}
