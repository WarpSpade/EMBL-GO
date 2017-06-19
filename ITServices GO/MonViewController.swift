//
//  MonViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 15/05/17.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log

class MonViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var caught_message: UILabel!
    @IBOutlet weak var black: UIImageView!
    @IBOutlet weak var stats: UILabel!
    @IBOutlet weak var fact: UILabel!
    
    var mon: Mon?
    var just_found = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image.image = (mon?.getFoundImage())!
        if (just_found){
                caught_message.text = "You caught a \(mon!.getName())!"
        } else {
            caught_message.text = "\(mon!.getName())"
        }
        fact.text = mon?.getFact()
        stats.text = mon?.getStats()
        caught_message.layer.masksToBounds = true
        caught_message.layer.cornerRadius = 14
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
