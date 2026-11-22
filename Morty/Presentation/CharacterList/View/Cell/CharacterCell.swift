//
//  CharacterCell.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit
import Kingfisher

final class CharacterCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "CharacterCell"
    
    var onFavoriteTap: (() -> Void)?

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
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.onFavoriteTap?()
        }, for: .touchUpInside)
        return button
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
        contentView.addSubview(favoriteButton)

        let bottomConstraint = avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        bottomConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bottomConstraint,
            avatarView.widthAnchor.constraint(equalToConstant: 56),
            avatarView.heightAnchor.constraint(equalToConstant: 56),

            textStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.kf.cancelDownloadTask()
        avatarView.image = nil
        onFavoriteTap = nil
    }

    // MARK: - Configure

    func configure(with character: Character, isFavorite: Bool) {
        nameLabel.text = character.name
        infoLabel.text = "\(character.status) · \(character.species)"

        let iconName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)

        avatarView.kf.setImage(
            with: character.imageURL,
            placeholder: UIImage(systemName: "person.crop.square"),
            options: [.transition(.fade(0.2))]
        )
    }
}
