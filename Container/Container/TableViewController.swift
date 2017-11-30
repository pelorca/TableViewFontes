//
//  TableViewController.swift
//  Container
//
//  Created by Rafagan Abreu on 28/11/17.
//  Copyright © 2017 Rafagan Abreu. All rights reserved.
//

import UIKit
import DataKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    let maxSections = 5
    let maxRows = 15
    lazy var dataIcon = [Int: [Icon]]()
    lazy var dataImage = [Int: [NetworkImage]]()
    
    lazy var dataIconOriginal = [Int: [Icon]]()
    lazy var dataImageOriginal = [Int: [NetworkImage]]()
    
    var cache = [String: UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataIcon = generateIcons(sections: maxSections, rows: maxRows)
        dataImage = generateImages(sections: maxSections, rows: maxRows)
        dataIconOriginal = dataIcon
        dataImageOriginal = dataImage
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return maxSections
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dataImage = dataImageOriginal
            dataIcon = dataIconOriginal
            self.tableView.reloadData()
            return
        }
        for (section, list) in dataIconOriginal {
            let filtered = list.filter{
                let textToSearch = "\($0.name) \($0.description)"
                return textToSearch.range(of: searchText) != nil
            }
            dataIcon[section] = filtered
        }
        
        for (section, list) in dataImageOriginal {
            let filtered = list.filter{
                let textToSearch = "\($0.name) \($0.description)"
                return textToSearch.range(of: searchText) != nil
            }
            dataImage[section] = filtered
        }
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var max = 0
        
        for (_, list) in dataIcon {
            if list.count > max {
                max = list.count
            }
        }
        
        for (_, list) in dataImage {
            if list.count > max {
                max = list.count
            }
        }
        
        return max
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iconOrImage = arc4random_uniform(2) == 0
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if indexPath.row >= (dataIcon[indexPath.section]?.count)! || indexPath.row >= (dataImage[indexPath.section]?.count)! {
            
           return  tableView.dequeueReusableCell(
                withIdentifier: "placeHolder", for: indexPath) as! TableViewCell
            
        }
        
        if iconOrImage {
            let content = dataIcon[indexPath.section]![indexPath.row]
            
            cell.titleLabel.text = content.name
            cell.contentTextLabel.text = content.description
            
            var img = UIImage(named: content.imageName)
            img = img?.withRenderingMode(.alwaysTemplate)
            cell.leftImage.image = img
            cell.leftImage.tintColor =
                UIColor(displayP3Red: CGFloat(normalizedRandom()),
                        green: CGFloat(normalizedRandom()),
                        blue: CGFloat(normalizedRandom()),
                        alpha: 1)
        } else {
            let content = dataImage[indexPath.section]![indexPath.row]
            
            cell.titleLabel.text = content.name
            cell.contentTextLabel.text = content.description
            cell.leftImage.downloadImageAsync(url: URL(string: content.link)!)
        }

        return cell
    }
}
