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
    
    var timer = NSTimer()
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
        
        self.navigationController?.navigationBar.hidden = true
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        self.activityIndicator.hidden = true
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
//            return dataArray.count
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        
        let searchResult = filteredArray[indexPath.row]
        
        if shouldShowSearchResults {
            cell.textLabel?.text = searchResult.domain
        }
        else {
            cell.textLabel?.text = searchResult.domain
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tblSearchResults.frame.size.width, 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orangeColor(), searchBarTintColor: UIColor.blackColor())
        
        customSearchController.customSearchBar.placeholder = "Search your domain name here..."
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        shouldShowSearchResults = true
//        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
        }
        self.fetchDataAndUpdateUI("")
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
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
            self.fetchDataAndUpdateUI("")
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        guard searchText != "" else {
            shouldShowSearchResults = false
            self.tblSearchResults.reloadData()
            return
        }
        shouldShowSearchResults = true
        self.activityIndicator.hidden = false
        if timer.valid {
            timer.invalidate()
        }
        currentSearchText = searchText
        if self.isAPIRequestRequired(searchText) {
            print("APi Required")
            timer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(SearchViewController.fetchDataAndUpdateUI(_:)), userInfo: nil, repeats: false)

         }
        else {
            print("API not required..")
            self.filteredArray = self.dataArray.filter({ (searchSuggestion) -> Bool in
                let domain: NSString = searchSuggestion.domain!
                
                return (domain.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            })
            // Reload the tableview.
            tblSearchResults.reloadData()

        }
    }
    
    @objc func fetchDataAndUpdateUI(sender:AnyObject)  {
        APIManager.sharedInstance.searchDomainName(query: currentSearchText,completion: {
            (success, dataReceived) in
            guard let dataReceived = dataReceived else {
                return
            }
            self.dataArray = dataReceived
            self.filteredArray = self.dataArray.filter({ (searchSuggestion) -> Bool in
                let domain: NSString = searchSuggestion.domain!
                
                return (domain.rangeOfString(self.currentSearchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            })
            // Reload the tableview.
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tblSearchResults.reloadData()
                self.activityIndicator.hidden = true
            }
            
            
        })
    }
     func isAPIRequestRequired(searchText:String?) -> Bool {
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

