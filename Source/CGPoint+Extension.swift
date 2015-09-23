//
//  CGPoint+Extension.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/22/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

prefix func - (point: CGPoint) -> (CGPoint) {
    return CGPointMake(-point.x, -point.y)
}

infix operator ~<= { associativity left precedence 120 }
func ~<=(left: CGPoint, right: CGPoint) -> Bool {
    if ((abs(left.x) <= abs(right.x))
        && (abs(left.y) <= abs(right.y))) {
            return true
    }
    return false
}