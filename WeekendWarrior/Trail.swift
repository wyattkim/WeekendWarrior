import Foundation
import UIKit

struct Trail {
    private let json: [String: AnyObject]
    
    init(json: [String: AnyObject]) {
        self.json = json
    }
    
    var name: String? {return json["name"] as? String}
    var status: String? {return json["status"] as? String}
    var description: String? {return json["description"] as? String}
    
    var lat: Float? {return json["lat"] as? Float}
    var lng: Float? {return json["lng"] as? Float}
    

}
