//
//  CharacterListRouter.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit
import MortyCore

protocol CharacterListRouterProtocol: AnyObject {
    func navigateToDetail(character: Character)
}

final class CharacterListRouter: CharacterListRouterProtocol {
    weak var viewController: UIViewController?
    func navigateToDetail(character: Character) {
        let detail = CharacterDetailModuleBuilder.build(character: character)
        viewController?.navigationController?.pushViewController(detail, animated: true)
    }
}
