//
//  NewsDetailWebVC.swift
//  newsApp
//
//  Created by Ranjeet Sah on 11/7/20.
//  Copyright © Ranjeet All rights reserved.
//

import UIKit
import WebKit

class NewsDetailWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    var url: String?

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url {
            if let myURL = URL(string: url) {
                let myRequest = URLRequest(url: myURL)
                webView.load(myRequest)
            }
            
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Loader.sharedInstance.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.sharedInstance.removeLoader()
    }
    
    

}
