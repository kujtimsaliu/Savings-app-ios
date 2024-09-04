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
            nameLabel.text = user.givenName
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
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var notificationSettings: [String: Bool] = [
        "Expense Reminders": true,
        "Budget Alerts": true,
        "Weekly Summary": false
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification Settings"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let setting = Array(notificationSettings.keys)[indexPath.row]
        cell.textLabel?.text = setting
        let switchView = UISwitch(frame: .zero)
        switchView.isOn = notificationSettings[setting] ?? false
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        let setting = Array(notificationSettings.keys)[sender.tag]
        notificationSettings[setting] = sender.isOn
    }
}

class ExpenseReminderViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var reminderFrequency: String = "Daily"
    private var reminderTime: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expense Reminders"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension ExpenseReminderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Reminder Frequency"
            cell.detailTextLabel?.text = reminderFrequency
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = "Reminder Time"
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            cell.detailTextLabel?.text = formatter.string(from: reminderTime)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            // Show frequency picker
        } else {
            // Show time picker
        }
    }
}

class AddCardViewController: UIViewController {
    private let cardNumberTextField = UITextField()
    private let expirationDateTextField = UITextField()
    private let cvvTextField = UITextField()
    private let addButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Card"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [cardNumberTextField, expirationDateTextField, cvvTextField, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cardNumberTextField.placeholder = "Card Number"
        expirationDateTextField.placeholder = "MM/YY"
        cvvTextField.placeholder = "CVV"
        addButton.setTitle("Add Card", for: .normal)
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            expirationDateTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
            expirationDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expirationDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cvvTextField.topAnchor.constraint(equalTo: expirationDateTextField.bottomAnchor, constant: 20),
            cvvTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cvvTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.topAnchor.constraint(equalTo: cvvTextField.bottomAnchor, constant: 40),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
    }
    
    @objc private func addCardTapped() {
        // Implement card addition logic
    }
}

class LinkedAccountsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var linkedAccounts: [String] = ["Bank of America", "Chase"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Linked Accounts"
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension LinkedAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkedAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = linkedAccounts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            linkedAccounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
