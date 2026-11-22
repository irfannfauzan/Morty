//
//  MoyaCharacterRepository.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import Moya

final class MoyaCharacterRepository: CharacterRepositoryProtocol {

    private let provider: MoyaProvider<RickMortyAPI>
    private let decoder: JSONDecoder

    init(
        provider: MoyaProvider<RickMortyAPI> = MoyaProvider<RickMortyAPI>(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.provider = provider
        self.decoder = decoder
    }

    func fetchCharacter(page: Int) async throws -> [Character] {
        let response = try await request(.fetchCharacter(page: page))

        do {
            let decoded = try decoder.decode(CharacterListResponse.self, from: response.data)
            return decoded.results.map { $0.toDomain() }
        } catch {
            throw APIError.decoding(error)
        }
    }

    // MARK: - Helpers

    private func request(_ target: RickMortyAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    if (200...299).contains(response.statusCode) {
                        continuation.resume(returning: response)
                    } else {
                        continuation.resume(throwing: APIError.httpStatus(response.statusCode, message: nil))
                    }

                case .failure(let error):
                    if let urlError = error.errorUserInfo[NSUnderlyingErrorKey] as? URLError {
                        continuation.resume(throwing: APIError.transport(urlError))
                    } else {
                        continuation.resume(throwing: APIError.invalidResponse)
                    }
                }
            }
        }
    }
}
