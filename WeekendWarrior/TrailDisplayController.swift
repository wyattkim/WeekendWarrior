//
//  TrailDisplayController.swift
//  WeekendWarrior
//
//  Created by Alana Kamahele on 2/14/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import MapKit

class TrailDisplayController: UIViewController {
    var trail = Trail(json: ["": "" as AnyObject])
    var trails = [Trail]()
    var currWeather: String = ""
    @IBOutlet weak var trailName: UILabel!
    @IBOutlet weak var trailDescription: UILabel!
    @IBOutlet weak var trailPhoto: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var weatherSummary: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    
    struct Defaults {
        
        static let Latitude: Double = 37.8267
        static let Longitude: Double = -122.423
        
    }
    
    public var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataManager.weatherDataForLocation(latitude: trail.lat!, longitude: trail.lng!) { (response, error) in
            if response != nil {
                if let weather = response {
                    DispatchQueue.main.async {
                        self.weatherSummary.text = String(describing: weather) + "°F"
                    }
                }
            }
        }
        trailName.text = trail.name
        trailDescription.text = trail.description
        trailDescription.sizeToFit()
        statusButton.setTitle(trail.status, for: .normal)
        var urlString = "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-903818595232/"
        urlString += trail.id!
        urlString += "_0.jpg"
        trailPhoto.setImageWith(NSURL(string: urlString)! as URL)
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
    
    @IBAction func directionsClicked(_ sender: UIButton) {
        tapMapfunc()
    }
    
    func tapMapfunc() {
        let latitude:CLLocationDegrees = (trail.lat)!
        let longitude:CLLocationDegrees = (trail.lng)!
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark : MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary:nil)
        let mapItem:MKMapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Target location"
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
        let currentLocationMapItem:MKMapItem = MKMapItem.forCurrentLocation()
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as? [String : Any])
        }
    
}
