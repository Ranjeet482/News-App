//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import Foundation

@objc protocol TopHeadlinesNewsAPIDelegate {
    @objc optional func didReceiveTopHeadlinesNewsAPISuccessfully(resultDict:AnyObject,resultStatus:Bool)
    @objc optional func didFailWithTopHeadlinesNewsAPIWithError(_ error: NSError,resultStatus:Bool)
    
}

class TopHeadlinesNewsAPI {
    
    var delegate:TopHeadlinesNewsAPIDelegate?
    
    func getTopHeadlinesNews(api: String, page: Int?, category: String?=nil, country: String?=nil, source: String?=nil) {
        
        var params: [String: AnyObject] = [:]
        if let page = page {
            params = ["page":page, "category": category] as [String : AnyObject]
        }else {
            params = [:]
        }
        
        if country != nil {
            params = ["page":page, "category": category, "country": country] as [String : AnyObject]
        }
        
        if source != nil {
            params = ["page":page, "sources": source] as [String : AnyObject]
        }
        
        
        APIHandler.sharedInstance.performGETRequest(
            (api as NSString),
            params: params as NSDictionary,
            success: { (response) in
                
                self.delegate?.didReceiveTopHeadlinesNewsAPISuccessfully!(resultDict: response, resultStatus: true)
                
        }) { (error) in
            self.delegate?.didFailWithTopHeadlinesNewsAPIWithError!(error, resultStatus: false)
        }
    }
    
}
