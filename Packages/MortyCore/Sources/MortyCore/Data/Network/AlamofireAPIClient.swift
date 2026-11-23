//
//  AlamofireAPIClient.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import Alamofire
import MortyCore

final class AlamofireAPIClient: APIClientProtocol {

    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        let response = await session.request(url)
            .validate()
            .serializingData()                   
            .response

        switch response.result {
        case .success(let data):
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
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
        return .invalidResponse
    }
}
