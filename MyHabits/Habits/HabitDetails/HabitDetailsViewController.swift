//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit

class HabitDetailsViewController: UIViewController{
    
// MARK: - Proterties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray5
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        return tableView
    }()
    

// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
//MARK: - Methods

    private func setupView() {
        self.view.backgroundColor = .systemGray6
        self.title = "Название привычки"
        self.view.addSubview(tableView)
        self.setupConstraint()
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        let changeHabitBarButtonItem: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setTitle("Править", for: .normal)
            button.tintColor = UIColor(red: 161/225, green: 22/225, blue: 204/225, alpha: 1)
            button.addTarget(self, action: #selector(presentHabitVC), for: .touchUpInside)
            let changeHabitBarButtonItem = UIBarButtonItem(customView: button)
            return changeHabitBarButtonItem
        }()
        self.navigationItem.rightBarButtonItem = changeHabitBarButtonItem
    }
    
    @objc
    private func presentHabitVC() {
        let habitViewController = HabitViewController()
        habitViewController.setupTitle(with: "Название привычки")
        let vc = UINavigationController(rootViewController: habitViewController)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    

// MARK: - Constraint

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
    }
}


// MARK: - Extension

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "дата активности"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "АКТИВНОСТЬ"
    }
    
}


extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

