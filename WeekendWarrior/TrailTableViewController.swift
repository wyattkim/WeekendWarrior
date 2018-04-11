//
//  TrailTableViewController.swift
//  WeekendWarrior
//
//  Created by Wyatt Kim on 2/6/18.
//
import UIKit
import CSV
import CoreLocation
import AlgoliaSearch
import AFNetworking
import FirebaseAnalytics
import SafariServices



@objc class TrailTableViewController: UITableViewController {
    //MARK: Properties
    var trails = [Trail]()
    public var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    @IBOutlet var trailTable: UITableView!
    var currentOpen = false;
    var client = Client(appID: "OSWJ3BZ2RC", apiKey: "0256f1b463da714f65f61ace9d973b10")
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var changeLocation: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (trails.isEmpty) {
            searchByDistance(openOnly: false)
        }
        
        trailTable.delegate = self
        trailTable.dataSource = self
    }
    
    @IBAction func callSelected(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://1234567890")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        // only works on an actualy phone :(
    }
    
    @IBAction func openButtonPressed(_ sender: Any) {
        self.currentOpen = !currentOpen;
        self.searchByDistance(openOnly:currentOpen);
    }
    
    func searchByDistance(openOnly: Bool) {
        let index = client.index(withName: "beta_trails")
        let settings = ["attributesForFaceting": ["status"], "ranking": ["geo", "filters"]]
        index.setSettings(settings)
        let query = Query(query: "")
        if userCoordinate.latitude == 0.000000 && userCoordinate.longitude == 0.000000 {
            query.aroundLatLngViaIP = true;
        } else {
            query.aroundLatLng = LatLng(lat: userCoordinate.latitude, lng: userCoordinate.longitude)
        }
        query.attributesToRetrieve = ["name", "status", "description", "objectID", "_geoloc", "distance", "elevation", "number", "type", "difficulty"]
        query.hitsPerPage = 15
        query.facets = ["*"]
        if (openOnly) {
            query.filters = "(NOT status:\"Closed\") AND (NOT status:\"Temporarily Closed\") AND (NOT status:\"None\")"
        }
        query.getRankingInfo = true

        index.search(query, completionHandler: { (content, error) -> Void in
            if error == nil {
                guard let hits = content!["hits"] as? [[String: AnyObject]] else { return }
                Analytics.logEvent(AnalyticsEventSearch, parameters: [
                    AnalyticsParameterSearchTerm: "lat: \(String(self.userCoordinate.latitude)), lng: \(String(self.userCoordinate.longitude))"
                    ])
                var tmp = [Trail]()
                for hit in hits {
                    tmp.append(Trail(json: hit))
                }
                self.trails = tmp
                DispatchQueue.main.async {
                    self.trailTable.reloadData()
                }
            }
        })
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
        
        // Fetches the appropriate trail for the data source layout.
        let trail = trails[indexPath.row]
        /*if(indexPath.row%2 == 0){
            cell.backgroundColor = UIColor(red: 146.0/255, green: 215.0/255, blue: 234.0/255, alpha: 0.6)
        }
        else{
            cell.backgroundColor = UIColor(red: 146.0/255, green: 215.0/255, blue: 234.0/255, alpha: 0.3)
        } */
        cell.nameLabel.text = trail.name
        cell.statusLabel.text = trail.status
        if (trail.status == "None"){
            cell.statusLabel.textColor = UIColor.black
            cell.statusLabel.text = "Unknown"
        } else if (trail.status == "Closed") {
            cell.statusLabel.textColor = UIColor.red
        } else if (trail.status == "Open") {
            cell.statusLabel.textColor = UIColor.green
        } else if (trail.status == "Temporarily Closed") {
            cell.statusLabel.textColor = UIColor.red
        }
        var urlString = "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-903818595232/"
        urlString += trail.id!
        urlString += "_0.jpg"
        cell.photoImageView.setImageWith(NSURL(string: urlString)! as URL)
        cell.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.photoImageView.layer.cornerRadius = 5
        cell.photoImageView.layer.borderWidth = 8
        cell.photoImageView.layer.borderColor = UIColor.white.cgColor
        cell.photoImageView.backgroundColor = UIColor.white
        cell.photoImageView.layer.masksToBounds = true
        let distanceString = String(trail.distance!)
        cell.distanceLabel.text = "Distance: " + distanceString + " miles"
        cell.difficultyLabel.text = "Difficulty: " + trail.difficulty!.lowercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrail = trails[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let testController = storyboard.instantiateViewController(withIdentifier :"TrailDisplayController") as! TrailDisplayController
        testController.trail = selectedTrail
        testController.coordinates = userCoordinate
        testController.trails = trails
        self.present(testController, animated: true)
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
}
