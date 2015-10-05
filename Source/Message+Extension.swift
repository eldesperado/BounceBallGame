//
//  Message+Extension.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/24/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

extension Message {

    func applyStyle(style: MessageStyle, visible: Bool? = true, actionClosure: MessageButtonActionClosure? = nil) {
        self.messageLabel?.string = style.messageText
        self.button?.title = style.buttonTitle
        self.buttonActionClosure = actionClosure
        self.style = style
        
        if let isVisible = visible {
            self.visible = isVisible
        }
    }
    
    func showMessageForm() {
        self.visible = true
    }
    
    func hideMessageForm() {
        self.visible = false
    }

}
