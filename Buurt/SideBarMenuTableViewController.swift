//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class SideBarMenuController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FeedSegue") {
            let navigationVC = segue.destination as? UINavigationController
            let destinationVC = navigationVC?.viewControllers.first as! MainViewController
            destinationVC.viewFunction = "feed"
        }
        if (segue.identifier == "FollowSegue") {
            let navigationVC = segue.destination as? UINavigationController
            let destinationVC = navigationVC?.viewControllers.first as! MainViewController
            destinationVC.viewFunction = "follow"
        }
        if (segue.identifier == "MyMentionsSegue") {
            let navigationVC = segue.destination as? UINavigationController
            let destinationVC = navigationVC?.viewControllers.first as! MainViewController
            destinationVC.viewFunction = "mymentions"
        }

    }
}
