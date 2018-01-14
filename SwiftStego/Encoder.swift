//
//  Encoder.swift
//  SwiftStego
//
//  Created by Brian Hans on 1/13/18.
//  Copyright © 2018 BrianHans. All rights reserved.
//

import UIKit
import CoreGraphics

class Encoder {
  private var currentShift: Int = Defaults.initalShift
  private var currentCharacter: Int = 0
  private var step: UInt32 = 0
  private var dataToHide: String
  
  init(dataToHide: String) {
    self.dataToHide = dataToHide
  }
  
  func encode(image: UIImage, data: String, completion: (Result<UIImage>) -> Void) {
    guard let cgImage = image.cgImage else { return }
    let width = cgImage.width
    let height = cgImage.height
    let size = width * height
    
    let pixels = calloc(size, MemoryLayout<UInt32>.size)
    
    var processedImage: UIImage?
    
    if size >= Defaults.minPixels {
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let bitmapInfo: CGBitmapInfo = [CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue), CGBitmapInfo.byteOrder32Big]
      
      
      guard let context = CGContext(data: pixels, width: width, height: height, bitsPerComponent: Defaults.bitsPerComponent, bytesPerRow: Defaults.bytesPerPixel * width, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return }
      
      context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

      guard let pixelPointer = pixels else { return completion(.failure(NSError())) }
      
      let pixelArray = Array(UnsafeBufferPointer(start: pixelPointer.assumingMemoryBound(to: UInt32.self), count: size))
      let error = self.hideData(data: data, in: pixelArray, pointer: pixelPointer)
      
      if error == nil, let newImage = context.makeImage(){
        processedImage = UIImage(cgImage: newImage)
      } else {
        
      }
      
      context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
      
      
    } else {
      
    }
    
    
    if let processedImage = processedImage {
      completion(Result.success(processedImage))
    } else {
      completion(Result.failure(NSError()))
    }
  }
  
  private func hideData(data: String, in pixels: [UInt32], pointer: UnsafeMutableRawPointer) -> Error? {
    var success = false
    guard let message = messageToHide(string: data) else { return NSError() } // TODO: return better error
    var length = message.count
    
    if length <= INT_MAX && (length * Defaults.bitsPerComponent) < (pixels.count - Defaults.sizeOfInfoLength) {
      reset()
      
      let data = NSData(bytes: &length, length: Defaults.bytesOfLength)
      let lengthDataInfo = String(data: data as Data, encoding: .ascii) ?? ""
      
      var pixelPosition: Int = 0
      
      self.dataToHide = lengthDataInfo
      
      var newPixels = pixels
      
      while pixelPosition < Defaults.sizeOfInfoLength {
        newPixels[pixelPosition] = self.newPixel(pixel: newPixels[pixelPosition])
        pixelPosition += 1
      }
      
      reset()
      
      let pixelsToHide = message.count * Defaults.bitsPerComponent
      
      self.dataToHide = message
      
      let ratio = (pixels.count - pixelPosition) / pixelsToHide
      
      let salt = ratio
      
      while pixelPosition <= pixels.count {
        newPixels[pixelPosition] = self.newPixel(pixel: self.newPixel(pixel: newPixels[pixelPosition]))
        pixelPosition += salt
      }
      
      
      pointer.copyBytes(from: &newPixels, count: newPixels.count)
      success = true
    } else {
      
    }
    return nil
  }
  
  private func newPixel(pixel: UInt32) -> UInt32 {
    let color = self.newColor(color: pixel)
    self.step += 1
    return color
  }
  
  private func newColor(color: UInt32) -> UInt32 {
    if let index = self.dataToHide.index(dataToHide.startIndex, offsetBy: currentCharacter, limitedBy: dataToHide.index(before: dataToHide.endIndex)) {
      let asciiCode = UInt32(String(self.dataToHide[index])) ?? 0
      let shiftedBits = asciiCode >> self.currentShift
      
      if currentShift == 0 {
        currentShift = Defaults.initalShift
        currentCharacter += 1
      } else {
        currentShift -= 1
      }
      
      return Utilities.NewPixel(pixel: color, shiftedBits: shiftedBits, shift: Utilities.ColorToStep(step: self.step).rawValue)
    }
    
    return color
  }
  
  private func reset() {
    self.currentShift = Defaults.initalShift
    self.currentCharacter = 0
  }
  
  private func messageToHide(string: String) -> String? {
    let data = string.data(using: .utf8)
    guard let base64String = data?.base64EncodedString() else { return nil }
    return "\(Defaults.dataPrefix)\(base64String)\(Defaults.dataSuffix)"
  }
}
