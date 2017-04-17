//
//  TabBarViewController.swift
//  PrimeraApp
//
//  Created by Marko Aras on 17/04/2017.
//  Copyright © 2017 fer. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: HomeViewController())
    let standingsVC = UINavigationController(rootViewController: StandingsViewController())
    


    override func viewDidLoad() {
        super.viewDidLoad()

        let viewControllers:[UIViewController] = [homeVC, standingsVC]

        //set view controllers for tabbar
        self.setViewControllers(viewControllers, animated: false)
        
        //configure tabbar items
        let homeImage = UIImage(named: "homeImage")?.withRenderingMode(.alwaysOriginal)
        let homeSelectedImage = UIImage(named: "homeImageSelected")?.withRenderingMode(.alwaysOriginal)
        let firstTabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeSelectedImage)
        firstTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4)
        firstTabBarItem.tag = 1
        homeVC.tabBarItem = firstTabBarItem
        
        let standingsImage = UIImage(named: "standingsImage")?.withRenderingMode(.alwaysOriginal)
        let standingsSelectedImage = UIImage(named: "standingsImageSelected")?.withRenderingMode(.alwaysOriginal)
        let secondTabBarItem = UITabBarItem(title: "Standings", image: standingsImage, selectedImage: standingsSelectedImage)
        secondTabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4)
        secondTabBarItem.tag = 2
        standingsVC.tabBarItem = secondTabBarItem
        

    }

}
