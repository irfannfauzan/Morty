//
//  Character.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

public struct Character: Hashable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let imageURL: URL?

    public init(id: Int, name: String, status: String, species: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.imageURL = imageURL
    }
}
