//
//  HabitsViewController.swift
//  MyHabits
//
//Created by Илья Сидорик on 27.12.2022.
//

import UIKit

class HabitsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 200)
        layout.minimumLineSpacing = 12
        return layout
    }()
    
    
    private lazy var collecrionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCollectionViewCellID")
        collectionView.register(ProgresHabitCollectionViewCell.self, forCellWithReuseIdentifier: "ProgresHabitCollectionViewCellID")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray5
        return collectionView
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collecrionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    // MARK: - Methods

    private func setupView() {
        self.view.backgroundColor = .systemGray6
        self.view.addSubview(collecrionView)
        self.setupNavigationBar()
        self.setupConstraints()
    }
    

    private func setupNavigationBar() {
        let addHabitsBarButtonItem: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.tintColor = UIColor(red: 161/225, green: 22/225, blue: 204/225, alpha: 1)
            button.imageView?.contentMode = .scaleAspectFill
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.addTarget(self, action: #selector(presentHabitVC), for: .touchUpInside)
            let addHabitsBarItem = UIBarButtonItem(customView: button)
            return addHabitsBarItem
        }()
        self.navigationItem.rightBarButtonItem = addHabitsBarButtonItem
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Сегодня"
    }
    @objc
    private func presentHabitVC() {
        let habitViewController = HabitViewController()
        habitViewController.setupTitle(with: "Создать")
        habitViewController.delegate = self
        let vc = UINavigationController(rootViewController: habitViewController)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collecrionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collecrionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collecrionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collecrionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}


    // MARK: - ExtensionUICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return HabitsStore.shared.habits.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgresHabitCollectionViewCellID", for: indexPath) as? ProgresHabitCollectionViewCell else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                    return cell
            }
            
            cell.layer.cornerRadius = 8
            cell.setup()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCollectionViewCellID", for: indexPath) as? HabitCollectionViewCell else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                return cell
            }
            
            cell.setup(habit: HabitsStore.shared.habits[indexPath.item], indexInArray: indexPath.item)
            cell.delegate = self
            cell.layer.cornerRadius = 8
            return cell
        }
    }
    
}


    // MARK: - ExtensionUICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 16, bottom: 18, right: 16)
        }
        
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let habitDetailsViewController = HabitDetailsViewController()
            habitDetailsViewController.setup(index: indexPath.item)
            habitDetailsViewController.delegate = self
            navigationController?.pushViewController(habitDetailsViewController, animated: true)
        }
    }
   
}


    // MARK: - ExtensionHabitViewControllerDelegate

extension HabitsViewController: HabitViewControllerDelegate {
    
    func saveHabit(habit: Habit, isCreateHabit: Bool, isChangeHabit: Bool, isChangeTrackHabit: Bool, isRemoveHabit: Bool, indexInArrayHabits: Int) {
        
//        print("Вызов делегата в HabitsViewController")
        
        
        if isCreateHabit {
            HabitsStore.shared.habits.insert(habit, at: 0)
            collecrionView.insertItems(at: [IndexPath(item: 0, section: 1)])
            collecrionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        if isChangeHabit {
            HabitsStore.shared.habits[indexInArrayHabits] = habit
            collecrionView.reloadItems(at: [IndexPath(item: indexInArrayHabits, section: 1)])
        }
        
        if isChangeTrackHabit {
            HabitsStore.shared.track(habit)
            collecrionView.reloadItems(at: [IndexPath(item: indexInArrayHabits, section: 1)])
            collecrionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        if isRemoveHabit {
//            print("Произошло удаление привычки")
            HabitsStore.shared.habits.removeAll(where: {$0 == habit})
            collecrionView.deleteItems(at: [IndexPath(item: indexInArrayHabits, section: 1)])
            collecrionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
}
