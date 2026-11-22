//
//  MoyaEndpoint.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import Moya
import Alamofire

enum MoyaEndpoint {
    case fetchCharacter(page: Int)
}

extension MoyaEndpoint : nonisolated TargetType {
    var baseURL: URL {
        URL(string: "https://rickandmortyapi.com/api")!
    }
    
    var path: String {
        switch self {
        case .fetchCharacter:
            return "/character"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCharacter:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchCharacter(let page):
            return .requestParameters(
                parameters: ["page" : page],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        ["Accepts": "application/json"]
    }
}
