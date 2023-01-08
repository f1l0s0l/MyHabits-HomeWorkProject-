//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit




class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    private var thisHabit = Habit(name: "", date: Date.now, color: .white)
    private let store = HabitsStore.shared
    
    private lazy var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Название привычки"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в 7:00 утра"
        return label
    }()
    
    private lazy var countTrackHabit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Счетчик 0"
        return label
    }()
    
    private lazy var isDoneHabitView: UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 19
        imageView.backgroundColor = .white
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.addTarget(self, action: #selector(didPabIsDoneHabitView), for: .touchUpInside)
        imageView.addTarget(self, action: #selector(didPabIsDoneHabitViewTest), for: .touchUpOutside)
        return imageView
    }()
    
    @objc
    private func didPabIsDoneHabitView() {
        isDoneHabitView.backgroundColor = UIColor(cgColor: isDoneHabitView.layer.borderColor ?? UIColor.orange.cgColor)
        store.track(thisHabit)
    }
    
    @objc
    private func didPabIsDoneHabitViewTest() {
        isDoneHabitView.backgroundColor = .none
    }
    
    private lazy var checkmarkInButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "checkmark")
        
        imageView.image = image
        imageView.tintColor = .white
        return imageView
    }()
    
    
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let store = HabitsStore.shared
    
    // MARK: - Methods
    
    func setup(habit: Habit) {
        nameHabitLabel.text = habit.name
        nameHabitLabel.textColor = habit.color
        timeHabitLabel.text = habit.dateString

        isDoneHabitView.layer.borderColor = habit.color.cgColor
        thisHabit = habit
        if habit.isAlreadyTakenToday == true {
            isDoneHabitView.backgroundColor = habit.color
        }
        
        
    }

    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(nameHabitLabel)
        self.addSubview(timeHabitLabel)
        self.addSubview(countTrackHabit)
        self.addSubview(isDoneHabitView)
        self.addSubview(checkmarkInButton)
        self.setupConstraint()
    }
    
    
    
    
    // MARK: - Constraints
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            self.nameHabitLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.nameHabitLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.nameHabitLabel.widthAnchor.constraint(equalToConstant: 220),
            
            self.timeHabitLabel.topAnchor.constraint(equalTo: self.nameHabitLabel.bottomAnchor, constant: 4),
            self.timeHabitLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.timeHabitLabel.widthAnchor.constraint(equalTo: self.nameHabitLabel.widthAnchor),
            
            self.countTrackHabit.topAnchor.constraint(equalTo: self.timeHabitLabel.bottomAnchor, constant: 30),
            self.countTrackHabit.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.countTrackHabit.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            self.isDoneHabitView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.isDoneHabitView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25),
            self.isDoneHabitView.widthAnchor.constraint(equalToConstant: 38),
            self.isDoneHabitView.heightAnchor.constraint(equalToConstant: 38),
            
            self.checkmarkInButton.centerXAnchor.constraint(equalTo: self.isDoneHabitView.centerXAnchor),
            self.checkmarkInButton.centerYAnchor.constraint(equalTo: self.isDoneHabitView.centerYAnchor),
            self.checkmarkInButton.widthAnchor.constraint(equalToConstant: 20),
            self.checkmarkInButton.heightAnchor.constraint(equalToConstant: 20),

        ])
    }
    
    
}
