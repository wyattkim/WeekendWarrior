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
    @IBOutlet weak var trailName: UILabel!
    @IBOutlet weak var trailDescription: UILabel!
    
    public var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailName.text = trail.name
        trailDescription.text = trail.description
        
        // Do any additional setup after loading the view.
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
        }
    }
    

}
