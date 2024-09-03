//
//  ProfileViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class ProfileViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let headerView = ProfileHeaderView()
    
    private enum Section: Int, CaseIterable {
        case userInfo
        case preferences
        case financialInfo
        case account
    }
    
    private enum Row: Hashable {
        case name
        case email
        case notificationSettings
        case expenseReminder
        case addCard
        case linkedAccounts
        case logout
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Row> = {
        return UITableViewDiffableDataSource(tableView: tableView) { [weak self] (tableView, indexPath, row) -> UITableViewCell? in
            return self?.configureCell(for: row, at: indexPath)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        applySnapshot()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([.name, .email], toSection: .userInfo)
        snapshot.appendItems([.notificationSettings, .expenseReminder], toSection: .preferences)
        snapshot.appendItems([.addCard, .linkedAccounts], toSection: .financialInfo)
        snapshot.appendItems([.logout], toSection: .account)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureCell(for row: Row, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        switch row {
        case .name:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = UserDefaults.standard.getUser()?.name
        case .email:
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = UserDefaults.standard.getUser()?.email
        case .notificationSettings:
            cell.textLabel?.text = "Notification Settings"
        case .expenseReminder:
            cell.textLabel?.text = "Expense Reminder"
        case .addCard:
            cell.textLabel?.text = "Add Card"
        case .linkedAccounts:
            cell.textLabel?.text = "Linked Accounts"
        case .logout:
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .systemRed
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch row {
        case .notificationSettings:
            let notificationSettingsVC = NotificationSettingsViewController()
            navigationController?.pushViewController(notificationSettingsVC, animated: true)
        case .expenseReminder:
            let expenseReminderVC = ExpenseReminderViewController()
            navigationController?.pushViewController(expenseReminderVC, animated: true)
        case .addCard:
            let addCardVC = AddCardViewController()
            navigationController?.pushViewController(addCardVC, animated: true)
        case .linkedAccounts:
            let linkedAccountsVC = LinkedAccountsViewController()
            navigationController?.pushViewController(linkedAccountsVC, animated: true)
        case .logout:
            // Implement logout functionality
            print("Logout tapped")
        default:
            break
        }
    }
}

class ProfileHeaderView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        if let user = UserDefaults.standard.getUser() {
            nameLabel.text = user.name
            if let pictureUrl = URL(string: user.pictureUrl) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: pictureUrl) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}

class NotificationSettingsViewController: UIViewController {
    // Implement notification settings UI and functionality
}

class ExpenseReminderViewController: UIViewController {
    // Implement expense reminder settings UI and functionality
}

class AddCardViewController: UIViewController {
    // Implement add card UI and functionality
}

class LinkedAccountsViewController: UIViewController {
    // Implement linked accounts UI and functionality
}
