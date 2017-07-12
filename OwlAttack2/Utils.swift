//
//  Utils.swift
//  OwlAttack2
//
//  Created by Jason La on 12/13/16.
//  Copyright © 2016 Jason La. All rights reserved.
//

import UIKit
import Foundation

func RandomInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

func RandomFloat() -> Float {
    return Float(arc4random()) /  Float(UInt32.max)
}

func RandomFloat(min: Float, max: Float) -> Float {
    return (Float(arc4random()) / Float(UInt32.max)) * (max - min) + min
}

func RandomDouble(min: Double, max: Double) -> Double {
    return (Double(arc4random()) / Double(UInt32.max)) * (max - min) + min
}

func RandomCGFloat() -> CGFloat {
    return CGFloat(RandomFloat())
}

func RandomCGFloat(min: Float, max: Float) -> CGFloat {
    return CGFloat(RandomFloat(min: min, max: max))
}

func RandomColor() -> UIColor {
    return UIColor(red: RandomCGFloat(), green: RandomCGFloat(), blue: RandomCGFloat(), alpha: 1)
}
