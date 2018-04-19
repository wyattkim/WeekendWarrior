//
//  TrailDisplayController.swift
//  WeekendWarrior
//
//  Created by Alana Kamahele on 2/14/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import MapKit
import Lock
import Auth0
import CalendarDateRangePickerViewController
import AlgoliaSearch

class TrailDisplayController: UIViewController {
    var trail = Trail(json: ["": "" as AnyObject])
    var trails = [Trail]()
    var currUsers = [String]()
    var currentOpenStatus = true;
    var currWeather: String = ""
    @IBOutlet weak var trailName: UILabel!
    @IBOutlet weak var trailPhoto: UIImageView!
    @IBOutlet weak var trailDescription: UILabel!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var weatherSummary: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    var profile: UserInfo!
    var client = Client(appID: "OSWJ3BZ2RC", apiKey: "ed523072ded6b35b61be981768cf1659")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.weatherDataForLocation(latitude: trail.lat!, longitude: trail.lng!) { (response, error) in
            if response != nil {
                if let weather = response {
                    DispatchQueue.main.async {
                        // self.weatherSummary.text = String(describing: weather) + "°F"
                    }
                }
            }
        }
        trailName.text = trail.name
        trailDescription.text = trail.description
        let distanceString = String(trail.distance!)
        distanceLabel.text = "Distance: " + distanceString + " miles"
        difficultyLabel.text = "Difficulty: " + trail.difficulty!.lowercased()
        let elevationString = String(trail.elevation!)
        elevationLabel.text = "Elevation: " + elevationString + " feet"
        
        //  trailDescription.sizeToFit()
        statusButton.setTitle(trail.status, for: .normal)
        var urlString = "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-903818595232/"
        urlString += trail.id!
        urlString += "_0.jpg"
        trailPhoto.setImageWith(NSURL(string: urlString)! as URL)
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        let message = "Check out this trail I'd love to backpack with you on WeekendWarrior." 
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func todoButtonClicked(_ sender: Any) {
       if (profile != nil) {
            print(profile.email!)
            print(trail.id!)
            saveUserToTrail(trailId: trail.id!, userEmail: profile.email!)
        } else {
        let refreshAlert = UIAlertController(title: "Account Needed", message: "To add a trail to your to do list, please create an account!", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.showLoginController(self.statusButton)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func saveUserToTrail(trailId: String, userEmail: String) {
        let index = client.index(withName: "beta_trails")
        let settings = ["attributesForFaceting": ["objectID"]]
        index.setSettings(settings)
        let query = Query(query: "")
        
        query.attributesToRetrieve = ["users"]
        query.hitsPerPage = 15
        query.facets = ["*"]
        
        query.filters = "objectID:\"\(trailId)\""

        
        index.search(query, completionHandler: { (content, error) -> Void in
            if error == nil {
                guard let hits = content!["hits"] as? [[String: AnyObject]] else { return }
                var tmp = [Trail]()
                for hit in hits {
                    tmp.append(Trail(json: hit))
                }
  
                    if (tmp[0].users!.isEmpty) {
                        print("no users, adding this user")
                        self.currUsers.append(userEmail)
                        let obj = ["users": self.currUsers, "objectID": trailId] as [String : Any]
                        print("updating users: \(self.currUsers)")
                        index.partialUpdateObjects(
                            [obj],
                            completionHandler: { (content, error) -> Void in
                                if error == nil {
                                    print("Object IDs: \(content!)")
                                } else {
                                    print(error!)
                                }
                        }
                        )
                    } else if (tmp[0].users!.contains(userEmail)) {
                        print("already contains this user")
                        return
                    }
                    else {
                        print("has other users, adding this user")
                        self.currUsers = tmp[0].users!
                        self.currUsers.append(userEmail)
                        let obj = ["users": self.currUsers, "objectID": trailId] as [String : Any]
                        print("updating users: \(self.currUsers)")
                        index.partialUpdateObjects(
                            [obj],
                            completionHandler: { (content, error) -> Void in
                                if error == nil {
                                    print("Object IDs: \(content!)")
                                } else {
                                    print(error!)
                                }
                        }
                        )
                    }
            }
        })
    }
    
    @IBAction func showLoginController(_ sender: UIButton) {
        if (profile != nil) {
            self.performSegue(withIdentifier: "profileSegue", sender: nil)
        }
        
        Lock
            .classic()
            .withOptions {
                $0.closable = true
                $0.oidcConformant = true
                $0.passwordManager.enabled = false
            }
            .withStyle {
                $0.title = "Weekend Warrior"
                $0.logo = LazyImage(name: "AppIcon")
            }
            .onAuth {
                print("Obtained credentials \($0)")
                //self.accessToken = $0.accessToken!
                Auth0
                    .authentication()
                    .userInfo(withAccessToken: $0.accessToken!)
                    .start { result in
                        switch result {
                        case .success(let profile):
                            // You've got a UserProfile object
                            print(profile.email!)
                            self.profile = profile
                            print("profile email set")
                            self.performSegue(withIdentifier: "profileSegue", sender: nil)
                            
                        case .failure(let error):
                            // You've got an error
                            print("Failed with \(error)")
                        }
                }
            }
            .onError {
                print("Failed with \($0)")
            }
            .onCancel {
                print("User cancelled")
            }
            .present(from: self)
    }
    
    struct Defaults {
        
        static let Latitude: Double = 37.8267
        static let Longitude: Double = -122.423
        
    }
    
    @IBAction func weatherPressed(_ sender: Any) {
        let lat = String(format:"%f", trail.lat!)
        let lng = String(format:"%f", trail.lng!)
        if let url = URL(string: "https://forecast.weather.gov/MapClick.php?site=twc&textField1=" + lat + "&textField2=" + lng + "#.Ws14QNPwaHp") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    public var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationViewController = segue.destination as? TrailTableViewController {
            destinationViewController.coordinates = coordinates
            destinationViewController.trails = trails
            destinationViewController.profile = self.profile
        }
        
        if let destinationViewController = segue.destination as? ProfileViewController {
            destinationViewController.email = self.profile.email
            destinationViewController.trail = self.trail
            destinationViewController.profile = self.profile
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
