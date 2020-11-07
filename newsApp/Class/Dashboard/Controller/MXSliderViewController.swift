
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit
import MXParallaxHeader
import ImageSlideshow
import ObjectMapper

class MXSliderViewController: UIViewController, MXParallaxHeaderDelegate, DashboardAPIDelegate {
    
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnSource: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        parallaxHeader?.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
       
    }
    
}
