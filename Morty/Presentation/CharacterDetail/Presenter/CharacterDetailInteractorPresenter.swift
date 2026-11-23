//
//  CharacterDetailInteractorPresenter.swift
//  Morty
//
//  Created by Vokal-Ican on 23/11/26.
//

import MortyCore

protocol CharacterDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class CharacterDetailPresenter: CharacterDetailPresenterProtocol {
    weak var view: CharacterDetailViewProtocol?
    private let interactor: CharacterDetailInteractorProtocol
    private let router: CharacterDetailRouterProtocol
    private let character: Character
    
    init(interactor: CharacterDetailInteractorProtocol,
         router: CharacterDetailRouterProtocol,
         character: Character) {
        self.interactor = interactor
        self.router = router
        self.character = character
    }
    
    func viewDidLoad() {
        view?.showCharacter(character)
    }
}
