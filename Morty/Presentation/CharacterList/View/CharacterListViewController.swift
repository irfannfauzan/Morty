//
//  CharacterListViewController.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import UIKit
import MortyCore

protocol CharacterListViewProtocol: AnyObject {
    func showLoading()
    func showCharacters()
    func showEmpty(message: String)
    func showError(message: String)
    func reloadCharacter(at index: Int)              
}
final class CharacterListViewController: UIViewController {

    // MARK: - Properties

    private let presenter: CharacterListPresenterProtocol

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Try again"
        return UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.presenter.didTapRetry()
        })
    }()

    private lazy var messageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(presenter: CharacterListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        view.backgroundColor = .systemBackground
        setupLayout()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(messageStack)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}

// MARK: - CharacterListViewProtocol

extension CharacterListViewController: CharacterListViewProtocol {

    func showLoading() {
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        messageStack.isHidden = true
    }

    func showCharacters() {
        loadingIndicator.stopAnimating()
        messageStack.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    func showEmpty(message: String) {
        loadingIndicator.stopAnimating()
        tableView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
        retryButton.isHidden = true
    }

    func showError(message: String) {
        loadingIndicator.stopAnimating()
        tableView.isHidden = true
        messageStack.isHidden = false
        messageLabel.text = message
        retryButton.isHidden = false
    }
    
    func reloadCharacter(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDataSource

extension CharacterListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfCharacters
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.identifier, for: indexPath
        ) as? CharacterCell else {
            return UITableViewCell()
        }

        let index = indexPath.row
        cell.configure(
            with: presenter.character(at: index),
            isFavorite: presenter.isFavorite(at: index)
        )
        cell.onFavoriteTap = { [weak self] in
            self?.presenter.didTapFavorite(at: index)
        }
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectCharacter(at: indexPath.row)
    }
}
