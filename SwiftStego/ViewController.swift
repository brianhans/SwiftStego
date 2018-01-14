//
//  ViewController.swift
//  SwiftStego
//
//  Created by Brian Hans on 1/13/18.
//  Copyright © 2018 BrianHans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    if let encodedImage = Encoder().encode(image: #imageLiteral(resourceName: "doge"), data: "find jeans sausage local tide eagle inhale mixed dizzy memory destroy hurry\0") {
      if let data = Decoder().decode(image: encodedImage) {
        print(data)
      } else {
          print("Failed to decode")
      }
    } else {
      print("Failed to encode")
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

