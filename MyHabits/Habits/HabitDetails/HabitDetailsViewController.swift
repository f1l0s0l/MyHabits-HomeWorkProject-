//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit

//enum IndexPathHabit {
//    static var indexPath: IndexPath?
//}

class HabitDetailsViewController: UIViewController{
    
// MARK: - Proterties
    
    
    
    
    
    

    weak var delegate: HabitViewControllerDelegate?
    
    var store = HabitsStore.shared
    
    private var habit = Habit(name: "", date: Date.now, color: .orange)
    
    private var indexThisHabit = 0
    
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
//MARK: - Methods
    
    func setup(index: Int) {
        self.title = store.habits[index].name
        
        self.indexThisHabit = index
        habit = store.habits[index]
    }

    
    
    
    private func setupView() {
        self.view.backgroundColor = .systemGray6
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
        habitViewController.setupTitle(with: "Править")
        habitViewController.setup(index: indexThisHabit)
        habitViewController.delegate = self
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
        store.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = store.trackDateString(forIndex: indexPath.item)
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))// ТУТ Вопрос!!!
            imageView.image = UIImage(systemName: "checkmark")
            imageView.tintColor = .orange
            return imageView
        }()
        
        if store.habit(habit, isTrackedIn: store.dates[indexPath.item]) {
            cell.accessoryView = imageView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "АКТИВНОСТЬ"
    }
    
}


extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        navigationController?.dismiss(animated: true)
//        navigationController.
//        dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
}


extension HabitDetailsViewController: HabitViewControllerDelegate {
    
    func saveHabit(habit: Habit, isCreate: Bool, isRemove: Bool, indexInArrayHabits: Int) {
        print("Вызов делегата в HabitDetailsViewController")
        self.title = habit.name
        delegate?.saveHabit(habit: habit, isCreate: isCreate, isRemove: isRemove, indexInArrayHabits: indexInArrayHabits)
        if isRemove {
            self.navigationController?.popToRootViewController(animated: true)
        }
        //воможно тут не понадобится делегат второй, щас проверим
    }
    
    
}
