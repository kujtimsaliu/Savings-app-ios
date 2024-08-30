import UIKit

class HomeViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let greetingLabel = UILabel()
    private let totalBalanceView = BalanceView()
    private let expenseSummaryView = ExpenseSummaryView()
    private let budgetProgressView = BudgetProgressView()
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
        
        [greetingLabel, totalBalanceView, expenseSummaryView, budgetProgressView, recentTransactionsView, addExpenseButton].forEach { contentView.addSubview($0) }
        
        setupConstraints()
        setupStyles()
        
        addExpenseButton.addTarget(self, action: #selector(addExpenseTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        [scrollView, contentView, greetingLabel, totalBalanceView, expenseSummaryView, budgetProgressView, recentTransactionsView, addExpenseButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
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
            
            greetingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            totalBalanceView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            totalBalanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            totalBalanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            expenseSummaryView.topAnchor.constraint(equalTo: totalBalanceView.bottomAnchor, constant: 20),
            expenseSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expenseSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            budgetProgressView.topAnchor.constraint(equalTo: expenseSummaryView.bottomAnchor, constant: 20),
            budgetProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            budgetProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            recentTransactionsView.topAnchor.constraint(equalTo: budgetProgressView.bottomAnchor, constant: 20),
            recentTransactionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentTransactionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            addExpenseButton.topAnchor.constraint(equalTo: recentTransactionsView.bottomAnchor, constant: 20),
            addExpenseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addExpenseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupStyles() {
        greetingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        addExpenseButton.setTitle("Add Expense", for: .normal)
        addExpenseButton.backgroundColor = .systemBlue
        addExpenseButton.setTitleColor(.white, for: .normal)
        addExpenseButton.layer.cornerRadius = 8
        addExpenseButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    
    private func updateUI() {
        
        greetingLabel.text = viewModel.greeting
        totalBalanceView.configure(with: viewModel.totalBalance)
        expenseSummaryView.configure(with: viewModel.expenseSummary)
        budgetProgressView.configure(with: viewModel.budgetProgress)
        recentTransactionsView.configure(with: viewModel.recentTransactions)
        
        if let user = UserDefaults.standard.getUser(){
            greetingLabel.text! += ", \(user.givenName)"
        }
    }
    
    @objc private func addExpenseTapped() {
        let addExpenseVC = AddExpenseViewController()
        addExpenseVC.delegate = self
        let navController = UINavigationController(rootViewController: addExpenseVC)
        present(navController, animated: true)
    }
}

extension HomeViewController: AddExpenseViewControllerDelegate {
    func didAddExpense(_ expense: Expense) {
        viewModel.addExpense(expense)
    }
}

// Custom Views
class BalanceView: UIView {
    private let balanceLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [balanceLabel, titleLabel].forEach { addSubview($0) }
        
        balanceLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .secondaryLabel
        
        [balanceLabel, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: topAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with balance: Double) {
        balanceLabel.text = String(format: "$%.2f", balance)
        titleLabel.text = "Total Balance"
    }
}

class ExpenseSummaryView: UIView {
    private let totalExpensesLabel = UILabel()
    private let averageDailyExpenseLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [totalExpensesLabel, averageDailyExpenseLabel].forEach { addSubview($0) }
        
        [totalExpensesLabel, averageDailyExpenseLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            totalExpensesLabel.topAnchor.constraint(equalTo: topAnchor),
            totalExpensesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            averageDailyExpenseLabel.topAnchor.constraint(equalTo: totalExpensesLabel.bottomAnchor, constant: 8),
            averageDailyExpenseLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            averageDailyExpenseLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with summary: (total: Double, average: Double)) {
        totalExpensesLabel.text = "Total Expenses: $\(String(format: "%.2f", summary.total))"
        averageDailyExpenseLabel.text = "Avg. Daily: $\(String(format: "%.2f", summary.average))"
    }
}

class BudgetProgressView: UIView {
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let labelStack = UIStackView()
    private let budgetLabel = UILabel()
    private let remainingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [progressView, labelStack].forEach { addSubview($0) }
        [budgetLabel, remainingLabel].forEach { labelStack.addArrangedSubview($0) }
        
        progressView.progressTintColor = .systemBlue
        labelStack.axis = .horizontal
        labelStack.distribution = .equalSpacing
        
        [budgetLabel, remainingLabel].forEach { $0.font = UIFont.systemFont(ofSize: 14) }
        
        [progressView, labelStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            labelStack.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            labelStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with progress: (spent: Double, total: Double)) {
        progressView.progress = Float(progress.spent / progress.total)
        budgetLabel.text = "Budget: $\(String(format: "%.2f", progress.total))"
        remainingLabel.text = "Remaining: $\(String(format: "%.2f", progress.total - progress.spent))"
    }
}

class RecentTransactionsView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, stackView].forEach { addSubview($0) }
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "Recent Transactions"
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        [titleLabel, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with transactions: [Expense]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        transactions.prefix(5).forEach { expense in
            let transactionView = TransactionView()
            transactionView.configure(with: expense)
            stackView.addArrangedSubview(transactionView)
        }
    }
}

class TransactionView: UIView {
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [categoryLabel, amountLabel, dateLabel].forEach { addSubview($0) }
        
        categoryLabel.font = UIFont.systemFont(ofSize: 16)
        amountLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        
        [categoryLabel, amountLabel, dateLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            amountLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with expense: Expense) {
        categoryLabel.text = expense.category
        amountLabel.text = String(format: "$%.2f", expense.amount)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: expense.date)
    }
}
