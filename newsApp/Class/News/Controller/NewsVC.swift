
import UIKit
import ObjectMapper
import MaterialComponents.MaterialBottomSheet
import MaterialComponents.MaterialBottomSheet_ShapeThemer

class NoticeTableViewCell : UITableViewCell {
    
    @IBOutlet weak var ivNotice : UIImageView!
    @IBOutlet weak var lblNoticeHeading: UILabel!
    @IBOutlet weak var lblNoticeDate: UILabel!
}


class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TopHeadlinesNewsAPIDelegate, OptionVCDelegate {
    
    var VCTitle: String?
    var homeApiToHit: Int = 0
    var apiToHit = ""
    var page:Int?
    var isFirstPageHit = true
    var category: String?
    var selectedCountry: String = ""
    var selectedSource: String = ""
    
    var datasourceArrayCode = ["abc-news", "al-jazeera-english", "ars-technica", "associated-press", "bbc-news", "bbc-sport", "bloomberg", "business-insider", "buzzfeed", "cbs-news", "cnn"]
    var datasourceArray = ["ABC News", "Al Jazeera English", "Ars Technica", "Associated Press", "BBC News", "BBC Sport", "Bloomberg", "Business Insider", "Buzzfeed", "CBS News", "CNN"]
    var dataCountryArrayCode = ["ar", "at", "au", "be", "bg", "br", "ca", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "sg", "se", "ch", "si", "sk", "za", "th", "tr", "tw", "ae", "ua", "us", "ve"]
    var dataCountryArray = [ "Argentina", "Austria", "Australia", "Belgium", "Bulgaria", "Brazil", "Canada", "China", "Colombia", "Cuba", "Czech Republic", "Germany", "Egypt", "France", "Great Britain", "Greece", "Hong Kong", "Hungary", "Indonesia", "Ireland", "Israel", "India", "Italy", "Japan", "South Korea", "Lithuania", "Latvia", "Morocco", "Mexico", "Malaysia", "Nigeria", "Netherlands", "Norway", "New Zealand", "Philippines", "Poland", "Portugal", "Romania", "Serbia", "Russia", "Saudi Arabia", "Singapore", "Sweden" , "Switzerland", "Slovenia", "Slovakia", "South Africa", "Thailand", "Turkey", "Taiwan", "UAE","Ukraine", "USA", "Venezuela" ]
    
    var countries = [["ar": "Argentina"], ["at": "Austria"], ["au": "Australia"], ["be": "Belgium"], ["bg": "Bulgaria"], ["br": "Brazil"], ["ca": "Canada"], ["cn": "China"], ["co": "Colombia"], ["cu": "Cuba"], ["cz": "Czech Republic"], ["de": "Germany"], ["eg": "Egypt"], ["fr": "France"], ["gb": "Great Britain"], ["gr": "Greece"], ["hk": "Hong Kong"], ["hu": "Hungary"], ["id": "Indonesia"], ["ie": "Ireland"], ["il": "Israel"], ["in": "India"], ["it": "Italy"], ["jp": "Japan"], ["kr": "South Korea"], ["lt": "Lithuania"], ["lv": "Latvia"], ["ma": "Morocco"], ["mx": "Mexico"], ["my": "Malaysia"], ["ng": "Nigeria"], ["nl": "Netherlands"], ["no": "Norway"], ["nz": "New Zealand"], ["ph": "Philippines"], ["pl": "Poland"], ["pt": "Portugal"], ["ro": "Romania"], ["rs": "Serbia"], ["ru": "Russia"], ["sa": "Saudi Arabia"], ["sg": "Singapore"], ["se": "Sweden"], ["ch": "Switzerland"], ["si": "Slovenia"], ["sk": "Slovakia"], ["za": "South Africa"], ["th": "Thailand"], ["tr": "Turkey"], ["tw": "Taiwan"], ["ae": "UAE"], ["ua": "Ukraine"], ["us": "USA"], ["ve": "Venezuela"]]
    
