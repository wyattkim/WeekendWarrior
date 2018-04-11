//
//  SearchViewController.swift
//  WeekendWarrior
//
//  Created by Wyatt Kim on 4/5/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import GooglePlaces
import AlgoliaSearch
import AFNetworking
import FirebaseAnalytics

class SearchViewController: UIViewController {

    var trails = [Trail]()
    public var userCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    @IBOutlet var trailTable: UITableView!
    var client = Client(appID: "OSWJ3BZ2RC", apiKey: "0256f1b463da714f65f61ace9d973b10")
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: false, completion: nil)
    }
    
    @IBAction func openOnlyFilter(_ sender: UIButton) {
        searchByDistance(openOnly: true)
        performSegue(withIdentifier: "openOnlySegue", sender: nil)
    }
    
    func searchByDistance(openOnly: Bool) {
        let index = client.index(withName: "alpha_trails")
        let settings = ["attributesForFaceting": ["status"], "ranking": ["geo", "filters"]]
        index.setSettings(settings)
        let query = Query(query: "")
        if userCoordinate.latitude == 0.000000 && userCoordinate.longitude == 0.000000 {
            query.aroundLatLngViaIP = true;
        } else {
            query.aroundLatLng = LatLng(lat: userCoordinate.latitude, lng: userCoordinate.longitude)
        }
        query.attributesToRetrieve = ["name", "status", "description", "objectID", "_geoloc"]
        query.hitsPerPage = 15
        query.facets = ["*"]
        if (openOnly) {
            query.filters = "(NOT status:\"Closed\") AND (NOT status:\"Temporarily Closed\") AND (NOT status:\"Unknown\")"
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

                //self.trailTable.reloadData()
                
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? TrailTableViewController {
            destinationViewController.trails = self.trails
        }
    }
 

}

extension SearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: false, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
