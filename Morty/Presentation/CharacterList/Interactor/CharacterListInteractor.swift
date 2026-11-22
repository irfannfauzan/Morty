//
//  CharacterListInteractor.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

protocol CharacterListInteractorProtocol: AnyObject {
    func fetchCharacters(page: Int)
    func isFavorite(id: Int) -> Bool
    func toggleFavorite(_ character: Character) -> Bool
}

protocol CharacterListInteractorOutputProtocol: AnyObject {
    func didFetchCharacters(_ characters: [Character])
    func didFailFetchingCharacters(_ message: String)
}

final class CharacterListInteractor: CharacterListInteractorProtocol {

    weak var presenter: CharacterListInteractorOutputProtocol?

    private let fetchCharacterUseCase: FetchCharacterUseCaseProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol

    init(
        fetchCharacterUseCase: FetchCharacterUseCaseProtocol,
        favoriteRepository: FavoriteRepositoryProtocol
    ) {
        self.fetchCharacterUseCase = fetchCharacterUseCase
        self.favoriteRepository = favoriteRepository
    }

    func fetchCharacters(page: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let characters = try await fetchCharacterUseCase.execute(page: page)
                presenter?.didFetchCharacters(characters)
            } catch {
                presenter?.didFailFetchingCharacters(error.localizedDescription)
            }
        }
    }

    func isFavorite(id: Int) -> Bool {
        favoriteRepository.isFavorite(id: id)
    }

    func toggleFavorite(_ character: Character) -> Bool {
        if favoriteRepository.isFavorite(id: character.id) {
            favoriteRepository.removeFavorite(id: character.id)
            return false
        } else {
            favoriteRepository.addFavorite(character)
            return true
        }
    }
}
