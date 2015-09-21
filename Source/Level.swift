//
//  Level.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

enum Level: Int {
    case Level1Scene = 1
    case Level2Scene = 2
    
}

extension Level {
    init?(levelNumber: Int) {
        self.init(rawValue: levelNumber)
    }
    
    func getLevelName(isSeparatedByWhitespace: Bool = false) -> String {
        switch (self) {
        case .Level1Scene:
            if isSeparatedByWhitespace {
                return "Level 1"
            } else {
                return "Level1"
            }
        case .Level2Scene:
            if isSeparatedByWhitespace {
                return "Level 2"
            } else {
                return "Level2"
            }
        }
    }
    
    func getLevelFilePath() -> String {
        return "Levels/" + self.getLevelName()
    }
    
    static var maxLevel: Int {  // Get max level available
        var max: Int = 0
        while let _ = self.init(rawValue: ++max) {}
        if max >= 1 {
            return --max
        } else {
            return 0
        }
    }
}