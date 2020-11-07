
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit

class Loader: NSObject {
    
    static let sharedInstance : Loader = Loader()
    
    private override init() {
    }
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private func setupLoader() {
        removeLoader()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = Utility.sharedInstance.hexStringToUIColor(hex: "0E80E4")
    }
    
    func showLoader() {
        setupLoader()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let holdingView = appDel.window!.rootViewController!.view!
        
        DispatchQueue.main.async {
            self.activityIndicator.center = holdingView.center
            self.activityIndicator.startAnimating()
            holdingView.addSubview(self.activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func addLoaderForPagination() -> UIView {
        setupLoader()
        return activityIndicator
    }

}
