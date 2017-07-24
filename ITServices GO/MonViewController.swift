//
//  MonViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 15/05/17.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log
import ActiveLabel

class MonViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var caught_message: UILabel!
    @IBOutlet weak var stats: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
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
        stats.text = mon?.getStats()
        caught_message.layer.masksToBounds = true
        caught_message.layer.cornerRadius = 14
        
        
        let label = ActiveLabel()
        
        label.customize { label in
            label.text = mon?.getFact()
            label.textColor = .white
            label.numberOfLines = 0
            
            
            let gcal = ActiveType.custom(pattern: "\\sGoogle\\sCalendar?\\b") //Regex that looks for "Google Calendar?"
            let contact = ActiveType.custom(pattern: "\\scontact\\sus\\b") //Regex that looks for "contact us"
            let eduroam = ActiveType.custom(pattern: "\\sconfigure\\syour\\seduroam\\saccount\\b") //Regex that looks for "configure your eduroam account"
            let retreat = ActiveType.custom(pattern: "\\sEMBL\\sIT\\sRetreat\\b") //Regex that looks for "EMBL IT Retreat"
            let desktop = ActiveType.custom(pattern: "\\scontact\\sDesktop\\sSupport\\b") //Regex that looks for "Desktop Support"
            let beta = ActiveType.custom(pattern: "\\savailable\\sas\\sa\\sbeta\\stest\\b") //Regex that looks for "beta test"
            let search = ActiveType.custom(pattern: "\\sEMBL\\sWeb\\sSearch\\b") //Regex that looks for "EMBL Web Search"
            let calendar = ActiveType.custom(pattern: "\\sGoogle\\sCalendar\\sis\\savailable\\shere\\b") //Regex that looks for "Google Calendar"
            let signon = ActiveType.custom(pattern: "\\sSingle\\sSign-on\\b") //Regex that looks for "Single Sign-on"
            let cloud = ActiveType.custom(pattern: "\\soc.embl.de\\b") //Regex that looks for "oc.embl.de"
            let feedback = ActiveType.custom(pattern: "\\Send\\sus\\your\\sfeedback\\b") //Regex that looks for "oc.embl.de"
            
            label.enabledTypes = [.url, contact, eduroam, retreat, desktop, beta, search, calendar, signon, cloud, gcal]
            
            label.customColor[contact] = UIColor.yellow
            label.customColor[gcal] = UIColor.yellow
            label.customColor[feedback] = UIColor.yellow
            label.customColor[cloud] = UIColor.yellow
            label.customColor[eduroam] = UIColor.yellow
            label.customColor[retreat] = UIColor.yellow
            label.customColor[signon] = UIColor.yellow
            label.customColor[desktop] = UIColor.yellow
            label.customColor[beta] = UIColor.yellow
            label.customColor[search] = UIColor.yellow
            label.customColor[calendar] = UIColor.yellow
            
            label.handleCustomTap(for: contact) { element in
                self.link(url: URL(string: "mailto:itsupport@embl.de")!)
            }
            
            label.handleCustomTap(for: gcal) { element in
                self.link(url: URL(string: "http://gcal.embl.de")!)
            }
            
            label.handleCustomTap(for: feedback) { element in
                self.link(url: URL(string: "mailto:info.its@embl.de")!)
            }
            
            label.handleCustomTap(for: desktop) { element in
                self.link(url: URL(string: "mailto:itsupport@embl.de")!)
            }
            
            label.handleCustomTap(for: signon) { element in
                self.link(url: URL(string: "https://itsnews.embl.de/sso-access-to-sap-admin-services/")!)
            }
            
            label.handleCustomTap(for: eduroam) { element in
                self.link(url: URL(string: "https://intranet.embl.de/it_services/services/network_access/Wireless_Access/eduroam/index.html")!)
            }
            
            label.handleCustomTap(for: retreat) { element in
                self.link(url: URL(string: "https://intranet.embl.de/communication_outreach/internal_news/2017/170511-it-retreat/index.html")!)
            }
            
            label.handleCustomTap(for: beta) { element in
                self.link(url: URL(string: "https://saperp.embl.de/nwbc")!)
            }
            
            label.handleCustomTap(for: search) { element in
                self.link(url: URL(string: "https://itsnews.embl.de/new-embl-web-search/")!)
            }
            
            label.handleCustomTap(for: calendar) { element in
                self.link(url: URL(string: "https://intranet.embl.de/it_services/services/calendar")!)
            }
            
            label.handleCustomTap(for: cloud) { element in
                self.link(url: URL(string: "https://oc.embl.de")!)
            }
            
            
            
            
            label.handleURLTap {url in
                self.link(url: url)
            }
        }
        
        
        
        
        self.scroll.addSubview(label)
        label.bindFrameToSuperviewBounds()
        // label.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 700))
        label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300))
    }
    
    private func link(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: {
                                        (success) in
                                        print("Open iOS 10 \(success)")
            })
        } else {
            let success = UIApplication.shared.openURL(url)
            print("Open \(success)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
