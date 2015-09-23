//
//  NodeHelper.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/19/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

struct NodeHelper {
    static func findChildrenOfClass<T>(classType: T.Type, forNode: CCNode) -> NSArray {
        let nodes = NSMutableArray()
        self.addChildren(classType, storedArray: nodes, node: forNode)
        return nodes
    }
    
    static func addChildren<T>(classType: T.Type, storedArray: NSMutableArray, node: CCNode) {
        if node.children != nil {
            for child in node.children {
                guard let childNode = child as? CCNode else { continue }
                
                if child is T {
                    storedArray.addObject(child)
                }
                self.addChildren(classType, storedArray: storedArray, node: childNode)
            }
        }

    }
    
    static func calculateAngleBetweenTwoPoints(pointA: CGPoint, pointB: CGPoint, inDegree: Bool = true) -> Float {
        let deltaX: CGFloat = pointB.x - pointA.x
        let deltaY: CGFloat = pointB.y - pointA.y
        let angle = atan2f(Float(deltaY), Float(deltaX))

        if inDegree {
            return CC_RADIANS_TO_DEGREES(angle)
        }
        return angle
    }
}
