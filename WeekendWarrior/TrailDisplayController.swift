//
//  TrailDisplayController.swift
//  WeekendWarrior
//
//  Created by Alana Kamahele on 2/14/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit

class TrailDisplayController: UIViewController {
    var trail = Trail(json: ["": "" as AnyObject])
    var trails = [Trail]()
    @IBOutlet weak var trailName: UILabel!
    @IBOutlet weak var trailDescription: UILabel!
    
    struct Defaults {
        
        static let Latitude: Double = 37.8267
        static let Longitude: Double = -122.423
        
    }
    
    public var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.weatherDataForLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude) { (response, error) in
            print(response)
        }
        
        trailName.text = trail.name
        trailDescription.text = trail.description
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationViewController = segue.destination as? TrailTableViewController {
            destinationViewController.userCoordinate = coordinates
            destinationViewController.trails = trails
        }
    }
    

}
