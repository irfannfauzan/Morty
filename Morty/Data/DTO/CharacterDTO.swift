//
//  CharacterDTO.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

struct CharacterListResponse: Decodable {
    let results: [CharacterDTO]
}

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let imageURL: String
}

extension CharacterDTO {
    func toDomain() -> Character {
        Character(id: id,
                  name: name,
                  status: status,
                  species: species,
                  imageURL: URL(string: imageURL)
        )
    }
}
