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

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    public var email: String!
    var trail = Trail(json: ["": "" as AnyObject])

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            //self.nameLabel.text = self.email
        }
        
        // Do any additional setup after loading the view.
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
            destinationViewController.userEmail = self.email
        }
    }
    

}