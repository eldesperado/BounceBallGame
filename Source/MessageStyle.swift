//
//  MessageStyle.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/24/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

enum MessageStyle {
    case GameOver
    case NextLevel
    case Won
    
    var messageText: String? {
        switch self {
        case .GameOver:
            return "Game Over"
        case .NextLevel:
            return "You won this level!"
        case .Won:
            return "Congratulation! You won!"
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .GameOver, .Won:
            return "Menu"
        case .NextLevel:
            return "Next Level"
        }
    }
}

extension MessageStyle {
    init(level: Level) {
        if level.rawValue < Level.maxLevel {
            self = .NextLevel
        } else {
            self = .Won
        }
    }
}