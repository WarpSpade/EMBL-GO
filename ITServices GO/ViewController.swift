//
//  ViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 12/05/17.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var caught: UILabel!
    @IBOutlet weak var ITServices_badge: UILabel!
    @IBOutlet weak var blackbox: UIImageView!
    @IBOutlet weak var embldex: UIButton!
    @IBOutlet weak var option: UISegmentedControl!
    
    
    var mon = [Mon]()
    var user: User?
    var start: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        embldex.layer.masksToBounds = true
        embldex.layer.cornerRadius = 6
        
        user = loadUser()
        
        start = user?.getStartTime()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipes))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipes))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        option.selectedSegmentIndex = 1
        indexChanged(option)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedMon = loadMon() {
            mon = savedMon
        } else {
            InitMon()
        }
        saveMon()
        caught.text = "Caught: \(getCaught())/\(mon.count)"
        
        user = loadUser()
        // print((user!.getEndTime())!)
        
        if user?.getEndTime() == nil {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateClock), userInfo: nil, repeats: true)
        } else {
            updateClock()
        }
    }
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch option.selectedSegmentIndex
        {
        case 0:
            instructions.font = UIFont(name: instructions.font.fontName, size: 17)
            instructions.text = "Find and scan all of the EMBLmon posters around the ATC.\n\n" +
            "Return to the IT Services booth to claim your prize!\n\n" +
            "The fastest time will win a grand prize, so get catching!";
        case 1:
            updateClock()
        default:
            break
        }
    }
    
    @objc func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            option.selectedSegmentIndex = 1
            indexChanged(option)
        }
        
        if (sender.direction == .right) {
            option.selectedSegmentIndex = 0
            indexChanged(option)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadMon() -> [Mon]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Mon.ArchiveURL.path) as? [Mon]
    }
    
    private func loadUser() -> User {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User)!
    }
    
    private func getCaught() -> Int {
        var caught = 0
        if mon.count > 0 {
            for monster in mon {
                if monster.isFound() {
                    caught += 1
                }
            }
        }
        return caught
    }
    
    private func InitMon() {
        
        let testfact = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea"
        
        let abra_not_found = UIImage(named:"abra_silhouette")
        let abra_found = UIImage(named:"abra")
        let bulbasaur_not_found = UIImage(named:"bulbasaur_silhouette")
        let bulbasaur_found = UIImage(named:"bulbasaur")
        let chansey_not_found = UIImage(named:"chansey_silhouette")
        let chansey_found = UIImage(named:"chansey")
        let charmander_not_found = UIImage(named:"charmander_silhouette")
        let charmander_found = UIImage(named:"charmander")
        let cubone_not_found = UIImage(named:"cubone_silhouette")
        let cubone_found = UIImage(named:"cubone")
        let eevee_not_found = UIImage(named:"eevee_silhouette")
        let eevee_found = UIImage(named:"eevee")
        let flareon_not_found = UIImage(named:"flareon_silhouette")
        let flareon_found = UIImage(named:"flareon")
        let jigglypuff_not_found = UIImage(named:"jigglypuff_silhouette")
        let jigglypuff_found = UIImage(named:"jigglypuff")
        let jolteon_not_found = UIImage(named:"jolteon_silhouette")
        let jolteon_found = UIImage(named:"jolteon")
        let meowth_not_found = UIImage(named:"meowth_silhouette")
        let meowth_found = UIImage(named:"meowth")
        let mewtwo_not_found = UIImage(named:"mewtwo_silhouette")
        let mewtwo_found = UIImage(named:"mewtwo")
        let mrmime_not_found = UIImage(named:"mr_mime_silhouette")
        let mrmime_found = UIImage(named:"mr_mime")
        let onix_not_found = UIImage(named:"onix_silhouette")
        let onix_found = UIImage(named:"onix")
        let pidgey_not_found = UIImage(named:"pidgey_silhouette")
        let pidgey_found = UIImage(named:"pidgey")
        let pikachu_not_found = UIImage(named:"pikachu_silhouette")
        let pikachu_found = UIImage(named:"pikachu")
        let slowpoke_not_found = UIImage(named:"slowpoke_silhouette")
        let slowpoke_found = UIImage(named:"slowpoke")
        let squirtle_not_found = UIImage(named:"squirtle_silhouette")
        let squirtle_found = UIImage(named:"squirtle")
        let vaporeon_not_found = UIImage(named:"vaporeon_silhouette")
        let vaporeon_found = UIImage(named:"vaporeon")
        
        let charmander_stats = "The Lizard EMBLmon\n\nH: 0.6m\nW: 8.5kg\n\nRarity: Rare"
        let abra_stats = "The Psi EMBLmon\n\nH: 0.9m\nW: 19.5kg\n\nRarity: Common"
        let bulbasaur_stats = "The Seed EMBLmon\n\nH: 0.7m\nW: 6.9kg\n\nRarity: Rare"
        let chansey_stats = "The Egg EMBLmon\n\nH: 1.1m\nW: 34.6kg\n\nRarity: Common"
        let cubone_stats = "The Lonely EMBLmon\n\nH: 0.4m\nW: 6.5kg\n\nRarity: Common"
        let eevee_stats = "The Evolution EMBLmon\n\nH: 0.3m\nW: 6.5kg\n\nRarity: Rare"
        let flareon_stats = "The Flame EMBLmon\n\nH: 0.9m\nW: 25.0kg\n\nRarity: Very Rare"
        let jigglypuff_stats = "The Balloon EMBLmon\n\nH: 0.5m\nW: 5.5kg\n\nRarity: Common"
        let jolteon_stats = "The Lightning EMBLmon\n\nH: 0.8m\nW: 24.5kg\n\nRarity: Very Rare"
        let meowth_stats = "The Scratch Cat EMBLmon\n\nH: 0.4m\nW: 4.2kg\n\nRarity: Common"
        let mewtwo_stats = "The Genetic EMBLmon\n\nH: 2.0m\nW: 122.0kg\n\nRarity: Legendary"
        let mrmime_stats = "The Barrier EMBLmon\n\nH: 1.3m\nW: 54.5kg\n\nRarity: Common"
        let onix_stats = "The Rock Snake EMBLmon\n\nH: 8.8m\nW: 210.0kg\n\nRarity: Common"
        let pidgey_stats = "The Tiny Bird EMBLmon\n\nH: 0.3m\nW: 1.8kg\n\nRarity: Common"
        let pikachu_stats = "The Mouse EMBLmon\n\nH: 0.4m\nW: 6.0kg\n\nRarity: Rare"
        let slowpoke_stats = "The Dopey EMBLmon\n\nH: 1.2m\nW: 36.0kg\n\nRarity: Common"
        let squirtle_stats = "The Tiny Turtle EMBLmon\n\nH: 0.5m\nW: 9.0kg\n\nRarity: Rare"
        let vaporeon_stats = "The Bubble Jet EMBLmon\n\nH: 1.0m\nW: 29.0kg\n\nRarity: Very Rare"
        
        guard let charmander = Mon(name: "Charmichael", not_found: charmander_not_found, found: charmander_found, fact: testfact, id: "1", is_found: false, stats: charmander_stats)
            else {
                fatalError("Unable to instantiate Charmander")
        }
        guard let bulbasaur = Mon(name: "Matthiasaur", not_found: bulbasaur_not_found, found: bulbasaur_found, fact: "Fun fact", id: "2", is_found: false, stats: bulbasaur_stats)
            else {
                fatalError("Unable to instantiate Bulbasaur")
        }
        guard let squirtle = Mon(name: "Squirdan", not_found: squirtle_not_found, found: squirtle_found, fact: "Fun fact", id: "3", is_found: false, stats: squirtle_stats)
            else {
                fatalError("Unable to instantiate Squirtle")
        }
        guard let pikachu = Mon(name: "Pikablaz", not_found: pikachu_not_found, found: pikachu_found, fact: "Fun fact", id: "4", is_found: false, stats: pikachu_stats)
            else {
                fatalError("Unable to instantiate Pikachu")
        }
        guard let pidgey = Mon(name: "Pidgluca", not_found: pidgey_not_found, found: pidgey_found, fact: "Fun fact", id: "5", is_found: false, stats: pidgey_stats)
            else {
                fatalError("Unable to instantiate Pidgey")
        }
        guard let onix = Mon(name: "Jurix", not_found: onix_not_found, found: onix_found, fact: "Fun fact", id: "6", is_found: false, stats: onix_stats)
            else {
                fatalError("Unable to instantiate Onix")
        }
        guard let meowth = Mon(name: "Meowssi", not_found: meowth_not_found, found: meowth_found, fact: "Fun fact", id: "7", is_found: false, stats: meowth_stats)
            else {
                fatalError("Unable to instantiate Meowth")
        }
        guard let eevee = Mon(name: "Lilevee", not_found: eevee_not_found, found: eevee_found, fact: "Fun fact", id: "8", is_found: false, stats: eevee_stats)
            else {
                fatalError("Unable to instantiate Eevee")
        }
        guard let abra = Mon(name: "Thomabra", not_found: abra_not_found, found: abra_found, fact: "Fun fact", id: "9", is_found: false, stats: abra_stats)
            else {
                fatalError("Unable to instantiate Abra")
        }
        guard let jigglypuff = Mon(name: "Jigglywill", not_found: jigglypuff_not_found, found: jigglypuff_found, fact: "Fun fact", id: "10", is_found: false, stats: jigglypuff_stats)
            else {
                fatalError("Unable to instantiate Jigglypuff")
        }
        guard let chansey = Mon(name: "Chaso", not_found: chansey_not_found, found: chansey_found, fact: "Fun fact", id: "11", is_found: false, stats: chansey_stats)
            else {
                fatalError("Unable to instantiate Chansey")
        }
        guard let slowpoke = Mon(name: "Joaqpoke", not_found: slowpoke_not_found, found: slowpoke_found, fact: "Fun fact", id: "12", is_found: false, stats: slowpoke_stats)
            else {
                fatalError("Unable to instantiate Slowpoke")
        }
        guard let cubone = Mon(name: "Cubrich", not_found: cubone_not_found, found: cubone_found, fact: "Fun fact", id: "13", is_found: false, stats: cubone_stats)
            else {
                fatalError("Unable to instantiate Cubone")
        }
        guard let mrmime = Mon(name: "Mr Alaime", not_found: mrmime_not_found, found: mrmime_found, fact: "Fun fact", id: "14", is_found: false, stats: mrmime_stats)
            else {
                fatalError("Unable to instantiate Mr Mime")
        }
        guard let flareon = Mon(name: "Flareos", not_found: flareon_not_found, found: flareon_found, fact: "Fun fact", id: "15", is_found: false, stats: flareon_stats)
            else {
                fatalError("Unable to instantiate Flareon")
        }
        guard let jolteon = Mon(name: "Joltelo", not_found: jolteon_not_found, found: jolteon_found, fact: "Fun fact", id: "16", is_found: false, stats: jolteon_stats)
            else {
                fatalError("Unable to instantiate Joteon")
        }
        guard let vaporeon = Mon(name: "Vapagustin", not_found: vaporeon_not_found, found: vaporeon_found, fact: "Fun fact", id: "17", is_found: false, stats: vaporeon_stats)
            else {
                fatalError("Unable to instantiate Vaporeon")
        }
        guard let mewtwo = Mon(name: "Mewpert", not_found: mewtwo_not_found, found: mewtwo_found, fact: "Fun fact", id: "18", is_found: false, stats: mewtwo_stats)
            else {
                fatalError("Unable to instantiate Mewtwo")
        }
        
        mon += [abra, bulbasaur, chansey, charmander, cubone, eevee, flareon, jigglypuff, jolteon, meowth, mewtwo, mrmime, onix, pidgey, pikachu, slowpoke, squirtle, vaporeon]
    }
    
    private func saveMon() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mon, toFile: Mon.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Mon successfully saved.", log: OSLog.default, type: .error)
        } else {
            os_log("Failed to save mon...", log: OSLog.default, type: .error)
        }
        
        
    }
    
    @objc private func updateClock() {
        if option.selectedSegmentIndex == 1 {
            let start = self.start!
            let interval: Int
            if user?.getEndTime() != nil {
                interval = Int(start.timeIntervalSince((user?.getEndTime())!))
            } else {
                interval = Int(start.timeIntervalSinceNow)
            }

            let seconds = (interval % 60) * -1
            let minutes = ((interval / 60) % 60) * -1
            let hours = (interval / 3600) * -1
            instructions.font = UIFont(name: instructions.font.fontName, size: 24)
            instructions.text = "\(user!.getName())\n\n" + String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}


