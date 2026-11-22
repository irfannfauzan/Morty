//
//  FavoriteRepositoryProtocol.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

protocol FavoriteRepositoryProtocol {
    func fetchFavorites() -> [Character]
    func isFavorite(id: Int) -> Bool
    func addFavorite(_ character: Character)
    func removeFavorite(id: Int)
}
