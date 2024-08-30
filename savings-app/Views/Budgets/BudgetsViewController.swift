//
//  BudgetsViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 16.7.24.
//

import UIKit

class BudgetsViewController: UIViewController, AddBudgetViewControllerDelegate {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
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
        viewModel.budgetsDidChange?()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Budgets"
        
        view.addSubview(scrollView)
        scrollView.addSubview(chartView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            chartView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            chartView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
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
        let bars = viewModel.budgets.enumerated().reversed().map { index, budget in
            CustomBarChartView.Bar(value: budget.amount, date: budget.createdAt, color: colors[index % colors.count])
        }
        chartView.setBars(bars)
        
        // Update the width of the chart view based on the number of bars
        let chartWidth = CGFloat(bars.count) * (chartView.barWidth + chartView.spacing) + chartView.spacing
        
        // Ensure that the chart view is properly positioned within the scroll view
        NSLayoutConstraint.deactivate(chartView.constraints) // Reset constraints
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor), // Attach leading edge
            chartView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            chartView.widthAnchor.constraint(equalToConstant: chartWidth),
            chartView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // Ensure the scroll view's content size is updated
        scrollView.contentSize = CGSize(width: chartWidth, height: scrollView.bounds.height)
        
        // Scroll to the right to show the newly added budget
        let newContentOffsetX = max(scrollView.contentSize.width - scrollView.bounds.width, 0)
        scrollView.setContentOffset(CGPoint(x: newContentOffsetX, y: 0), animated: true)
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
