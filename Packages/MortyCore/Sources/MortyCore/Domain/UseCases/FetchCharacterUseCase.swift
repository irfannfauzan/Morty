//
//  FetchCharacterUseCase.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

public protocol FetchCharacterUseCaseProtocol {
    func execute(page: Int) async throws -> [Character]
}

public final class FetchCharacterUseCase: FetchCharacterUseCaseProtocol {
    private let repository: CharacterRepositoryProtocol

    public init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> [Character] {
        try await repository.fetchCharacter(page: page)
    }
}
