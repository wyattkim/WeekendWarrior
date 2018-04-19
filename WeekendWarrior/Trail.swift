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
    var id: String? {return json["objectID"] as? String}
    
    var lat: Double? {
        let geoloc = json["_geoloc"] as? [String:Any]
        return (geoloc!["lat"] as! Double)
    }
    
    var lng: Double? {
        let geoloc = json["_geoloc"] as? [String:Any]
        return (geoloc!["lng"] as! Double)
    }
    
    var distance: Double? {return json["distance"] as? Double}
    var elevation: Double? {return json["elevation"] as? Double}
    var difficulty: String? {return json["difficulty"] as? String}
    var number: String? {return json["number"] as? String}
    var type: String? {return json["type"] as? String}
    var users: [String]? {return json["users"] as? [String]}
}
