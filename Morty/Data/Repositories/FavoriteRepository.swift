//
//  FavoriteRepository.swift
//  Morty
//
//  Created by Vokal-Ican on 22/11/26.
//

import CoreData
import MortyCore

@MainActor
final class FavoriteRepository: FavoriteRepositoryProtocol {

    private let stack: CoreDataStack

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
    }

    func fetchFavorites() -> [Character] {
        let request = FavoriteCharacterEntity.fetchRequest()
        let entities = (try? stack.context.fetch(request)) ?? []
        return entities.map { $0.toDomain() }
    }

    func isFavorite(id: Int) -> Bool {
        let request = FavoriteCharacterEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let count = (try? stack.context.count(for: request)) ?? 0
        return count > 0
    }

    func addFavorite(_ character: Character) {
        guard !isFavorite(id: character.id) else { return }

        let entity = FavoriteCharacterEntity(context: stack.context)
        entity.id = Int64(character.id)
        entity.name = character.name
        entity.status = character.status
        entity.species = character.species
        entity.imageURL = character.imageURL?.absoluteString

        stack.saveContext()
    }

    func removeFavorite(id: Int) {
        let request = FavoriteCharacterEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        let entities = (try? stack.context.fetch(request)) ?? []
        entities.forEach { stack.context.delete($0) }
        stack.saveContext()
    }
}

// MARK: - Mapping

private extension FavoriteCharacterEntity {
    func toDomain() -> Character {
        Character(
            id: Int(id),
            name: name ?? "",
            status: status ?? "",
            species: species ?? "",
            imageURL: imageURL.flatMap(URL.init(string:))
        )
    }
}
