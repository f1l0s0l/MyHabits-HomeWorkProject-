//
//  ViewController.swift
//  MyHabits
//
//  Created by Илья Сидорик on 27.12.2022.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Properties

    var habitsViewController: UINavigationController!
    var infoViewController: UIViewController!
    
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        
    }
    
    
    // MARK: - Methods

    private func setupTabBar() {
        habitsViewController = UINavigationController(rootViewController: HabitsViewController())
        infoViewController = UINavigationController(rootViewController: InfoViewController())
        
        self.viewControllers = [habitsViewController, infoViewController]
        
        let item1 = UITabBarItem(title: "Hebits",
                                 image: UIImage(systemName: "square.stack.3d.down.right"), tag: 0)
        
        let item2 = UITabBarItem(title: "Info",
                                 image: UIImage(systemName: "person.crop.circle"), tag: 1)
        
        habitsViewController.tabBarItem = item1
        infoViewController.tabBarItem = item2
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        UITabBar.appearance().backgroundColor = .systemGray6
        
        
        UINavigationBar.appearance().tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = .systemGray6

        
        
    }
    


}

