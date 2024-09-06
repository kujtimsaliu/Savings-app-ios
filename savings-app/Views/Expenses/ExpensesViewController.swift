//
//  ExpensesViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class ExpensesViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lineChartView: CustomLineChartView = {
        let chartView = CustomLineChartView()
        chartView.backgroundColor = .systemBackground
        chartView.layer.cornerRadius = 12
        chartView.layer.masksToBounds = true
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    private let addExpenseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Expense", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let upcomingBillsLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming Bills"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let upcomingBillsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let recentExpensesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Expenses"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: ExpensesViewModel
    
    init(viewModel: ExpensesViewModel = ExpensesViewModel()) {
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
        viewModel.fetchExpenses()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Expenses"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(lineChartView)
        contentView.addSubview(addExpenseButton)
        contentView.addSubview(upcomingBillsLabel)
        contentView.addSubview(upcomingBillsStackView)
        contentView.addSubview(recentExpensesLabel)
        contentView.addSubview(tableView)
        
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
            
            lineChartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lineChartView.heightAnchor.constraint(equalToConstant: 250),
            
            addExpenseButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 20),
            addExpenseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addExpenseButton.heightAnchor.constraint(equalToConstant: 50),
            addExpenseButton.widthAnchor.constraint(equalToConstant: 200),
            
            upcomingBillsLabel.topAnchor.constraint(equalTo: addExpenseButton.bottomAnchor, constant: 20),
            upcomingBillsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            upcomingBillsStackView.topAnchor.constraint(equalTo: upcomingBillsLabel.bottomAnchor, constant: 12),
            upcomingBillsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            upcomingBillsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            recentExpensesLabel.topAnchor.constraint(equalTo: upcomingBillsStackView.bottomAnchor, constant: 20),
            recentExpensesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: recentExpensesLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 350) // Adjust this value as needed
        ])
        
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: "ExpenseCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        addExpenseButton.addTarget(self, action: #selector(addExpenseTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.expensesDidChange = { [weak self] in
            self?.updateChartData()
            self?.updateUpcomingBills()
            self?.tableView.reloadData()
        }
    }
    
    private func updateChartData() {
        let dataPoints = viewModel.expenses.reversed().enumerated().map { index, expense in
            CGPoint(x: CGFloat(index), y: CGFloat(expense.amount))
        }
        lineChartView.setDataPoints(dataPoints)
    }
    
    private func updateUpcomingBills() {
        upcomingBillsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let upcomingBills = viewModel.upcomingBills()
        for bill in upcomingBills {
            let billView = UpcomingBillView(expense: bill)
            billView.layer.cornerRadius = 12
            billView.layer.shadowColor = UIColor.black.cgColor
            billView.layer.shadowOffset = CGSize(width: 0, height: 2)
            billView.layer.shadowOpacity = 0.2
            billView.layer.shadowRadius = 4
            upcomingBillsStackView.addArrangedSubview(billView)
        }
    }
    
    @objc private func addExpenseTapped() {
        let addExpenseVC = AddExpenseViewController()
        addExpenseVC.delegate = self
        let navController = UINavigationController(rootViewController: addExpenseVC)
        present(navController, animated: true)
    }
}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        let expense = viewModel.expenses[indexPath.row]
        cell.configure(with: expense)
        return cell
    }
}

extension ExpensesViewController: AddExpenseViewControllerDelegate {
    func didAddExpense(_ expense: Expense) {
        viewModel.addExpense(expense)
    }
}
