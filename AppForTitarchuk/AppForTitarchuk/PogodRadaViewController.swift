//
//  PogodRadaViewController.swift
//  AppForTitarchuk
//
//  Created by Никита Крупей on 1/24/19.
//  Copyright © 2019 Никита Крупей. All rights reserved.
//

import UIKit
import CloudKit

class PogodRadaViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var CloudPogodRada: [CKRecord] = []
    var currentCloudPogodRada: [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNeedsStatusBarAppearanceUpdate()
        
        //setUpSearchBar()
        //setArrays()
        self.tableView.backgroundColor = UIColor.darkGray
        UINavigationBar.appearance().barTintColor = .darkGray
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PogodRadaViewController.dismissPogodRadaViewController))
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
        var newCloudPogodRada:[CKRecord] = []
        
        let cloudContainer = CKContainer.default()
        let publicDB = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "PogodRadaDB", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryoperation = CKQueryOperation(query: query)
        queryoperation.desiredKeys = ["Date","Information","videoURL"]
        queryoperation.queuePriority = .veryHigh
        queryoperation.resultsLimit = 200
        
        queryoperation.recordFetchedBlock = {(record: CKRecord!) -> Void in
            if let PogodRadaRecord = record {
                newCloudPogodRada.append(PogodRadaRecord)
            }
        }
        
        queryoperation.queryCompletionBlock = {(cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
            if error != nil {
                print("Failed")
                return
            }
            OperationQueue.main.addOperation(){
                self.CloudPogodRada=newCloudPogodRada
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshControl?.endRefreshing()
            }
        }
        publicDB.add(queryoperation)
    }
    
    func setArrays(){
    currentCloudPogodRada = CloudPogodRada
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func dismissPogodRadaViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CloudPogodRada.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        
        
        let cloudPogodRada = CloudPogodRada[indexPath.row]
        
        cell.textLabel?.text = cloudPogodRada.object(forKey: "Date") as? String
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailerPogodViewController
                destinationController.information = (CloudPogodRada[indexPath.row].object(forKey: "Information") as? String)!
                destinationController.videoURL = (CloudPogodRada[indexPath.row].object(forKey: "videoURL") as? String)!
           
        }
    }
//    func setUpSearchBar(){
//        searchBar.delegate = self
//    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            currentCloudPogodRada = CloudPogodRada
            table.reloadData()
            return }
        currentCloudPogodRada = CloudPogodRada.filter({CloudPogodRada -> Bool in
            let a = CloudPogodRada.object(forKey: "Date") as? String
            return a!.contains(searchText)
        })
        table.reloadData()
    }
    
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
