//
//  CharacterListPresenter.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation
import MortyCore

protocol CharacterListPresenterProtocol: AnyObject {
    var numberOfCharacters: Int { get }
    func character(at index: Int) -> Character
    func isFavorite(at index: Int) -> Bool
    func viewDidLoad()
    func didTapRetry()
    func didSelectCharacter(at index: Int)
    func didTapFavorite(at index: Int)
}

final class CharacterListPresenter: CharacterListPresenterProtocol {

    // MARK: - Properties

    weak var view: CharacterListViewProtocol?
    private let interactor: CharacterListInteractorProtocol
    private let router: CharacterListRouterProtocol
    private var characters: [Character] = []

    // MARK: - Init

    init(interactor: CharacterListInteractorProtocol, router: CharacterListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - Data

    var numberOfCharacters: Int {
        characters.count
    }

    func character(at index: Int) -> Character {
        characters[index]
    }

    func isFavorite(at index: Int) -> Bool {
        interactor.isFavorite(id: characters[index].id)
    }

    // MARK: - Actions

    func viewDidLoad() {
        loadCharacters()
    }

    func didTapRetry() {
        loadCharacters()
    }

    func didSelectCharacter(at index: Int) {
        guard characters.indices.contains(index) else { return }
        router.navigateToDetail(character: characters[index])
    }

    func didTapFavorite(at index: Int) {
        guard characters.indices.contains(index) else { return }
        _ = interactor.toggleFavorite(characters[index])
        view?.reloadCharacter(at: index)
    }

    // MARK: - Private

    private func loadCharacters() {
        view?.showLoading()
        interactor.fetchCharacters(page: 1)
    }
}

// MARK: - CharacterListInteractorOutputProtocol

extension CharacterListPresenter: CharacterListInteractorOutputProtocol {

    func didFetchCharacters(_ characters: [Character]) {
        self.characters = characters
        if characters.isEmpty {
            view?.showEmpty(message: "No characters found.")
        } else {
            view?.showCharacters()
        }
    }

    func didFailFetchingCharacters(_ message: String) {
        view?.showError(message: message)
    }
}
