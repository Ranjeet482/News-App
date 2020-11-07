//
//  SearchNewsVC.swift
//  newsApp
//
//  Created by Ranjeet Sah on 11/7/20.
//  Copyright © Ranjeet All rights reserved.
//

import UIKit
import ObjectMapper

class SourceNewsVC: UIViewController, TopHeadlinesNewsAPIDelegate {
    
    @IBOutlet weak var tvSourceNews: UITableView!
       
    var searchNewsResponse: [Article] = []
    var homeApiToHit: Int = 0
    var apiToHit = ""
    var page:Int?
    var isFirstPageHit = true
    var source = ""
    var sourceName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpAPI()
        
        self.tvSourceNews.dataSource = self
        self.tvSourceNews.delegate = self
        self.tvSourceNews.tableFooterView = UIView()
        self.title = self.sourceName
        
        let newsAPI = TopHeadlinesNewsAPI()
        newsAPI.delegate = self
        newsAPI.getTopHeadlinesNews(api: TOPHEADLINES_API, page: page!, source: self.source)

    }
    
    
    func setUpAPI(){
        isFirstPageHit = true
        page = 1
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didReceiveTopHeadlinesNewsAPISuccessfully(resultDict: AnyObject, resultStatus: Bool) {
        
        if (resultDict["status"] as! String == "ok") {
            if let json = resultDict as? [String: Any] {
                if let categoryNewsResponse:TopHeadlineNewsResponse = Mapper<TopHeadlineNewsResponse>().map(JSON: json) {
                    
                    if (isFirstPageHit == true) {
                        self.searchNewsResponse =  categoryNewsResponse.data!
                    }else {
                        let newPageResponse = categoryNewsResponse.data!
                        self.searchNewsResponse.append(contentsOf: newPageResponse)
                    }
                    
                    self.tvSourceNews.reloadData()
                }
            }
            page = page! + 1
            self.isFirstPageHit = false
        }
        Loader.sharedInstance.removeLoader()
        self.tvSourceNews.tableFooterView?.isHidden = true
        
    }
    
    func didFailWithTopHeadlinesNewsAPIWithError(_ error: NSError, resultStatus: Bool) {
        print(error.localizedDescription)
        Loader.sharedInstance.removeLoader()
        self.tvSourceNews.tableFooterView?.isHidden = true
    }
    

}

extension SourceNewsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchNewsResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell_source") as! NoticeTableViewCell
        
        cell.lblNoticeHeading.text = searchNewsResponse[indexPath.row].title
        cell.lblNoticeDate.text = searchNewsResponse[indexPath.row].publishedAt
        let image = searchNewsResponse[indexPath.row].urlToImage ?? ""
        if let url =  NSURL(string: image) {
            cell.ivNotice.af_setImage(withURL: url as URL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(isFirstPageHit == false) {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = .whiteLarge
                activityIndicator.color = Utility.sharedInstance.hexStringToUIColor(hex: "0E80E4")
                activityIndicator.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tvSourceNews.tableFooterView = activityIndicator
                self.tvSourceNews.tableFooterView?.isHidden = false
                
                 let newsAPI = TopHeadlinesNewsAPI()
                newsAPI.delegate = self
                newsAPI.getTopHeadlinesNews(api: TOPHEADLINES_API, page: page!, source: self.source)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsNewsVC = NEWS_DETAIL_STORY_BOARD.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        
        detailsNewsVC.article = searchNewsResponse[indexPath.row]
        
        self.navigationController?.pushViewController(detailsNewsVC, animated: true)
    }
    
}
