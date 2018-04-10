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
    
    func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 10, width: 410, height: 44))
        dateRangePickerViewController.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Dates")
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(CalendarController.cancelButtonPressed(_:)))
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(CalendarController.cancelButtonPressed(_:)))
        navItem.leftBarButtonItem = cancelItem
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        
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
