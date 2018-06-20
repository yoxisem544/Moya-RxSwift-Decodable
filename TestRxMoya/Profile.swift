//
//  Profile.swift
//  TestRxMoya
//
//  Created by David on 2018/6/19.
//  Copyright © 2018年 David. All rights reserved.
//

import Foundation

struct Profile: Codable {
  let login: String
  let url: URL
  let name: String?
  let email: String?
}
