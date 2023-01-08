//
//  ProgresHabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Илья Сидорик on 29.12.2022.
//

import UIKit

class ProgresHabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    private var store = HabitsStore.shared
    
    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        return label
    }()
    
    
    private lazy var countProgress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  0%"
        return label
    }()
    
    private lazy var progresBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 3.5
        return view
    }()
    private lazy var progresView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 161/225, green: 22/225, blue: 204/225, alpha: 1)
        view.layer.cornerRadius = 3.5
        return view
    }()
    
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
//        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func setupGestures() {
        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(test))
        tabGestureRecognizer.numberOfTapsRequired = 2
        self.progresBackView.addGestureRecognizer(tabGestureRecognizer)
    }
    
    @objc
    private func test() {
        setup()
    }
    
    
     func setup() {
        print("нажал на прогресс")
        let progress = store.todayProgress
        let maxProgressWidth = progresBackView.frame.width
        
        let progressWidth = maxProgressWidth * CGFloat(progress)
        
        progresViewWidthAnchor?.constant = progressWidth
        
//        progresViewWidthAnchor = progresView.widthAnchor.constraint(equalToConstant: CGFloat(progressWidth))
        
         UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            print("по идее должна заработать анимация")
            self.countProgress.text = "\(  Int(progress * 100)  )%"
             print("перерасчет пошел")
            self.layoutIfNeeded()
        }
        
    }

    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(textLabel)
        self.addSubview(countProgress)
        self.addSubview(progresBackView)
        self.addSubview(progresView)
        self.setupConstraint()
        setupGestures()
    }
    
    
    private var progresViewWidthAnchor: NSLayoutConstraint?
    
    // MARK: - Constraints
    
    private func setupConstraint() {
        
        
        
        progresViewWidthAnchor = progresView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),

            countProgress.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            countProgress.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            
            progresBackView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10),
            progresBackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            progresBackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            progresBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            progresBackView.heightAnchor.constraint(equalToConstant: 7),
            
            progresView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 10),
            progresView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            
            progresViewWidthAnchor,
//            progresView.widthAnchor.constraint(equalToConstant: 20),
            
            
            progresView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            progresView.heightAnchor.constraint(equalToConstant: 7),
            

        ].compactMap({ $0 }))
    }
    
    
}
