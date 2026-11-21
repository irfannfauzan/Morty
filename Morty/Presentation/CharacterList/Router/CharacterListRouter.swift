//
//  CharacterListRouter.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit

protocol CharacterListRouterProtocol: AnyObject {}

final class CharacterListRouter: CharacterListRouterProtocol {
    weak var view: UIViewController?
}
