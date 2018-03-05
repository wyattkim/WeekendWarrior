//
//  API.swift
//  WeekendWarrior
//
//  Created by Alana Kamahele on 3/2/18.
//  Copyright © 2018 Wyatt Kim. All rights reserved.
//

import Foundation

struct API {
    
    static let APIKey = "efe351afa2712118c8794f87d9cf2c6b"
    static let BaseURL = URL(string: "https://api.darksky.net/forecast/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }
}
