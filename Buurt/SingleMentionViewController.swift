//
//  SingleMentionViewController.swift
//  Buurt
//
//  Created by Martijn de Jong on 13-01-17.
//  Copyright © 2017 Martijn de Jong. All rights reserved.
//

import UIKit

class SingleMentionViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = currentInfo.selectedMention["titel"] as! String?
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
