//
//  MonTableViewController.swift
//  ITServices GO
//
//  Created by Thomas Hunt on 15/05/17.
//  Copyright © 2017 EMBL. All rights reserved.
//

import UIKit
import os.log

class MonTableViewController: UITableViewController {
    
    var mon = [Mon]()
    var alertController = UIAlertController(title: "You haven't found this EMBLmon yet.", message: "", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedMon = loadMon() {
            mon += savedMon
        } else {
            // Load the pokemon
            InitMon()
        }
        
        //Create alert
        let OKAction = UIAlertAction(title: "OK I'll find it!", style: .default)
        alertController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mon.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MonTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MonTableViewCell else {
            fatalError("The dequeued cell is not an instance of MonTableViewCell.")
        }
        let monster = mon[indexPath.row]

        if monster.isFound() {
            cell.nameLabel.text = monster.getName()
            cell.photoImageView.image = monster.getFoundImage()
        } else {
            cell.nameLabel.text = "?????"
            cell.photoImageView.image = monster.getNotFoundImage()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Caught: 0/14"
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monster = mon[indexPath.row]
        if monster.isFound() {
            // Segue to the second view controller
            self.performSegue(withIdentifier: "showDetail", sender: self)
        } else {
            self.present(alertController, animated: true)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let monDetailViewController = segue.destination as? MonViewController
            else {
                fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let selectedMonCell = sender as? MonTableViewCell else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedMonCell) else {
            fatalError("The cell is not being displayed by the table")
        }
        
        let selectedMon = mon[indexPath.row]
        monDetailViewController.mon = selectedMon
        
    }
    
    //MARK: Private Methods
    
    private func InitMon() {
        
        let bulbPhoto = UIImage(named:"bulb")
        
        guard let bulb = Mon(name: "Bulbasaur", not_found: bulbPhoto, found: bulbPhoto, fact: "Fun fact", map_coords: (0, 0), id: "1", is_found: false)
            else {
                fatalError("Unable to instantiate Bulbasaur")
        }
        mon += [bulb]
    }
    
    private func foundMonWith(Id: String){
        let monster = getMonWith(Id: Id)!
        monster.setFound(found: true)
        saveMon()
    }
    
    private func loadMon() -> [Mon]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Mon.ArchiveURL.path) as? [Mon]
    }
    
    private func saveMon() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mon, toFile: Mon.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Mon successfully saved.", log: OSLog.default, type: .error)
        } else {
            os_log("Failed to save mon...", log: OSLog.default, type: .error)
        }
    }
    
    private func getMonWith(Id: String) -> Mon?{
        for monster in mon {
            if monster.getId() == Id {
                return monster
            }
        }
        return nil
    }
}
