//
//  CharacterDetailRouter.swift
//  Morty
//
//  Created by Vokal-Ican on 23/11/26.
//

import UIKit
import MortyCore

protocol CharacterDetailRouterProtocol: AnyObject {}

final class CharacterDetailRouter: CharacterDetailRouterProtocol {
    weak var viewController: UIViewController?
}
