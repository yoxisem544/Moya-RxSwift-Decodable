//
//  ViewController.swift
//  TestRxMoya
//
//  Created by David on 2018/6/19.
//  Copyright © 2018年 David. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ViewController: UIViewController {

  let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    API.shared.request(GitHub.GetUserProfile(name: "yoxisem544"))
      .subscribe(onSuccess: { (p) in
        log.verbose(p)
        log.debug(p)
        log.info(p)
        log.warning(p)
        log.error(p)
      }, onError: { (e) in
        if case let MoyaError.jsonMapping(r) = e {
          log.error(r)
        }
        if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
          log.warning(errorMessage)
        }
      })
      .disposed(by: bag)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

