//
//  BudgetsViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class BudgetsViewController: UIViewController, AddBudgetViewControllerDelegate {
    private let chartView: CustomBarChartView = {
        let chartView = CustomBarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: BudgetsViewModel
    
    init(viewModel: BudgetsViewModel = BudgetsViewModel()) {
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
        viewModel.fetchBudgets()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBudgetTapped))
    }
    
    @objc private func addBudgetTapped() {
        let addBudgetVC = AddBudgetViewController()
        addBudgetVC.delegate = self
        
        if let sheet = addBudgetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(addBudgetVC, animated: true)
    }
    
    func didAddBudget(_ budget: Budget) {
        viewModel.addBudget(budget)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Budgets"
        
        view.addSubview(chartView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(BudgetCell.self, forCellReuseIdentifier: "BudgetCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.budgetsDidChange = { [weak self] in
            self?.updateChartData()
            self?.tableView.reloadData()
        }
    }
    
    private func updateChartData() {
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemRed, .systemYellow, .systemPurple]
        let bars = viewModel.budgets.enumerated().map { index, budget in
            CustomBarChartView.Bar(value: budget.amount, date: budget.createdAt, color: colors[index % colors.count])
        }
        chartView.setBars(bars)
    }
}

extension BudgetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.budgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetCell
        let budget = viewModel.budgets[indexPath.row]
        cell.configure(with: budget)
        return cell
    }
}
