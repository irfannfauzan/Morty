//
//  MoyaApiClient.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import Moya
import Alamofire

final class MoyaApiClient<Target: TargetType> {
    
    private let provider: MoyaProvider<Target>
    private let decoder: JSONDecoder
    
    init(provider: MoyaProvider<Target> = MoyaProvider<Target>(), decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }
    
    func request<T:Decodable>(_ target: Target) async throws -> T {
        let response: Response = try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        guard (200...299).contains(response.statusCode) else { throw APIError.httpStatus(response.statusCode, message: nil) }
        
        do {
            return try decoder.decode(T.self, from: response.data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
