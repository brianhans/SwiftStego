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
    Encoder(dataToHide: "Test").encode(image: #imageLiteral(resourceName: "ExampleImage"), data: "Test") { (result) in
      switch result {
      case .success(let image):
        print(Decoder().decode(image: image))
      case .failure:
        break
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

