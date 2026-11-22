//
//  AlamofireAPIClient.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import Alamofire

final class AlamofireAPIClient: APIClientProtocol {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        let response = await session.request(url)
                  .validate()
                  .serializingDecodable(T.self)
                  .response
        
        switch response.result {
                case .success(let value):
                    return value
                case .failure(let error):
                    throw mapError(error, statusCode: response.response?.statusCode)
                }
    }
    
    private func mapError(_ error: AFError, statusCode: Int?) -> APIError {
           if let urlError = error.underlyingError as? URLError {
               return .transport(urlError)
           }
           if let statusCode, !(200...299).contains(statusCode) {
               return .httpStatus(statusCode, message: nil)
           }
           if case .responseSerializationFailed = error {
               return .decoding(error)
           }
           return .invalidResponse
       }
}
