//
//  LoginViewController.swift
//  WeekendWarrior
//
//  Created by Wyatt Kim on 2/7/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import UIKit
import AWSAuthUI
import AWSAuthCore
import AWSDynamoDB
import CSV

class LoginViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createSampleTrail()

        readSampleTrail()
//
//        deleteSampleTrail()
        
//        let stream = InputStream(fileAtPath: "/Users/wyattkim/Desktop/weekend-warrior-data.csv")!
//        let csv = try! CSVReader(stream: stream)
//        while true {
//            let row = csv.next()
//            if (row == nil) {
//                continue
//            }
//            print("\(row)")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Database operations
    
    private func createSampleTrail() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let sampleTrail: Trail = Trail()
        sampleTrail._trailId = "2"
        sampleTrail._description = "Camping on the top of Mt Baldy is an experience. You have to pack in all your water. It’s cold, windy and exposed. But oh those sunrise and sunsets! And it’s dog friendly."
        sampleTrail._latitude = "34.2364° N"
        sampleTrail._longitude = "117.6590° W"
        sampleTrail._name = "Mt. Baldy"
        sampleTrail._status = "Closed"
        
        
        dynamoDbObjectMapper.save(sampleTrail, completionHandler: {
            (error: Error?) -> Void in
            if let error = error {
                print("AWS DynamoDB save error: \(error)")
                return
            }
            print("A trail was saved: \(sampleTrail._name)")
        })
    }
    
    private func deleteSampleTrail() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToDelete = Trail()
        itemToDelete?._trailId = "0"
        
        dynamoDbObjectMapper.remove(itemToDelete!, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was deleted: \(itemToDelete!._name)")
        })
    }
    
    private func readSampleTrail() {
        for index in 0...2 {
            let queryExpression = AWSDynamoDBQueryExpression()
            queryExpression.keyConditionExpression = "#trailId = :trailId"

            queryExpression.expressionAttributeNames = [
            "#trailId": "trailId"
            ]
            queryExpression.expressionAttributeValues = [
                ":trailId": "\(index)"
            ]
        
            let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
            
            dynamoDbObjectMapper.query(Trail.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
                if error != nil {
                    print("The request failed. Error: \(String(describing: error))")
                }
                if output != nil {
                    for news in output!.items {
                        let newsItem = news as? Trail
                        print("name: \(newsItem!._name!)")
                        print("trailId: \(newsItem!._trailId!)")
                        print("status: \(newsItem!._status!)")
                        print("description: \(newsItem!._description!)")
                        print("latitude: \(newsItem!._latitude!)")
                        print("longitude: \(newsItem!._longitude!)")
                    }
                }
            }
        }
    }
}
