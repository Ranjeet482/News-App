
//
//  Created by Ranjeet
//  Copyright © 2020 Ranjeet Kumar Sah All rights reserved.
//

import UIKit

// Storyboards
let HOME_STORY_BOARD: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
let NEWS_DETAIL_STORY_BOARD: UIStoryboard = UIStoryboard(name: "NewsDetail", bundle: nil)
let NEWS_STORY_BOARD: UIStoryboard = UIStoryboard(name: "News", bundle: nil)

//API
let BASE_URI = "http://newsapi.org"
let TOPHEADLINES_API = BASE_URI + "/v2/top-headlines"
let EVERYTHING_API = BASE_URI + "/v2/everything"
let SOURCES_API = BASE_URI + "/v2/sources"

let APP_PRIMARY_COLOR = Utility.sharedInstance.hexStringToUIColor(hex: "0E80E4")

//Can be used in info.plist as well
let API_KEY = "10eb851d6d894a13bebd4738c84d9a7e"
