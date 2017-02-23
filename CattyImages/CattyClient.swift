//
//  CattyClient.swift
//  CattyImages
//
//  Created by Woramet Muangsiri on 2/22/17.
//  Copyright © 2017 WM. All rights reserved.
//

import Foundation
import Moya
import RxSwift

// MARK: - Constant

private let gettyBaseURL = "https://api.gettyimages.com"
private let apikey = "pphyxfcmuyw3ug7zyc28scx6" //TODO: move it.

// MARK: - Provider
let endpointAuthClosure = { (target: Getty) -> Endpoint<Getty> in
    let defaultEndpoint = RxMoyaProvider.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(newHTTPHeaderFields: ["Api-Key": apikey])
}

let GettyProvider = RxMoyaProvider<Getty>(endpointClosure: endpointAuthClosure)

public enum Getty {
    case images(phrase: String)
    case similar(assetId: String)
}

extension Getty: TargetType {
    public var baseURL: URL { return URL(string: gettyBaseURL)! }
    public var path: String {
        switch self {
        case .images:
            return "/v3/search/images"
        case .similar(let assetId):
            return "/v3/images/\(assetId)/similar"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .images(let phrase):
            return ["phrase": "cat "+phrase, "page_size": 100]
        case .similar:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
   
    public var sampleData: Data {
        switch self {
        case .images:
            guard let path = Bundle.main.path(forResource: "sample", ofType: "json"),
                let data = Data(base64Encoded: path) else {
                    return Data()
            }
            return data
        case .similar:
            guard let path = Bundle.main.path(forResource: "similar", ofType: "json"),
                let data = Data(base64Encoded: path) else {
                    return Data()
            }
            return data
        }
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
