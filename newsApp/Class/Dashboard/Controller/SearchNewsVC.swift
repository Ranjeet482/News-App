//
//  SearchNewsVC.swift
//  newsApp
//
//  Created by Ranjeet Sah on 11/7/20.
//  Copyright © Ranjeet All rights reserved.
//

import UIKit
import ObjectMapper

class SearchNewsVC: UIViewController, UITextFieldDelegate, DashboardAPIDelegate {
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tvSearchNews: UITableView!
    @IBOutlet weak var btnSearchIcon: UIButton!
       
    var searchNewsResponse: [Article] = []
    var homeApiToHit: Int = 0
    var apiToHit = ""
    var page:Int?
    var isFirstPageHit = true
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpAPI()
        
        self.tvSearchNews.dataSource = self
        self.tvSearchNews.delegate = self
        self.tvSearchNews.tableFooterView = UIView()
        self.tfSearch.delegate = self
        self.tfSearch.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
        self.endEditing()

        // Do any additional setup after loading the view.
    }
    
    @objc func textIsChanging(_ textField: UITextField) {
        
        
        let searchText  = tfSearch.text!
        
        if searchText.count > 0 {
            page = 1
            isFirstPageHit = true
            self.searchText = searchText
            self.btnSearchIcon.setImage(UIImage(named: "close"), for: .normal)
            let dashboardAPI = DashboardAPI()
            dashboardAPI.delegate = self
            dashboardAPI.getSearchNewsFromEverything(api: EVERYTHING_API, page: page!, query: self.searchText)
            
        }
        else{
            self.searchNewsResponse = []
            page = 1
            self.searchText = ""
            isFirstPageHit = true
            self.tvSearchNews.reloadData()
            
        }
        
        
    }
    
    func setUpAPI(){
        isFirstPageHit = true
        page = 1
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didReceiveSearchNewsFromEverythingAPISuccessfully(resultDict: AnyObject, resultStatus: Bool) {
        
        if (resultDict["status"] as! String == "ok") {
            if let json = resultDict as? [String: Any] {
                if let categoryNewsResponse:TopHeadlineNewsResponse = Mapper<TopHeadlineNewsResponse>().map(JSON: json) {
                    
                    if (isFirstPageHit == true) {
                        self.searchNewsResponse =  categoryNewsResponse.data!
                    }else {
                        let newPageResponse = categoryNewsResponse.data!
                        self.searchNewsResponse.append(contentsOf: newPageResponse)
                    }
                    
                    self.tvSearchNews.reloadData()
                }
            }
            page = page! + 1
            self.isFirstPageHit = false
        }
        Loader.sharedInstance.removeLoader()
        self.tvSearchNews.tableFooterView?.isHidden = true
        
    }
    
    func didFailWithSearchNewsFromEverythingAPIWithError(_ error: NSError, resultStatus: Bool) {
        print(error.localizedDescription)
        Loader.sharedInstance.removeLoader()
        self.tvSearchNews.tableFooterView?.isHidden = true
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.searchNewsResponse = []
        self.btnSearchIcon.setImage(UIImage(named: "search"), for: .normal)
        self.tfSearch.text = ""
    }

}

extension SearchNewsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchNewsResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell_search") as! NoticeTableViewCell
        
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
                self.tvSearchNews.tableFooterView = activityIndicator
                self.tvSearchNews.tableFooterView?.isHidden = false
                
                let dashboardAPI = DashboardAPI()
                dashboardAPI.delegate = self
                dashboardAPI.getSearchNewsFromEverything(api: EVERYTHING_API, page: page!, query: self.searchText)
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
