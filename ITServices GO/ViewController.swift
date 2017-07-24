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
        
    
    }
    
   
    @IBAction func leaderboard(_ sender: UIButton) {
        let url = URL(string: "https://labday01.embl.de/Leaderboard/leaderboard.html")
        if #available(iOS 10, *) {
            UIApplication.shared.open(url!, options: [:],
                                      completionHandler: {
                                        (success) in
                                        print("Open iOS 10 \(success)")
            })
        } else {
            let success = UIApplication.shared.openURL(url!)
            print("Open \(success)")
        }
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
        
        if(getCaught() == 18){
            option.selectedSegmentIndex = 0
            print("winner")
        } else {
            option.selectedSegmentIndex = 1
            print("not yet")
            print(String(getCaught()))
        }
        
        indexChanged(option)
    }
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch option.selectedSegmentIndex
        {
        case 0:
            instructions.font = UIFont(name: instructions.font.fontName, size: 17)
            if( getCaught() == 18) {
                instructions.text = "Congratulations, you caught them all! \n Return to the IT Services booth to see if you have won a prize."
            } else {
                instructions.text = "Find and scan all of the EMBLmon posters around the ATC.\n\n" +
                    "Return to the IT Services booth to claim your prize!\n\n" +
                "The fastest time will win a grand prize, so get catching!";
            }
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
        
        let charmander_fact = "Nickname: Michael Wahlers \n\nDid you know that SAP Admin Services now uses EMBL Single Sign-on? Currently available as a beta test, you can now sign into SAP using your local EMBL site credentials and no longer need to remember a separate password to access the SAP time sheets, leave requests, shopping carts, etc. Visit the IT Services stand today to explore how simple it is. While the beta test was recently announced in Heidelberg, users at other EMBL sites are welcome and encouraged to try."
        
        let bulbasaur_fact = "Nickname: Matthias Helmling \n\nDid you know that every user of EMBL ownCloud now has up to 50GB of free storage available to them? EMBL ownCloud now has over 1100 active users, with 1.2 million files shared. Don't have an account yet? Share stuff with others inside and outside of EMBL by signing up at oc.embl.de. If you are not from EMBL Heidelberg you can still get an account just contact us at itsupport@embl.de."
        
        let squirtle_fact = "Nickname: Daniel Anderson \n\nHave you heard about the EMBL 3D cloud? Based on high-performance graphics and visualisation power that is accessible from the Heidelberg data centre, it can support your QA, data analysis on-demand, anywhere and in a cost-efficient way. To learn more contact us at IT Services."
        
        let pikachu_fact = "Nickname: Blaz Podrzaj \n\nDid you know that you can connect to eduroam WiFi when travelling to one of the many eduroam partner sites world-wide? Just configure your eduroam account while on-site at EMBL and enjoy easy Internet access while being away! Likewise, if you're visiting from another eduroam participating institution, you easily can access WiFi here."
        
        let pidgey_fact = "Nickname: Luca Fasolino \n\nDo you know your IT Services? We consist of three teams - IT Operations, Desktop Support, and Software & Solutions Development. IT Operations takes care of the data centre and IT infrastructure for daily use, access to emails, and high-performance computing. Desktop Support provides assistance for the three major operating systems (Windows, Mac, and Linux), installs OS and software and helps troubleshooting hardware or software problems. Software and Solutions Development are in charge of custom software development involving mainly administrative web apps, the infrastructure for the EMBL web presence and our central databases."
        
        let onix_fact = "Nickname: Jurij Pecar \n\nDid you know High Performance Computing at EMBL Heidelberg is quite popular across science? More than 200 users from groups at EMBL Heidelberg as well as those from other EMBL sites are using the EMBL HPC Cluster which currently has about 13,000 CPU cores, 70+TB of RAM and access to an ultrafast parallel file system."
        
        let meowth_fact = "Nickname: Massimiliano Ceccarelli \n\nWe've been working hard to make our data centre and EMBL core IT services resilient. Our business continuity strategy builds on a second data centre hosting a hot-standby server virtualisation cluster and a copy of cross-centre mirrored data storage. This constantly developed infrastructure helps us to prevent and  limit downtime for priority IT services such as network, WiFi, authentication, email and web in case of disasters and major issues with our primary data centre."
        
        let eevee_fact = "Nickname: Lilian Lopez \n\nBack in March, all 4 IT departments from across EMBL came together for an EMBL IT Retreat here in Heidelberg to foster cross-site collaboration, knowledge exchange and exploring joint projects along a coherent IT strategy. Key topics discussed included simplified access to IT resources shared across EMBL, establishing networking standards or cross-site disaster recovery. The meeting was very successful and we hope that it results in improvements of the IT services we provide to you, our users."
        
        let abra_fact = "Nickname: Thomas von Kiedrowski \n\nIs your Windows computer protected from malware threats? If your computer doesn't have any anti-virus protection installed, IT Services can install Kaspersky Anti-Virus for you – free of charge and even if you use a private computer for your work at EMBL. For more details, contact Desktop Support."
        
        let jigglypuff_fact = "Nickname: William Murphy \n\nEMBL email recently was made much faster and more reliable! The EMBL email service is now powered by SSD disk and is being mirrored across two data centres for better resilience."
        
        let chansey_fact = "Nickname: Vasiliki Karyoti \n\nDid you know that users across EMBL have access to Google Calendar? Visit gcal.embl.de/it/fr... (depending on your EMBL site), enter your local EMBL site username and password and start managing your calendar, contacts, tasks and notes in one place. Share calendars with colleagues or people outside EMBL, synchronize with your phone or computer, reserve a room or lab equipment. More information on Google Calendar is available here."
        
        let slowpoke_fact = "Nickname: Joaquim Manuel Raposo Batista \n\nHave you heard about the Computer Training Lab? This facility, located in the ATC is available to use for training courses. IT Services supports setting up training courses with different operating systems, and - based on properly communicated requirements - with software tailored on-demand. For more information contact Desktop Support."
        
        let cubone_fact = "Nickname: Erich Schechinger \n\nIT Services has been working hard configuring the IT setup for the new EMBL Barcelona site. So far, the internal network, the firewalls and a 1Gb Internet link have been established, which will be increased to a 10Gb link soon. The domain, web page, and user management are also up. Next up, data storage, virtualisation and compute will be configured. From all in IT Services, we want to give a warm welcome to EMBL Barcelona, and wish them a big success!"
        
        let mrmime_fact = "Nickname: Alain Becam \n\nYou'd need over 745 million floppy disks to store a single petabyte of data. Right now, our data centre can store around 25 petabytes of data on a multi-tiered data storage infrastructure using disk and tape technology."
        
        let flareon_fact = "Nickname: Carlos Fernandez \n\nDid you know that EMBL's data centre is virtualised? The team currently operates 450 virtual servers based on 3 VM clusters with a total of 600 CPU Cores and 6TB of RAM, and we use VMware vSphere and VMware Horizon. The main benefits of data centre virtualisation are around manageability, resilience and cost savings in energy and space."
        
        let jolteon_fact = "Nickname: Carmelo Lopez-Portilla \n\nHave you heard about the viruses WannaCry and Petya? Although EMBL was not affected due to security in place it is important to protect yourself for any future outbreaks. \n Back up your data regularly! (consider centrally backed-up data storage such as Tier-1 or ownCloud), upgrade your Operating System and update your software to the most recent versions, use anti-virus protection, delete suspicious emails and don’t use USB sticks of unknown origin. If in doubt, contact us at IT Services for advice."
        
        let vaporeon_fact = "Nickname: Agustin Villalba Casas \n\nHave you heard about the new and improved EMBL Web Search? Based on ElasticSearch and search engine technology from Google it is not only faster and more accurate, but also much more user friendly. Don't believe us? Try it out on the intranet or on the EMBL external site. Send us your feedback."
        
        let mewtwo_fact = "Nickname: Rupert Lueck \n\nDid you know that IT Services has three trainees? Thomas, Jason and Deirdre worked together to create this app for both Android and iPhone."
        
        
        
        
        guard let charmander = Mon(name: "Charmichael", not_found: charmander_not_found, found: charmander_found, fact: charmander_fact, id: "964", is_found: false, stats: charmander_stats)
            else {
                fatalError("Unable to instantiate Charmander")
        }
        guard let bulbasaur = Mon(name: "Matthiasaur", not_found: bulbasaur_not_found, found: bulbasaur_found, fact: bulbasaur_fact, id: "823", is_found: false, stats: bulbasaur_stats)
            else {
                fatalError("Unable to instantiate Bulbasaur")
        }
        guard let squirtle = Mon(name: "Squidan", not_found: squirtle_not_found, found: squirtle_found, fact: squirtle_fact, id: "728", is_found: false, stats: squirtle_stats)
            else {
                fatalError("Unable to instantiate Squirtle")
        }
        guard let pikachu = Mon(name: "Pikablaz", not_found: pikachu_not_found, found: pikachu_found, fact: pikachu_fact, id: "38", is_found: false, stats: pikachu_stats)
            else {
                fatalError("Unable to instantiate Pikachu")
        }
        guard let pidgey = Mon(name: "Pidgluca", not_found: pidgey_not_found, found: pidgey_found, fact: pidgey_fact, id: "741", is_found: false, stats: pidgey_stats)
            else {
                fatalError("Unable to instantiate Pidgey")
        }
        guard let onix = Mon(name: "Jurix", not_found: onix_not_found, found: onix_found, fact: onix_fact, id: "581", is_found: false, stats: onix_stats)
            else {
                fatalError("Unable to instantiate Onix")
        }
        guard let meowth = Mon(name: "Meowssi", not_found: meowth_not_found, found: meowth_found, fact: meowth_fact, id: "562", is_found: false, stats: meowth_stats)
            else {
                fatalError("Unable to instantiate Meowth")
        }
        guard let eevee = Mon(name: "Lilevee", not_found: eevee_not_found, found: eevee_found, fact: eevee_fact, id: "664", is_found: false, stats: eevee_stats)
            else {
                fatalError("Unable to instantiate Eevee")
        }
        guard let abra = Mon(name: "Thomabra", not_found: abra_not_found, found: abra_found, fact: abra_fact, id: "82", is_found: false, stats: abra_stats)
            else {
                fatalError("Unable to instantiate Abra")
        }
        guard let jigglypuff = Mon(name: "Jigglywill", not_found: jigglypuff_not_found, found: jigglypuff_found, fact: jigglypuff_fact, id: "481", is_found: false, stats: jigglypuff_stats)
            else {
                fatalError("Unable to instantiate Jigglypuff")
        }
        guard let chansey = Mon(name: "Chaso", not_found: chansey_not_found, found: chansey_found, fact: chansey_fact, id: "319", is_found: false, stats: chansey_stats)
            else {
                fatalError("Unable to instantiate Chansey")
        }
        guard let slowpoke = Mon(name: "Joaqpoke", not_found: slowpoke_not_found, found: slowpoke_found, fact: slowpoke_fact, id: "970", is_found: false, stats: slowpoke_stats)
            else {
                fatalError("Unable to instantiate Slowpoke")
        }
        guard let cubone = Mon(name: "Curich", not_found: cubone_not_found, found: cubone_found, fact: cubone_fact, id: "888", is_found: false, stats: cubone_stats)
            else {
                fatalError("Unable to instantiate Cubone")
        }
        guard let mrmime = Mon(name: "Mr Malain", not_found: mrmime_not_found, found: mrmime_found, fact: mrmime_fact, id: "161", is_found: false, stats: mrmime_stats)
            else {
                fatalError("Unable to instantiate Mr Mime")
        }
        guard let flareon = Mon(name: "Flarlos", not_found: flareon_not_found, found: flareon_found, fact: flareon_fact, id: "457", is_found: false, stats: flareon_stats)
            else {
                fatalError("Unable to instantiate Flareon")
        }
        guard let jolteon = Mon(name: "Joltelo", not_found: jolteon_not_found, found: jolteon_found, fact: jolteon_fact, id: "905", is_found: false, stats: jolteon_stats)
            else {
                fatalError("Unable to instantiate Joteon")
        }
        guard let vaporeon = Mon(name: "Vaporgustin", not_found: vaporeon_not_found, found: vaporeon_found, fact: vaporeon_fact, id: "225", is_found: false, stats: vaporeon_stats)
            else {
                fatalError("Unable to instantiate Vaporeon")
        }
        guard let mewtwo = Mon(name: "Mewpert", not_found: mewtwo_not_found, found: mewtwo_found, fact: mewtwo_fact, id: "961", is_found: false, stats: mewtwo_stats)
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


