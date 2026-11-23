//
//  CharacterDTO.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

public struct CharacterListResponse: Decodable {
    public let results: [CharacterDTO]
}

public struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, status, species
        case imageURL = "image"
    }
}

extension CharacterDTO {
    public func toDomain() -> Character {
        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            imageURL: URL(string: imageURL)
        )
    }
}
