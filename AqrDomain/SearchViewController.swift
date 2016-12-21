//
//  ViewController.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/6/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import UIKit
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate  {
    @IBOutlet weak var tblSearchResults: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var timer = Timer()
    var dataArray = [SearchSuggestion]()
    
    var filteredArray = [SearchSuggestion]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var previousSearchText = ""
    var currentSearchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = true
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        self.activityIndicator.isHidden = true
        // Uncomment the following line to enable the default search controller.
        // configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
        configureCustomSearchController()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
//            return dataArray.count
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        let searchResult = filteredArray[indexPath.row]
        
        if shouldShowSearchResults {
            cell.textLabel?.text = searchResult.domain
        }
        else {
            cell.textLabel?.text = searchResult.domain
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = self.filteredArray[indexPath.row]
        let registerDomain = RegisterDomainWebViewController()
        registerDomain.urlStringToLoad = searchResult.registerURL
        self.navigationController?.pushViewController(registerDomain, animated: true)
    }
    // MARK: Custom functions
    
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor.black)
        
        customSearchController.customSearchBar.placeholder = "Search your domain name here..."
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        shouldShowSearchResults = true
//        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
        }
        self.fetchDataAndUpdateUI("" as AnyObject)
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchString = searchController.searchBar.text else {
//            return
//        }
//        
//        
//        // Reload the tableview.
//        tblSearchResults.reloadData()
    }
    
    

    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
//        shouldShowSearchResults = true
//        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.fetchDataAndUpdateUI("" as AnyObject)
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        guard searchText != "" else {
            shouldShowSearchResults = false
            self.tblSearchResults.reloadData()
            return
        }
        shouldShowSearchResults = true
        self.activityIndicator.isHidden = false
        if timer.isValid {
            timer.invalidate()
        }
        currentSearchText = searchText
        if self.isAPIRequestRequired(searchText) {
            print("APi Required")
            timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(SearchViewController.fetchDataAndUpdateUI(_:)), userInfo: nil, repeats: false)

         }
        else {
            print("API not required..")
            self.filteredArray = self.dataArray.filter({ (searchSuggestion) -> Bool in
                let domain: NSString = searchSuggestion.domain! as NSString
                
                return (domain.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            // Reload the tableview.
            tblSearchResults.reloadData()

        }
    }
    
    @objc func fetchDataAndUpdateUI(_ sender:AnyObject)  {
        APIManager.sharedInstance.searchDomainName(query: currentSearchText,completion: {
            (success, dataReceived) in
            guard let dataReceived = dataReceived else {
                return
            }
            self.dataArray = dataReceived
            self.filteredArray = self.dataArray.filter({ (searchSuggestion) -> Bool in
                let domain: NSString = searchSuggestion.domain! as NSString
                
                return (domain.range(of: self.currentSearchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            // Reload the tableview.
            
            DispatchQueue.main.async {
                self.tblSearchResults.reloadData()
                self.activityIndicator.isHidden = true
            }
            
            
        })
    }
     func isAPIRequestRequired(_ searchText:String?) -> Bool {
        guard let searchText = searchText else {
            return false
        }
        if previousSearchText.hasPrefix(searchText){
            self.previousSearchText = searchText
            return true
        }
        else {
            self.previousSearchText = searchText
            return true
        }
    }
}
