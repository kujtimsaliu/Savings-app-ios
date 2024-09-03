import UIKit
//import DGCharts

class HomeViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let greetingLabel = UILabel()
    private let profileImageView = UIImageView()
    private let totalBalanceView = BalanceView()
    
    private let expenseSummaryView = ExpenseSummaryView()
    private let budgetProgressView = BudgetProgressView()
    private let spendingChartView = CustomLineChartView()
    private let quickActionsView = QuickActionsView()
    private let recentTransactionsView = RecentTransactionsView()
    private let addExpenseButton = UIButton(type: .system)
    
    private let viewModel: HomeViewModel
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchData()
        updateNotificationStatus()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Home"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [headerView, expenseSummaryView, budgetProgressView, spendingChartView, quickActionsView, recentTransactionsView, addExpenseButton].forEach { contentView.addSubview($0) }
        
        headerView.addSubview(greetingLabel)
        headerView.addSubview(profileImageView)
        headerView.addSubview(totalBalanceView)
        
        setupConstraints()
        setupStyles()
        
        addExpenseButton.addTarget(self, action: #selector(addExpenseTapped), for: .touchUpInside)
        quickActionsView.delegate = self
    }

    
    private func setupConstraints() {
        [scrollView, contentView, headerView, greetingLabel, profileImageView, totalBalanceView, expenseSummaryView, budgetProgressView, recentTransactionsView, addExpenseButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            greetingLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            greetingLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 40),
            
//            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            profileImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30),
//            profileImageView.leadingAnchor.constraint(equalTo: greetingLabel.trailingAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: greetingLabel.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            totalBalanceView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            totalBalanceView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            totalBalanceView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
//            totalBalanceView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
//            totalBalanceView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            expenseSummaryView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            expenseSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expenseSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            expenseSummaryView.heightAnchor.constraint(equalToConstant: 70),
            
            budgetProgressView.topAnchor.constraint(equalTo: expenseSummaryView.bottomAnchor, constant: 20),
            budgetProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            budgetProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            budgetProgressView.heightAnchor.constraint(equalToConstant: 40),
            
            recentTransactionsView.topAnchor.constraint(equalTo: budgetProgressView.bottomAnchor, constant: 40),
            recentTransactionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentTransactionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            addExpenseButton.topAnchor.constraint(equalTo: recentTransactionsView.bottomAnchor, constant: 20),
            addExpenseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addExpenseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupStyles() {
        scrollView.contentInsetAdjustmentBehavior = .never

        headerView.backgroundColor = .systemIndigo
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray4

        greetingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        greetingLabel.textColor = .white
//        greetingLabel.textAlignment = .right

        addExpenseButton.setTitle("Add Expense", for: .normal)
        addExpenseButton.backgroundColor = .systemIndigo
        addExpenseButton.setTitleColor(.white, for: .normal)
        addExpenseButton.layer.cornerRadius = 25
        addExpenseButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        addExpenseButton.layer.shadowColor = UIColor.black.cgColor
        addExpenseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addExpenseButton.layer.shadowRadius = 4
        addExpenseButton.layer.shadowOpacity = 0.1
    }
    
    private func updateUI() {
        greetingLabel.text = viewModel.greeting
        totalBalanceView.configure(with: viewModel.totalBalance)
        expenseSummaryView.configure(with: viewModel.expenseSummary)
        budgetProgressView.configure(with: viewModel.budgetProgress)
        recentTransactionsView.configure(with: viewModel.recentTransactions)
        
        if let user = UserDefaults.standard.getUser() {
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
    
    func updateNotificationStatus() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
                UserDefaults.standard.set(true, forKey: "notificationPermissionGranted")
            } else {
                print("Notification permission denied")
                UserDefaults.standard.set(false, forKey: "notificationPermissionGranted")
            }
        }
        //in case it was changed while the app is running
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let granted = settings.authorizationStatus == .authorized
            UserDefaults.standard.set(granted, forKey: "notificationPermissionGranted")
        }
    }
    
    
    @objc private func addExpenseTapped() {
        let addExpenseVC = AddExpenseViewController()
        addExpenseVC.delegate = self
        let navController = UINavigationController(rootViewController: addExpenseVC)
        present(navController, animated: true)
    }
}

extension HomeViewController: QuickActionsViewDelegate {
    func didTapAddBudget() {
        let addBudgetVC = AddBudgetViewController()
        addBudgetVC.delegate = self
        let navController = UINavigationController(rootViewController: addBudgetVC)
        present(navController, animated: true)
    }
    
    func didTapViewReports() {
        let reportsVC = ReportsViewController()
        navigationController?.pushViewController(reportsVC, animated: true)
    }
}

extension HomeViewController: AddExpenseViewControllerDelegate {
    func didAddExpense(_ expense: Expense) {
        viewModel.addExpense(expense)
    }
}

extension HomeViewController: AddBudgetViewControllerDelegate {
    func didAddBudget(_ budget: Budget) {
        viewModel.addBudget(budget)
    }
}


class QuickActionsView: UIView {
    weak var delegate: QuickActionsViewDelegate?
    
    private let addBudgetButton = UIButton(type: .system)
    private let viewReportsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(addBudgetButton)
        addSubview(viewReportsButton)
        
        addBudgetButton.setTitle("Add Budget", for: .normal)
        viewReportsButton.setTitle("View Reports", for: .normal)
        
        addBudgetButton.addTarget(self, action: #selector(addBudgetTapped), for: .touchUpInside)
        viewReportsButton.addTarget(self, action: #selector(viewReportsTapped), for: .touchUpInside)
        
        addBudgetButton.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        viewReportsButton.anchor(top: addBudgetButton.bottomAnchor, left: leftAnchor, right: rightAnchor, topConstant: 16)
    }
    
    @objc private func addBudgetTapped() {
        delegate?.didTapAddBudget()
    }
    
    @objc private func viewReportsTapped() {
        delegate?.didTapViewReports()
    }
}

protocol QuickActionsViewDelegate: AnyObject {
    func didTapAddBudget()
    func didTapViewReports()
}
