//
//  CalendarController.swift
//  WeekendWarrior
//
//  Created by Alana Kamahele on 4/3/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController

class CalendarController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        DispatchQueue.main.async {
            self.present(dateRangePickerViewController, animated: true, completion: nil)
        }


    }
    
    @IBAction func didTapButton(_ sender: Any) {
 
    }
    
}

extension CalendarController : CalendarDateRangePickerViewControllerDelegate {
    func didTapCancel() {
        
    }
    
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        
    }
    
    
    func didCancelPickingDateRange() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        label.text = dateFormatter.string(from: startDate) + " to " + dateFormatter.string(from: endDate)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
