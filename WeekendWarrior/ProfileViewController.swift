//
//  ProfileViewController.swift
//  WeekendWarrior
//
//  Created by Wyatt Kim on 4/10/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import Lock
import Auth0
import AlgoliaSearch

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    public var email: String!
    var trail = Trail(json: ["": "" as AnyObject])
    var profile: UserInfo!
    @IBOutlet weak var savedTrailLabel: UILabel!
    var client = Client(appID: "OSWJ3BZ2RC", apiKey: "0256f1b463da714f65f61ace9d973b10")
    var savedTrails = [Trail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getSavedTrails(userEmail: self.profile.email!)
        
        // Do any additional setup after loading the view.
    }
    
    func getSavedTrails(userEmail: String) {
        let index = client.index(withName: "beta_trails")
        let settings = ["attributesForFaceting": ["users"]]
        index.setSettings(settings)
        let query = Query(query: "")

        query.attributesToRetrieve = ["name", "status", "description", "objectID", "_geoloc", "distance", "elevation", "number", "type", "difficulty"]
        query.hitsPerPage = 15
        query.facets = ["*"]
        
        query.filters = "users:\"\(userEmail)\""
        
        index.search(query, completionHandler: { (content, error) -> Void in
            if error == nil {
                guard let hits = content!["hits"] as? [[String: AnyObject]] else { return }
                var tmp = [Trail]()
                for hit in hits {
                    tmp.append(Trail(json: hit))
                }
                self.savedTrails = tmp
                if (!self.savedTrails.isEmpty) {
                    DispatchQueue.main.async {
                    self.savedTrailLabel.text = self.savedTrails[0].name!
                    }
                    for trail in self.savedTrails {
                        print(trail.name!)
                    }
                }

            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? TrailDisplayController {
            destinationViewController.trail = self.trail
            destinationViewController.profile = self.profile
        }
    }
    

}
