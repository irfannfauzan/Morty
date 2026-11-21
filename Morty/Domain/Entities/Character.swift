//
//  Character.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

struct Character: Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let imageURL: URL?
}
