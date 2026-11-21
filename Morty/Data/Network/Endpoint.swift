//
//  Endpoint.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

enum Endpoint {
    case fetchCharacter(page: Int)
    
    private static let baseURL = "https://rickandmortyapi.com/api"
    
    private var path: String {
        switch self {
        case .fetchCharacter:
            return "/character"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .fetchCharacter(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: Self.baseURL + path)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
    }
}
