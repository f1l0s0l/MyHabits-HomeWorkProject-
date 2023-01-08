//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Илья Сидорик on 27.12.2022.
//

import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func saveHabit(habit: Habit, isCreate: Bool, isRemove: Bool, indexInArrayHabits: Int)

}

class HabitViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: HabitViewControllerDelegate?
    
    
    private var oldStateHabit: Habit?
    private var oldIndex = 0
    
    private lazy var viewInSafeArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
//        textField.addTarget(self, action: #selector(changeNameHabitLabel), for: .valueChanged)
        textField.delegate = self
        return textField
    }()
    
//    @objc
//    private func changeNameHabitLabel(_ textField: UITextField) {
//        nameHabitLabel.text = textField.text
//    }
    
    
    
    
    private lazy var colorHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var changeColorHabit: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .orange
        view.setTitle("hhv", for: .normal)
        view.addTarget(self, action: #selector(presentColorPickerVC), for: .touchUpInside)
        return view
    }()
    
    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        return colorPicker
    }()
    
    @objc
    private func presentColorPickerVC() {
        present(colorPickerViewController, animated: true)
    }
    
    private lazy var timeHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var addTimeHabitLabel: UILabel = {
        let label = UILabel()
        let date = Date()
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в " + formatter.string(from: datePickerView.date)
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(chengeDatePickerView), for: .valueChanged)
        return datePicker
    }()
    
    
    @objc
    private func chengeDatePickerView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        addTimeHabitLabel.text = "Каждый день в " + formatter.string(from: datePickerView.date)
        
    }
    
    

    private lazy var removeHabitButtom: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor(red: 225/225, green: 59/225, blue: 48/225, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(removeHabitButtomAddTerget), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeHabitAlertController: UIAlertController = {
        let alert = UIAlertController(
            title: "Удалить привычку",
            message: "Вы действительно хотите удалить привычку \"\(self.nameHabitTextField.text ?? "")\"",
            preferredStyle: .alert
        )
        let action1 = UIAlertAction(title: "Отмена", style: .cancel) {_ in
            print("Нажал на Отмена привычку в алерте")
        }
        let action2 = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            print("Нажал на Удалить привычку в алерте")
            
            if let habit = self.oldStateHabit {
                self.delegate?.saveHabit(habit: habit, isCreate: false, isRemove: true, indexInArrayHabits: self.oldIndex)
            }
//            self.store.habits.removeAll(where: {$0 == self.oldStateHabit})
            
            self.dismiss(animated: true)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        return alert
    }()

    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        setupRemoveButton()
        
        
//        print(store.habits)
    }
    
    // MARK: - Methods
    
    
    func setup(index: Int) {
        let habit = store.habits[index]
        nameHabitTextField.text = habit.name
        changeColorHabit.backgroundColor = habit.color
        colorPickerViewController.selectedColor = habit.color
        addTimeHabitLabel.text = habit.dateString
        
        oldStateHabit = habit
        oldIndex = index
    }
    
    
    private func setupRemoveButton(){
        if self.title == "Создать" {
            removeHabitButtom.alpha = 0
        }
    }

    private func setupView() {
        self.view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
//        self.title = "Создать"
        self.setupNavigationBar()
        self.addSubViews()
        self.setupConstraint()
    }
    
    private func setupNavigationBar() {
        let saveBarButtonItem: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setTitle("Сохранить", for: .normal)
            button.tintColor = UIColor(red: 161/225, green: 22/225, blue: 204/225, alpha: 1)
            button.addTarget(self, action: #selector(didPabSaveBarButton), for: .touchUpInside)
            let saveBarButtonItem = UIBarButtonItem(customView: button)
            return saveBarButtonItem
        }()
        
        let canselButtonItem: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setTitle("Отменить", for: .normal)
            button.tintColor = UIColor(red: 161/225, green: 22/225, blue: 204/225, alpha: 1)
            button.addTarget(self, action: #selector(dismissHabitViewController), for: .touchUpInside)
            let canselButtonItem = UIBarButtonItem(customView: button)
            return canselButtonItem
        }()
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        self.navigationItem.leftBarButtonItem = canselButtonItem
    }
    
    
    
    let store = HabitsStore.shared
    
    @objc
    private func dismissHabitViewController() {
        dismiss(animated: true)
    }
    
    
    @objc
    private func didPabSaveBarButton() {
        let habit = Habit(name: nameHabitTextField.text ?? "Привычка", date: datePickerView.date, color: colorPickerViewController.selectedColor)
        
        if self.title == "Создать" {
            delegate?.saveHabit(habit: habit, isCreate: true, isRemove: false, indexInArrayHabits: oldIndex)
        } else {
            print("тут работает")
            delegate?.saveHabit(habit: habit, isCreate: false, isRemove: false, indexInArrayHabits: oldIndex)
        }
        
        dismissHabitViewController()
    }
    
    @objc
    private func removeHabitButtomAddTerget(){
        self.present(removeHabitAlertController, animated: true, completion: nil)
    }
    
    func setupTitle(with title: String) {
        self.title = title
    }
    
    private func addSubViews() {
        self.view.addSubview(viewInSafeArea)
        self.viewInSafeArea.addSubview(nameHabitLabel)
        self.viewInSafeArea.addSubview(nameHabitTextField)
        self.viewInSafeArea.addSubview(colorHabitLabel)
        self.viewInSafeArea.addSubview(changeColorHabit)
        self.viewInSafeArea.addSubview(timeHabitLabel)
        self.viewInSafeArea.addSubview(addTimeHabitLabel)
        self.viewInSafeArea.addSubview(datePickerView)
        self.viewInSafeArea.addSubview(removeHabitButtom)

    }
    
    @objc
    private func forcedHidingKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Constraints
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            viewInSafeArea.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            viewInSafeArea.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            viewInSafeArea.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            viewInSafeArea.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            nameHabitLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 21),
            nameHabitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            nameHabitTextField.topAnchor.constraint(equalTo: self.nameHabitLabel.bottomAnchor, constant: 7),
            nameHabitTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            
            colorHabitLabel.topAnchor.constraint(equalTo: self.nameHabitTextField.bottomAnchor, constant: 15),
            colorHabitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            changeColorHabit.topAnchor.constraint(equalTo: self.colorHabitLabel.bottomAnchor, constant: 7),
            changeColorHabit.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            changeColorHabit.widthAnchor.constraint(equalToConstant: 30),
            changeColorHabit.heightAnchor.constraint(equalToConstant: 30),
            
            timeHabitLabel.topAnchor.constraint(equalTo: self.changeColorHabit.bottomAnchor, constant: 15),
            timeHabitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            addTimeHabitLabel.topAnchor.constraint(equalTo: self.timeHabitLabel.bottomAnchor, constant: 7),
            addTimeHabitLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            datePickerView.topAnchor.constraint(equalTo: self.addTimeHabitLabel.bottomAnchor, constant: 15),
            datePickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            datePickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

            
            removeHabitButtom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            removeHabitButtom.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
        ])
        
    }

    
    
}

// MARK: - Extension

extension HabitViewController: UIColorPickerViewControllerDelegate {
    
//    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
//        <#code#>
//    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        changeColorHabit.backgroundColor = viewController.selectedColor
    }
    
}


extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.forcedHidingKeyboard()
        return true
    }
    
}
