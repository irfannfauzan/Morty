//
//  CharacterListModuleBuilder.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit

enum CharacterListModuleBuilder {
    static func build() -> UIViewController {
        let apiClient = APIClient()
        let repository = CharacterRepository(apiClient: apiClient)
        let useCase = FetchCharacterUseCase(repository: repository)
        
        let router = CharacterListRouter()
        let interactor = CharacterListInteractor(fetchCharactersUseCase: useCase)
        let presenter = CharacterListPresenter(interactor: interactor, router: router)
        let view = CharacterListViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
