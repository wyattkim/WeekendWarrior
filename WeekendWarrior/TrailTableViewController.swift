//
//  TrailTableViewController.swift
//  WeekendWarrior
//
//  Created by Wyatt Kim on 2/6/18.
//
import UIKit
import AWSAuthUI
import AWSAuthCore
import AWSDynamoDB
import CSV
import CoreLocation
import AlgoliaSearch

@objc class TrailTableViewController: UITableViewController {
    //MARK: Properties
    var trails = [Trail]()
    public var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    @IBOutlet var trailTable: UITableView!
    var client = Client(appID: "OSWJ3BZ2RC", apiKey: "0256f1b463da714f65f61ace9d973b10")
    
    
    override func viewDidLoad() {
        print("lat: \(userCoordinate.latitude) lng: \(userCoordinate.longitude)")
        
        searchByDistance()
        
        super.viewDidLoad()
        
        trailTable.delegate = self
        trailTable.dataSource = self
    }
    
    func searchByDistance() {
        let index = client.index(withName: "test_trails")
        let settings = ["searchableAttributes": ["name", "status"], "ranking": ["geo", "words"]]
        index.setSettings(settings)
        let query = Query(query: "")
        query.aroundLatLng = LatLng(lat: userCoordinate.latitude, lng: userCoordinate.longitude)
        query.attributesToRetrieve = ["name", "status", "description"]
        query.hitsPerPage = 10
        index.search(query, completionHandler: { (content, error) -> Void in
            if error == nil {
                print("Result: \(content!)")
                guard let hits = content!["hits"] as? [[String: AnyObject]] else { return }
                var tmp = [Trail]()
                for hit in hits {
                    tmp.append(Trail(json: hit))
                }
                self.trails = tmp
                self.trailTable.reloadData()
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
        
        cell.nameLabel.text = trail.name
        cell.statusLabel.text = trail.status
        cell.difficultyLabel.text = "Temp Difficulty"
        cell.distanceLabel.text = "Temp Distance"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrail = trails[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let testController = storyboard.instantiateViewController(withIdentifier :"TrailDisplayController") as! TrailDisplayController
        testController.trail = selectedTrail
        testController.coordinates = userCoordinate
        self.present(testController, animated: true)
    }
    
    //    private func calculateDistance(trailCoordinates: CLLocationCoordinate2D) -> Float {
    //        let trailLocation = CLLocation(latitude: trailCoordinates.latitude, longitude: trailCoordinates.longitude)
    //        let userLocation = CLLocation(latitude: self.userCoordinate.latitude, longitude: self.userCoordinate.longitude)
    //
    //        print("trail: \(trailLocation)")
    //        print("user loc: \(userLocation)")
    //
    //        let distanceInMiles = userLocation.distance(from: trailLocation) * 0.000621371
    //        return Float(distanceInMiles)
    //    }
    
    //    private func readSampleTrail() {
    //        for index in 0...50 {
    //            let queryExpression = AWSDynamoDBQueryExpression()
    //            queryExpression.keyConditionExpression = "#trailId = :trailId"
    //
    //            queryExpression.expressionAttributeNames = [
    //                "#trailId": "trailId"
    //            ]
    //            queryExpression.expressionAttributeValues = [
    //                ":trailId": "\(index)"
    //            ]
    //
    //            let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    //
    //            dynamoDbObjectMapper.query(Trail.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
    //                if error != nil {
    //                    print("The request failed. Error: \(String(describing: error))")
    //                }
    //                if output != nil {
    //                    for news in output!.items {
    //                        let newsItem = news as? Trail
    //                        self.trails += [newsItem!];
    //
    //                        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(newsItem!._longitude!), CLLocationDegrees(newsItem!._latitude!))
    //                                let distance = self.calculateDistance(trailCoordinates: coordinate)
    //                                print("name: \(newsItem!._name!)")
    //                                print("trailId: \(newsItem!._trailId!)")
    //                                print("distance: \(distance)")
    //
    //                                if distance <= 200.0 {
    //                                    DispatchQueue.main.async {
    //                                        self.trailTable.reloadData()
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
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
