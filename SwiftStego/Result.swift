//
//  Result.swift
//  SwiftStego
//
//  Created by Brian Hans on 1/13/18.
//  Copyright © 2018 BrianHans. All rights reserved.
//

import Foundation

enum Result<T> {
  case success(T)
  case failure(Error)
}
