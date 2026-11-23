//
//  CharacterDetailModuleBuilder.swift
//  Morty
//
//  Created by Vokal-Ican on 23/11/26.
//

import UIKit
import MortyCore

enum CharacterDetailModuleBuilder {
    static func build(character: Character) -> UIViewController {
        let router = CharacterDetailRouter()
        let interactor = CharacterDetailInteractor()
        let presenter = CharacterDetailPresenter(interactor: interactor, router: router, character: character)
        let view  = CharacterDetailViewController(presenter: presenter)
        
        presenter.view = view
        router.viewController = view
        
        return view
    }
}
