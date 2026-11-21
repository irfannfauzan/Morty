//
//  CharacterCell.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit

final class CharacterCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "CharacterCell"

    private var imageTask: Task<Void, Never>?

    // MARK: - UI

    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, infoLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        contentView.addSubview(avatarView)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            avatarView.widthAnchor.constraint(equalToConstant: 56),
            avatarView.heightAnchor.constraint(equalToConstant: 56),

            textStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStack.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        avatarView.image = nil
    }

    // MARK: - Configure

    func configure(with character: Character) {
        nameLabel.text = character.name
        infoLabel.text = "\(character.status) · \(character.species)"

        guard let url = character.imageURL else { return }

        imageTask = Task { [weak self] in
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data),
                  !Task.isCancelled else { return }
            self?.avatarView.image = image
        }
    }
}
