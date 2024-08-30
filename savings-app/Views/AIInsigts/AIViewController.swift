//
//  AIViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class AIViewController: UIViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Insight"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get personalized financial tips and insights."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let aiAvatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "brain.head.profile"))
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let messageInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type your message..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private let quickTipsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private func setupQuickTips() {
        let tips = ["How to budget?", "Saving for retirement", "Cutting down on expenses"]
        for tip in tips {
            let button = UIButton(type: .system)
            button.setTitle(tip, for: .normal)
//            button.addTarget(self, action: #selector(quickTipSelected(_:)), for: .touchUpInside)
            quickTipsStackView.addArrangedSubview(button)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(aiAvatarImageView)
        
        view.addSubview(chatTableView)
        view.addSubview(messageInputField)
        view.addSubview(sendButton)
        view.addSubview(quickTipsStackView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            aiAvatarImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            aiAvatarImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            aiAvatarImageView.widthAnchor.constraint(equalToConstant: 40),
            aiAvatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: aiAvatarImageView.trailingAnchor, constant: 10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: aiAvatarImageView.trailingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            chatTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -10),
            
            messageInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageInputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            messageInputField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            sendButton.leadingAnchor.constraint(equalTo: messageInputField.trailingAnchor, constant: 10),
            sendButton.centerYAnchor.constraint(equalTo: messageInputField.centerYAnchor),
            
            quickTipsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quickTipsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quickTipsStackView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -10)
        ])
        
        setupQuickTips()
    }


}