    var sources = [["abc-news": "ABC News"], ["al-jazeera-english": "Al Jazeera English"], ["ars-technica": "Ars Technica"], ["associated-press": "Associated Press"], ["bbc-news": "BBC News"], ["bbc-sport": "BBC Sport"], ["bloomberg": "Bloomberg"], ["business-insider": "Business Insider"], ["buzzfeed": "Buzzfeed"], ["cbs-news": "CBS News"], ["cnn": "CNN"]]
    
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var btnCountry: UIButton!
    
    
    var topHeadlineNewsResponse: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = VCTitle
               
        self.setUpAPI()
        
        self.noticeTableView.dataSource = self
        self.noticeTableView.delegate = self
        self.noticeTableView.tableFooterView = UIView()
        
        let topHeadlinesNewsAPI = TopHeadlinesNewsAPI()
        topHeadlinesNewsAPI.delegate = self
        topHeadlinesNewsAPI.getTopHeadlinesNews(api: TOPHEADLINES_API, page: page, category: category ?? "")
        Loader.sharedInstance.showLoader()
                
    }
    
    @IBAction func showSources(_ sender: Any) {
                
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
    
    
    func didSelectSource(source: String) {
        print(source)
    }
    
    @IBAction func showCountries(_ sender: Any) {
           
        let viewController = NEWS_STORY_BOARD.instantiateViewController(withIdentifier: "OptionsVC") as! OptionsVC
       viewController.options = self.countries
       viewController.isCountry = true
        viewController.isSource = false
       viewController.delegate = self
       let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: viewController)
       bottomSheet.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 100.0)
       bottomSheet.contentViewController.view.layer.cornerRadius = 20.0
       present(bottomSheet, animated: true, completion: nil)
           
    }
    
    func didSelectCountry(country: String, countryName: String) {
        self.setUpAPI()
        btnCountry.setTitle(countryName, for: .normal)
         let topHeadlinesNewsAPI = TopHeadlinesNewsAPI()
        topHeadlinesNewsAPI.delegate = self
        topHeadlinesNewsAPI.getTopHeadlinesNews(api: TOPHEADLINES_API, page: page, category: category ?? "", country: country)
        Loader.sharedInstance.showLoader()
    }
    
    func setUpAPI(){
        isFirstPageHit = true
        page = 1
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topHeadlineNewsResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell") as! NoticeTableViewCell
        
        cell.lblNoticeHeading.text = topHeadlineNewsResponse[indexPath.row].title
        cell.lblNoticeDate.text = topHeadlineNewsResponse[indexPath.row].publishedAt
        let image = topHeadlineNewsResponse[indexPath.row].urlToImage ?? ""
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
                self.noticeTableView.tableFooterView = activityIndicator
                self.noticeTableView.tableFooterView?.isHidden = false
                
                let topHeadlinesNewsAPI = TopHeadlinesNewsAPI()
                topHeadlinesNewsAPI.delegate = self
                topHeadlinesNewsAPI.getTopHeadlinesNews(api: TOPHEADLINES_API, page: page, category: category ?? "")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    
    func didReceiveTopHeadlinesNewsAPISuccessfully(resultDict: AnyObject, resultStatus: Bool) {
        
        if (resultDict["status"] as! String == "ok") {
            if let json = resultDict as? [String: Any] {
                if let categoryNewsResponse:TopHeadlineNewsResponse = Mapper<TopHeadlineNewsResponse>().map(JSON: json) {
                    
                    if (isFirstPageHit == true) {
                        self.topHeadlineNewsResponse =  categoryNewsResponse.data!
                    }else {
                        let newPageResponse = categoryNewsResponse.data!
                        self.topHeadlineNewsResponse.append(contentsOf: newPageResponse)
                    }
                    
                    self.noticeTableView.reloadData()
                }
            }
            page = page! + 1
            self.isFirstPageHit = false
        }
        Loader.sharedInstance.removeLoader()
        self.noticeTableView.tableFooterView?.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsNewsVC = NEWS_DETAIL_STORY_BOARD.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        
        detailsNewsVC.article = topHeadlineNewsResponse[indexPath.row]
        
        self.navigationController?.pushViewController(detailsNewsVC, animated: true)
    }
    
    func didFailWithTopHeadlinesNewsAPIWithError(_ error: NSError, resultStatus: Bool) {
        print(error.localizedDescription)
        Loader.sharedInstance.removeLoader()
        self.noticeTableView.tableFooterView?.isHidden = true
    }
    
}
