//
//  MainTabBarViewController.swift
//  SevenSheep
//
//  Created by Douglas Labbe on 11/10/18.
//  Copyright © 2018 Oh Baby Consulting, LLC. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.unselectedItemTintColor = UIColor(named: "peach")
    }

}
