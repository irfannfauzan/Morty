//
//  FetchCharacterUseCase.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

protocol FetchCharacterUseCaseProtocol {
    func execute(page: Int) async throws -> [Character]
}

final class FetchCharacterUseCase: FetchCharacterUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol
    
    init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int) async throws -> [Character] {
        try await repository.fetchCharacter(page: page)
    }
}
