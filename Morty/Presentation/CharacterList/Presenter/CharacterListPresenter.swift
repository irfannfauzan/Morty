//
//  CharacterListPresenter.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

protocol CharacterListPresenterProtocol: AnyObject {
    var numberOfCharacters: Int { get }
    func character(at index: Int) -> Character
    func viewDidLoad()
    func viewDidRetry()
    func didSelectCharacter(at index: Int)
}

final class CharacterListPresenter: CharacterListPresenterProtocol {
    weak var view: CharacterListViewProtocol?
    private let interactor: CharacterListInteractorProtocol
    private let router: CharacterListRouterProtocol
    private var characters: [Character] = []
    
    init(interactor: CharacterListInteractorProtocol, router: CharacterListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    var numberOfCharacters: Int {
        characters.count
    }
    
    func character(at index: Int) -> Character {
        characters[index]
    }
    
    func viewDidLoad() {
        loadCharacters()
    }
    
    func viewDidRetry() {
        loadCharacters()
    }
    
    func didSelectCharacter(at index: Int) {
        guard characters.indices.contains(index) else { return }
        router.navigateToDetail(character: characters[index])
    }
    
    private func loadCharacters() {
        view?.showLoading()
        interactor.fetchCharacters(page: 1)
    }
}

extension CharacterListPresenter: CharacterListInteractorOutputProtocol {
    
    func didFetchCharacters(_ characters: [Character]) {
        self.characters = characters
        if characters.isEmpty {
            view?.showEmpty(message: "No characters found.")
        } else {
            view?.showCharacters()
        }
    }
    
    func didFailFetchCharacters(_ message: String) {
        view?.showError(message: message)
    }
        
}
