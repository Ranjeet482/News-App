
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit

@objc protocol DashboardAPIDelegate {
    @objc optional func didReceiveSearchNewsFromEverythingAPISuccessfully(resultDict:AnyObject,resultStatus:Bool)
    @objc optional func didFailWithSearchNewsFromEverythingAPIWithError(_ error: NSError,resultStatus:Bool)
    
}

class DashboardAPI {
    
    var delegate:DashboardAPIDelegate?

    
    func getSearchNewsFromEverything(api: String, page: Int?, query: String) {
        
        var params: [String: AnyObject] = [:]
        if let page = page {
            params = ["page":page, "q": query] as [String : AnyObject]
        }else {
            params = [:]
        }
        
        APIHandler.sharedInstance.performGETRequest(
            (api as NSString),
            params: params as NSDictionary,
            success: { (response) in
                
                self.delegate?.didReceiveSearchNewsFromEverythingAPISuccessfully!(resultDict: response, resultStatus: true)
                
        }) { (error) in
            self.delegate?.didFailWithSearchNewsFromEverythingAPIWithError!(error, resultStatus: false)
        }
    }
        
}

