//
//  TrailTableViewController.swift
//  WeekendWarrior
//
//  Created by Wyatt Kim on 2/6/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import AWSDynamoDB

class TrailTableViewController: UITableViewController {
    //MARK: Properties
    var trails = [Trail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTrails()
        
        //createSampleTrail()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TrailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrailTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TrailTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let trail = trails[indexPath.row]
        
        cell.nameLabel.text = trail._name
        cell.statusLabel.text = trail._status
        cell.distanceLabel.text = "\(trail._latitude) + \(trail._longitude)"
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Private methods
    private func loadSampleTrails() {
//        let photo1 = UIImage(named: "mtWhitneyPhoto")
//        let photo2 = UIImage(named: "transCatalinaTrailPhoto")
//        let photo3 = UIImage(named: "sykesHotSpringsPhoto")
        
//        guard let trail1 = Trail(name: "Mt. Whitney", status: "Open", difficulty: "Medium", location: "11.1 miles away") else {
//            fatalError("Unable to instantiate trail1")
//        }
//        guard let trail2 = Trail(name: "Trans-Catalina Trail", status: "Open", difficulty: "Easy", location: "23.3 miles away") else {
//            fatalError("Unable to instantiate trail2")
//        }
//        guard let trail3 = Trail(name: "Sykes Hot Springs", status: "Closed", difficulty: "Hard", location: "6.2 miles away") else {
//            fatalError("Unable to instantiate trail3")
//        }
        
//        trails += [trail1, trail2, trail3]
    }
    
//    private func createSampleTrail() {
//        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
//
//        let sampleTrail: Trail = Trail(userId: "admin", difficulty: "Easy", equipmentInfo: "None", location: "500 miles way", name: "Tennessee Valley Trail", permitInfo: "None", status: "Open", trailId: "0")
//
//        dynamoDbObjectMapper.save(sampleTrail, completionHandler: {
//            (error: Error?) -> Void in
//            if let error = error {
//                print("AWS DynamoDB save error: \(error)")
//                return
//            }
//            print("A trail was saved")
//        })
//    }
}
