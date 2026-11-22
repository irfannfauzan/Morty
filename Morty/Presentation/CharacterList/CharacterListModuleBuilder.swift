//
//  CharacterListModuleBuilder.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit

enum CharacterListModuleBuilder {
    static func build() -> UIViewController {
//        let apiClient = APIClient()
//        let alamofireApiClient = AlamofireAPIClient()
//        let repository = CharacterRepository(apiClient: alamofireApiClient)
        let client = MoyaApiClient<MoyaEndpoint>()
        let moyaCharacterRepository = MoyaCharacterRepository(client: client)
        let useCase = FetchCharacterUseCase(repository: moyaCharacterRepository)
        let favoriteRepository = FavoriteRepository()

        let interactor = CharacterListInteractor(
            fetchCharacterUseCase: useCase,
            favoriteRepository: favoriteRepository
        )
        
        let router = CharacterListRouter()
        let presenter = CharacterListPresenter(interactor: interactor, router: router)
        let view = CharacterListViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
