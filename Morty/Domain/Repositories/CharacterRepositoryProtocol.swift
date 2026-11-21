//
//  CharacterRepositoryProtocol.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

protocol CharacterRepositoryProtocol {
    func fetchCharacter(page: Int) async throws -> [Character]
}
