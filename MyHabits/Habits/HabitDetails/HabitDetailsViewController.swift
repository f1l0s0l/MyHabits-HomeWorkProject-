//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit

class HabitDetailsViewController: UIViewController{
    
    // MARK: - Proterties
    
    private lazy var newArrayDatesInsert = insertArrayDates()
    //Это важный момент, смотри описание в Extension UITableViewDataSource

    weak var delegate: HabitViewControllerDelegate?

    private var thisHabit = Habit(name: "", date: Date.now, color: .orange)
    private var thisHabitIndex = 0
    
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
    
    
    //MARK: - Methods
    
    func setup(index: Int) {
        self.thisHabit = HabitsStore.shared.habits[index]
        self.thisHabitIndex = index
        self.title = thisHabit.name
    }
 
    private func setupView() {
        self.view.backgroundColor = .systemGray6
        self.view.addSubview(tableView)
        self.setupNavigationBar()
        self.setupConstraint()
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
        habitViewController.setup(index: thisHabitIndex)
        habitViewController.delegate = self
        
        let vc = UINavigationController(rootViewController: habitViewController)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func insertArrayDates() -> [Date]{
        var newArrayDatesInsert: [Date] = []
        
        for date in HabitsStore.shared.dates {
            newArrayDatesInsert.insert(date, at: 0)
        }
        
        return newArrayDatesInsert
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


    // MARK: - Extension UITableViewDataSource

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Тут все просто
        //Подготовили ячейку, подготовили imageView что бы при выполнении условия помещать на ячейку
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))// ТУТ Вопрос!!!
            imageView.image = UIImage(systemName: "checkmark")
            imageView.tintColor = .orange
            return imageView
        }()
        
        
        //Но вот тут я понял, что если исполльзовать по простому:
        //cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        //То даты будут в обратном порядке, что логично
        //Ибо ячейка с индексом 0 будет тянуть элемент из массива под индексом 0, а это дата создания приложения
        //Но нам то нужно, что бы первая ячейка была последней, актуальной датой
        //Я так и не понял как это в нормальном варианте пофиксить, так что вот моя реализация
        //Создал массим обратный массиву с датами
        //И тут в отрисовке каждой ячейцки я:
        //Ищу первый индекс в новом массиве для элемента в основном массиве под индексом indexPath.row
        //Логично раз массивы зеркальные, то и индекс будет выходить зеркальный
        //Ну и затем уже этот индекс использую для поиска нужной даты в основном массиве дат
        
        //Как выход из этой ситуации, изменить сохранение дат в HabitsStore.shared.dates так,
        //что бы новые даты попадали в самое начало массива
        
        if let index = newArrayDatesInsert.firstIndex(of: HabitsStore.shared.dates[indexPath.row]) {
            cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: index)
            
            if HabitsStore.shared.habit(thisHabit, isTrackedIn: HabitsStore.shared.dates[index]) {
                cell.accessoryView = imageView
            }
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
    }
    
}


    // MARK: - Extension HabitViewControllerDelegate

extension HabitDetailsViewController: HabitViewControllerDelegate {
    
    func saveHabit(habit: Habit, isCreateHabit: Bool, isChangeHabit: Bool, isChangeTrackHabit: Bool, isRemoveHabit: Bool, indexInArrayHabits: Int) {
        
        delegate?.saveHabit(habit: habit,
                            isCreateHabit: isCreateHabit,
                            isChangeHabit: isChangeHabit,
                            isChangeTrackHabit: isChangeTrackHabit,
                            isRemoveHabit: isRemoveHabit,
                            indexInArrayHabits: indexInArrayHabits
        )
        
        if isRemoveHabit {
            self.navigationController?.popToRootViewController(animated: true)
        }
    
        if isChangeHabit {
            self.title = habit.name
        }
    }

}
