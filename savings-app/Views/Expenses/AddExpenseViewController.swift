//
//  AddExpenseViewController.swift
//  savings-app
//
//  Created by Kujtim Saliu on 30.8.24.
//

import UIKit
import UserNotifications

protocol AddExpenseViewControllerDelegate: AnyObject {
    func didAddExpense(_ expense: Expense)
}

class AddExpenseViewController: UIViewController {
    weak var delegate: AddExpenseViewControllerDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let amountTextField = UITextField()
    private let categorySegmentedControl = UISegmentedControl(items: ["🍔 Food", "🚗 Transport", "🎉 Entertainment", "🗂️ Other"])
    private let descriptionTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let paymentMethodSegmentedControl = UISegmentedControl(items: ["💵 Cash", "💳 Credit Card", "🏦 Debit Card"])
    private let attachmentButton = UIButton(type: .system)
    private let recurringSwitch = UISwitch()
    private let recurringFrequencySegmentedControl = UISegmentedControl(items: ["📅 Daily", "📅 Weekly", "📅 Monthly"])
    private let reminderSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Add Expense"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        setupInputFields()
    }
    
    private func setupInputFields() {
        amountTextField.placeholder = "Amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .roundedRect
        amountTextField.backgroundColor = .systemGray6
        amountTextField.layer.cornerRadius = 8
        amountTextField.layer.masksToBounds = true
        
        categorySegmentedControl.selectedSegmentIndex = 0
        
        descriptionTextField.placeholder = "Description"
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.backgroundColor = .systemGray6
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.layer.masksToBounds = true
        
        datePicker.datePickerMode = .date
        
        paymentMethodSegmentedControl.selectedSegmentIndex = 0
        
        attachmentButton.setTitle("📎 Attach Receipt", for: .normal)
        attachmentButton.tintColor = .systemBlue
        
        recurringFrequencySegmentedControl.selectedSegmentIndex = 0
        recurringFrequencySegmentedControl.isHidden = true
        
        let amountLabel = createLabel(withText: "Amount:")
        let categoryLabel = createLabel(withText: "Category:")
        let descriptionLabel = createLabel(withText: "Description:")
        let dateLabel = createLabel(withText: "Date:")
        let paymentMethodLabel = createLabel(withText: "Payment Method:")
        let recurringLabel = createLabel(withText: "Recurring:")
        let reminderLabel = createLabel(withText: "Set Reminder:")
        
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(categorySegmentedControl)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(descriptionTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(paymentMethodLabel)
        stackView.addArrangedSubview(paymentMethodSegmentedControl)
        stackView.addArrangedSubview(attachmentButton)
        stackView.addArrangedSubview(recurringLabel)
        stackView.addArrangedSubview(recurringSwitch)
        stackView.addArrangedSubview(recurringFrequencySegmentedControl)
        stackView.addArrangedSubview(reminderLabel)
        stackView.addArrangedSubview(reminderSwitch)
        
        recurringSwitch.addTarget(self, action: #selector(recurringToggled), for: .valueChanged)
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }
    
    @objc private func recurringToggled() {
        recurringFrequencySegmentedControl.isHidden = !recurringSwitch.isOn
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            // Show error
            return
        }
        
        let category = categorySegmentedControl.titleForSegment(at: categorySegmentedControl.selectedSegmentIndex) ?? "Other"
        let description = descriptionTextField.text ?? ""
        let date = datePicker.date
        let paymentMethod = paymentMethodSegmentedControl.titleForSegment(at: paymentMethodSegmentedControl.selectedSegmentIndex) ?? "Cash"
        let isRecurring = recurringSwitch.isOn
        let recurringFrequency = isRecurring ? recurringFrequencySegmentedControl.titleForSegment(at: recurringFrequencySegmentedControl.selectedSegmentIndex) : nil
        let hasReminder = reminderSwitch.isOn
        
        let newExpense = Expense(id: UUID().uuidString,
                                 amount: amount,
                                 category: category,
                                 description: description,
                                 date: date,
                                 paymentMethod: paymentMethod,
                                 isRecurring: isRecurring,
                                 recurringFrequency: recurringFrequency,
                                 hasReminder: hasReminder)
        
        delegate?.didAddExpense(newExpense)
        
        if hasReminder {
            scheduleReminder(for: newExpense)
        }
        
        dismiss(animated: true)
    }
    
    private func scheduleReminder(for expense: Expense) {
        let content = UNMutableNotificationContent()
        content.title = "Expense Reminder"
        content.body = "Don't forget about your \(expense.category) expense of \(expense.amount)"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: expense.date), repeats: false)
        
        let request = UNNotificationRequest(identifier: expense.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
