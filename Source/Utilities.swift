//
//  Utilities.swift
//  SwiftStego
//
//  Created by Brian Hans on 1/13/18.
//  Copyright © 2018 BrianHans. All rights reserved.
//

import Foundation

struct Utilities {
  static func Mask8(_ x: UInt32) -> UInt32{
    return x & 0xFF
  }
  
  static func Color(_ x: UInt32, shift: Int) -> UInt32 {
    return Mask8(x >> (8 * UInt32(shift)))
  }
  
  static func AddBits(number1: UInt32, number2: UInt32, shift: Int) -> UInt32 {
    return (number1 | Mask8(number2) << (8 * UInt32(shift)))
  }
  
  static func NewPixel(pixel: UInt32, shiftedBits: UInt32, shift: Int) -> UInt32 {
    let bit = (shiftedBits & 1) << (8 * UInt32(shift))
    let colorAndNot = (pixel & ~(1 << (8 * UInt32(shift))))
    return colorAndNot | bit
  }
  
  static func ColorToStep(step: UInt32) -> PixelColor {
    if step % 3 == 0 {
      return .blue;
    } else if step % 2 == 0 {
      return .green;
    } else {
      return .red;
    }
  }
}


enum PixelColor: Int {
  case red = 0, green, blue
}
