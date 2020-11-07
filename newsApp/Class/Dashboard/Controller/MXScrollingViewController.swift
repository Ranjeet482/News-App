
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit
import MXParallaxHeader
import MaterialComponents.MaterialBottomSheet
import MaterialComponents.MaterialBottomSheet_ShapeThemer

class MXScrollingViewController: MXScrollViewController, MXScrollViewDelegate, OptionVCDelegate {
    
    
     var sources = [["abc-news": "ABC News"], ["al-jazeera-english": "Al Jazeera English"], ["ars-technica": "Ars Technica"], ["associated-press": "Associated Press"], ["bbc-news": "BBC News"], ["bbc-sport": "BBC Sport"], ["bloomberg": "Bloomberg"], ["business-insider": "Business Insider"], ["buzzfeed": "Buzzfeed"], ["cbs-news": "CBS News"], ["cnn": "CNN"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.getNavigationBarImage()
        self.scrollView.delegate = self
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func openSearch(_ sender: UIBarButtonItem) {
        let detailsNewsWebVC = HOME_STORY_BOARD.instantiateViewController(withIdentifier: "SearchNewsVC") as! SearchNewsVC
        self.navigationController?.pushViewController(detailsNewsWebVC, animated: true)
    }
    
    @IBAction func openSource(_ sender: UIBarButtonItem) {
         let viewController = NEWS_STORY_BOARD.instantiateViewController(withIdentifier: "OptionsVC") as! OptionsVC
           viewController.options = self.sources
           viewController.isSource = true
           viewController.isCountry = false
           viewController.delegate = self
           let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
           bottomSheet.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 300.0)
           bottomSheet.contentViewController.view.layer.cornerRadius = 20.0
           present(bottomSheet, animated: true, completion: nil)
    }
    
    func didSelectSource(source: String, sourceName: String) {
        
        let vc = HOME_STORY_BOARD.instantiateViewController(withIdentifier: "SourceNewsVC") as! SourceNewsVC
        vc.source = source
        vc.sourceName = sourceName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
