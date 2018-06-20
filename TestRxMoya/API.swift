//
//  API.swift
//  TestRxMoya
//
//  Created by David on 2018/6/19.
//  Copyright © 2018年 David. All rights reserved.
//

import Moya
import RxSwift

extension String {
  var urlEscaped: String {
    return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

final public class API {
  public static let shared = API()
  private init() {}
  private let provider = MoyaProvider<MultiTarget>()

  func request<Request: DecodableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
    let target = MultiTarget.init(request)
    return provider.rx.request(target)
      .filterSuccessfulStatusCodes()
      .map(Request.ResponseType.self)
  }
}

// 定義一個 protocol 需要預先指定 response 的 type
protocol DecodableResponseTargetType: TargetType {
  associatedtype ResponseType: Decodable
}

// 建立一個給 github api 專用的 protocol
// 且 api 的 response 皆要可以被 decode
protocol GitHubApiTargetType: DecodableResponseTargetType {}

// 設定一些預設值
extension GitHubApiTargetType {
  var baseURL: URL { return URL(string: "https://api.github.com")! }
  var headers: [String : String]? { return nil }
  var sampleData: Data {
    let path = Bundle.main.path(forResource: "samples", ofType: "json")!
    return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
  }
}

// 以往是 GitHub conform TargetType 讓 Moya 可以抓取 TargetType 的資料來打 api
// 而切換資訊的方式就是經由 switch case
// 但現在我們把每個 TargetType 分開用 struct 定義
// 可以更清楚的看見每個 api endpoint 到底做了什麼事
enum GitHub {
  // 先 conform GitHubApiTargetType 取得最基本的資訊
  // 並且針對這個 endpoint 在定義更詳細的資訊
  // 如果 default 資訊不是你想要的，使用 overload 把它蓋掉
  struct GetUserProfile: GitHubApiTargetType {
    typealias ResponseType = Profile

    var method: Moya.Method { return .get }
    var path: String { return "/userss/\(name.urlEscaped)" }
    var task: Task { return .requestPlain }

    // stored properties
    private let name: String

    init(name: String) {
      self.name = name
    }
  }
}
