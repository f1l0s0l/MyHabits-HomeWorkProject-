//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    
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
    
    private let isDoneHabitView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 19
        view.backgroundColor = .orange
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    func setup() {
       
    }

    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(nameHabitLabel)
        self.addSubview(timeHabitLabel)
        self.addSubview(countTrackHabit)
        self.addSubview(isDoneHabitView)
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

        ])
    }
    
    
}
