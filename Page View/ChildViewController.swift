//
//  ChildViewController.swift
//  Page View
//
//  Created by MAC on 19/11/19.
//  Copyright © 2019 frzy. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    
    var number: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = number.description
    }
    
}
