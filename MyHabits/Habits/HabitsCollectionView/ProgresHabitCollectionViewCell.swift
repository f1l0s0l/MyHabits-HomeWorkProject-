//
//  ProgresHabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit

class ProgresHabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        return label
    }()
    
    private lazy var countProgress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "50%"
        return label
    }()
    
    private lazy var progresBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 5
        return view
    }()
    private lazy var progresView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 161/225, green: 22/225, blue: 204/225, alpha: 1)
        view.layer.cornerRadius = 5
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
        self.addSubview(textLabel)
        self.addSubview(countProgress)
        self.addSubview(progresBackView)
        self.addSubview(progresView)
        self.setupConstraint()
    }
    
    
    
    
    // MARK: - Constraints
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),

            countProgress.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            countProgress.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            
            progresBackView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10),
            progresBackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            progresBackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            progresBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            progresBackView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10),
            progresBackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            progresBackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            progresBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            progresBackView.heightAnchor.constraint(equalToConstant: 7),
            
            progresView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10),
            progresView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            progresView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -70),
            progresView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            progresView.heightAnchor.constraint(equalToConstant: 7),
            

        ])
    }
    
    
}
