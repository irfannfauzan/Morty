//
//  CharacterRepository.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

public final class CharacterRepository: CharacterRepositoryProtocol {
    private let apiClient: APIClientProtocol

    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func fetchCharacter(page: Int) async throws -> [Character] {
        let response: CharacterListResponse = try await apiClient.request(.fetchCharacter(page: page))
        return response.results.map { $0.toDomain() }
    }
}
