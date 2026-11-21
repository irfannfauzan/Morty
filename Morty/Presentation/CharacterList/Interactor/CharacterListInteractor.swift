//
//  CharacterListInteractor.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

protocol CharacterListInteractorProtocol: AnyObject {
    func fetchCharacters(page: Int)
}

protocol CharacterListInteractorOutputProtocol: AnyObject {
    func didFetchCharacters(_ characters: [Character])
    func didFailFetchCharacters(_ message: String)
}

final class CharacterListInteractor: CharacterListInteractorProtocol {
    weak var presenter: CharacterListInteractorOutputProtocol?
    
    private let fetchCharactersUseCase: FetchCharacterUseCaseProtocol
    
    init(fetchCharactersUseCase: FetchCharacterUseCaseProtocol) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
    }
    
    func fetchCharacters(page: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await fetchCharactersUseCase.execute(page: page)
                await MainActor.run {
                    self.presenter?.didFetchCharacters(result)
                }
            } catch {
                presenter?.didFailFetchCharacters(error.localizedDescription)
            }
        }
    }
}
