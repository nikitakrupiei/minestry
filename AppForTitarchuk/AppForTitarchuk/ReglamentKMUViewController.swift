//
//  ReglamentKMUViewController.swift
//  AppForTitarchuk
//
//  Created by Никита Крупей on 1/24/19.
//  Copyright © 2019 Никита Крупей. All rights reserved.
//

import UIKit
import CloudKit

class ReglamentKMUViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var CloudReglament: [CKRecord] = []
    var currentCloudReglament: [CKRecord] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpSearchBar()
        
        setNeedsStatusBarAppearanceUpdate()
        self.tableView.backgroundColor = UIColor.darkGray
        UINavigationBar.appearance().barTintColor = .darkGray
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ReglamentKMUViewController.dismissReglamentKMUViewController))
        
        
        getRecordsFromCloud()
        
        //setArrays()
        
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.stopAnimating()
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.darkGray
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(getRecordsFromCloud), for: UIControl.Event.valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
   
    @objc func getRecordsFromCloud(){
        var newCloudRedlament: [CKRecord] = []
        
        let cloudContainer = CKContainer.default()
        let publicDB = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ReglamentDB", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        
        //query.sortDescriptors = [NSSortDescriptor(key: "Date", ascending: true)]
//        let sort = NSSortDescriptor (key: "creationDate", ascending: false)
//        query.sortDescriptors = [sort]
       // query.sortDescriptors = [NSSortDescriptor(key: "Date", ascending: true)]
        
        let queryoperation = CKQueryOperation(query: query)
        queryoperation.desiredKeys = ["Date","Information"]
        queryoperation.queuePriority = .veryHigh
        queryoperation.resultsLimit = 200
        
        queryoperation.recordFetchedBlock = {(record: CKRecord!) -> Void in
            if let ReglamentRecord = record {
                newCloudRedlament.append(ReglamentRecord)
            }
        }
        
        queryoperation.queryCompletionBlock = {(cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
            if error != nil {
                print("Failed")
                return
            }
            OperationQueue.main.addOperation(){
                self.CloudReglament = newCloudRedlament
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshControl?.endRefreshing()
            }
        }
        publicDB.add(queryoperation)
    }
    
//    func setArrays(){
//        currentReglament = reglament
//    }

    // MARK: - Table view data source
    @objc func dismissReglamentKMUViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CloudReglament.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        
        let cloudReglament = CloudReglament[indexPath.row]
        
        cell.textLabel?.text = cloudReglament.object(forKey: "Date") as? String
        
        //cell.textLabel?.text = currentReglament[indexPath.row].date
        cell.textLabel?.textColor = .white

        return cell
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destination as! DetailedReglamentViewController
            destinationController.information = (CloudReglament[indexPath.row].object(forKey: "Information") as? String)!
            
        }
    }
    
//    func setUpSearchBar(){
//        searchBar.delegate = self
//    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        guard !searchText.isEmpty else {
//            currentReglament = reglament
//            table.reloadData()
//            return }
//        currentReglament = reglament.filter({reglament -> Bool in
//            return reglament.date.contains(searchText)
//        })
//        table.reloadData()
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar .resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
