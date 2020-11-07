
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit
import ObjectMapper
import WebKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var ntitle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    var article : Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNavigationBarImage()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if let article = self.article {
            self.time.text = article.publishedAt ?? ""
            self.ntitle.text = article.title
            self.txtView.text = article.content
            self.title = article.title
            let image = article.urlToImage ?? ""
            if let url = NSURL(string: image) {
                bannerImage.af_setImage(withURL: url as URL)
            }
            
        }
       
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    
    @IBAction func shareTextButton(_ sender: UIButton) {
        
        let text = self.article?.url ?? ""
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func showNewsDetailWeb(_ sender : Any) {
        
        let detailsNewsWebVC = NEWS_DETAIL_STORY_BOARD.instantiateViewController(withIdentifier: "NewsDetailWebVC") as! NewsDetailWebVC
        
        detailsNewsWebVC.url = article?.url ?? ""
        
        self.navigationController?.pushViewController(detailsNewsWebVC, animated: true)
    }
    
    
}
