//
//  MoyaApiClient.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import MortyCore
import Moya
import Alamofire

final class MoyaApiClient<Target: TargetType> {
    
    private let provider: MoyaProvider<Target>
    private let decoder: JSONDecoder
    
    init(provider: MoyaProvider<Target> = MoyaProvider<Target>(), decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }
    
    func request<T: Decodable>(_ target: Target) async throws -> T {
        let (data, statusCode): (Data, Int) = try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: (response.data, response.statusCode))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }

        guard (200...299).contains(statusCode) else {
            throw APIError.httpStatus(statusCode, message: nil)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
