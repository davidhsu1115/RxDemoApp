//
//  OptimalNetworkServices.swift
//  RxDemoApp
//
//  Created by hsu David on 2020/5/30.
//  Copyright © 2020 hsu David. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift
import Moya_ObjectMapper

struct YelpModel: Mappable {
    
    var total: Int?
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        total <- map["total"]
    }
    
}

protocol MappableResponseTargetType: TargetType {
    associatedtype ResponseType: Mappable
}

protocol YelpServiceTargetType: MappableResponseTargetType {
}

extension YelpServiceTargetType {
    
    var baseURL: URL { return URL(string: "https://api.yelp.com/v3/businesses")! }
    var headers: [String : String]? { return ["Authorization": "Bearer \(apiKey)"] }
    var sampleData: Data {
        return Data()
    }
    
}

enum NewYelpServices: PluginType {

    struct Search: YelpServiceTargetType {
        typealias ResponseType = YelpModel
        
        var path: String {return "/search"}
        
        var method: Moya.Method {return .get}
        
        var task: Task {return .requestParameters(parameters: ["latitude": lat, "longitude": lng, "limit": 1], encoding: URLEncoding.queryString)}
        
        private let lat: Double
        private let lng: Double
        
        init(lat: Double, lng: Double) {
            self.lat = lat
            self.lng = lng
        }
        
    }
    
    struct SearchB: YelpServiceTargetType {
        typealias ResponseType = YelpModel
        
        var path: String {return "/search"}
        
        var method: Moya.Method {return .get}
        
        var task: Task {return .requestParameters(parameters: ["latitude": lat, "longitude": lng, "limit": 1], encoding: URLEncoding.queryString)}
        
        private let lat: Double
        private let lng: Double
        
        init(lat: Double, lng: Double) {
            self.lat = lat
            self.lng = lng
        }
        
    }
    
}


final public class API {
    // Singleton API
    public static let shared = API()
    // 隱藏 init，不能讓別人在外面 init API 這個 class
    private init() {}
    private let provider = MoyaProvider<MultiTarget>()
    
    // 每當我傳入一個 request 時，我都會檢查他的 response 可不可以被 decode，
    // conform DecodableResponseTargetType 的意義在此，
    // 因為我們已經先定好 ResponseType 是什麼了，
    // 儘管 request 不知道確定是什麼型態，但一定可以被 JSONDecoder 解析。
    func request<Request: MappableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
        .filterSuccessfulStatusCodes()
            .mapObject(Request.ResponseType.self)// 在此會解析 Response，具體怎麼解析，交由 data model 的 decodable 去處理。
    }
    
}
