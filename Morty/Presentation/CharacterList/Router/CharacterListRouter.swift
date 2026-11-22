//
//  CharacterListRouter.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit

protocol CharacterListRouterProtocol: AnyObject {
    func navigateToDetail(character: Character)
}

final class CharacterListRouter: CharacterListRouterProtocol {
    weak var viewController: UIViewController?
    func navigateToDetail(character: Character) {
        // sementara, nanti diganti CharacterDetailModuleBuilder.build(character:)
        let placeholder = UIViewController()
        placeholder.view.backgroundColor = .systemBackground
        placeholder.title = character.name
        viewController?.navigationController?.pushViewController(placeholder, animated: true)
    }
}
