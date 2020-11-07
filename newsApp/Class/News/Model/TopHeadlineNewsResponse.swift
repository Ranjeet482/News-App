
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import Foundation
import ObjectMapper

class TopHeadlineNewsResponse : Mappable {
    var status: String?
    var totalResults: Int?
    var data: [Article]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        totalResults <- map["totalResults"]
        data <- map["articles"]
    }
    
    
}
