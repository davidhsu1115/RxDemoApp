//
//  NetworkServices.swift
//  RxDemoApp
//
//  Created by hsu David on 2020/5/30.
//  Copyright © 2020 hsu David. All rights reserved.
//

import Foundation
import Moya

let apiKey = "Lf_QT_eOwxCSiwrTHZoQA_XXXTn1xWaUWdHV9mB31URfAPQnS9YBFFsw_U91_nvT8Mz7ZGiAwBSKWonWd8fPbUTj8ijVboh1ul_2a4cA-pgOMssdZREFbvdcuRrSXnYx"

enum YelpServices {
    
    enum BusinessProvider: TargetType {
        
        case search(lat: Double, lng: Double)
        case phoneSearch(phone: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String{
            switch self {
            case .search:
                return "/search"
            case .phoneSearch:
                return "/phone"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .search:
                return .get
            case .phoneSearch:
                return .get
            }
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case .search(let lat, let lng):
                return .requestParameters(parameters: ["latitude": lat, "longitude": lng, "limit": 1], encoding: URLEncoding.queryString)
            case .phoneSearch(let phone):
                return .requestParameters(parameters: ["phone": phone], encoding: URLEncoding.queryString)
            }
            
        }
        
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
        
        
        
        
    }
    
    
}
