//
//  CharacterDetailViewController.swift
//  Morty
//
//  Created by Vokal-Ican on 23/11/26.
//

import UIKit
import Kingfisher

protocol CharacterDetailViewProtocol: AnyObject {
    func showCharacter(_ character: Character)
}

final class CharacterDetailViewController: UIViewController {

    // MARK: - Properties

    private let presenter: CharacterDetailPresenterProtocol

    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let statusDot: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return view
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var statusStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusDot, statusLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, statusStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.setCustomSpacing(24, after: imageView)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(presenter: CharacterDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        setupLayout()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            imageView.widthAnchor.constraint(equalToConstant: 240),
            imageView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }

    // MARK: - Helpers

    private func statusColor(for status: String) -> UIColor {
        switch status.lowercased() {
        case "alive": return .systemGreen
        case "dead": return .systemRed
        default: return .systemGray
        }
    }
}

// MARK: - CharacterDetailViewProtocol

extension CharacterDetailViewController: CharacterDetailViewProtocol {

    func showCharacter(_ character: Character) {
        title = character.name
        nameLabel.text = character.name
        statusLabel.text = "\(character.status) · \(character.species)"
        statusDot.backgroundColor = statusColor(for: character.status)
        imageView.kf.setImage(with: character.imageURL, options: [.transition(.fade(0.2))])
    }
}
