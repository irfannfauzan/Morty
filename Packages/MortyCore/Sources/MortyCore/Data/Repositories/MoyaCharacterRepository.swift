//
//  MoyaCharacterRepository.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import Foundation
import Moya

final class MoyaCharacterRepository: CharacterRepositoryProtocol {
    
    private let client: MoyaApiClient<MoyaEndpoint>

    init(client: MoyaApiClient<MoyaEndpoint> = MoyaApiClient()) {
        self.client = client
    }

    func fetchCharacter(page: Int) async throws -> [Character] {
        let response : CharacterListResponse = try await client.request(.fetchCharacter(page: page))
        return response.results.map { $0.toDomain() }
    }
}
