//
//  OptionsVC.swift
//  newsApp
//
//  Created by Ranjeet Sah on 11/7/20.
//  Copyright © Ranjeet All rights reserved.
//

import UIKit

@objc protocol OptionVCDelegate {
    @objc optional func didSelectCountry(country:String, countryName: String)
    @objc optional func didSelectSource(source: String, sourceName: String)
}

class OptionTableViewCell: UITableViewCell {
    @IBOutlet weak var lblOption: UILabel!
}

class OptionsVC: UIViewController {
    
    @IBOutlet weak var tvOptions: UITableView!
    var options : [[String:String]] = []
    var isSource = false
    var isCountry = false
    var delegate : OptionVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tvOptions.delegate = self
        tvOptions.dataSource = self
        // Do any additional setup after loading the view.
    }


}

extension OptionsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option_cell", for: indexPath) as! OptionTableViewCell
        cell.lblOption.text = options[indexPath.row][options[indexPath.row].keys.first ?? ""]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSource == true {
            self.delegate?.didSelectSource!(source: options[indexPath.row].keys.first ?? "", sourceName: options[indexPath.row][options[indexPath.row].keys.first ?? ""] ?? "")
        }else if isCountry == true {
            self.delegate?.didSelectCountry!(country: options[indexPath.row].keys.first ?? "", countryName: options[indexPath.row][options[indexPath.row].keys.first ?? ""] ?? "")
        }
        self.dismiss(animated: false, completion: nil)
        
    }
    

}
