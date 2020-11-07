
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import Foundation
import ObjectMapper

class Article: Mappable {
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var content: String?
    var publishedAt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        content <- map["content"]
        publishedAt <- map["publishedAt"]
    }
    
    
}
