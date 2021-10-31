//
//  HistoryViewController.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let coreData = CoreDataInstance()
    var searchString = ""
    
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.reloadData()
    }
    
    // MARK: - preparing the screen for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyToResults" {
            let historyResultsViewController = segue.destination as! HistoryResultsViewController
            historyResultsViewController.searchString = searchString
        }
    }
}

// MARK: - configuring cells + adding methods to delete and go to the next screen

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if coreData.data.count == 0 {
            backgroundLabel.isHidden = false
        }
        else {
            backgroundLabel.isHidden = true
        }
        
        return coreData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        
        cell.textLabel?.text = coreData.data[indexPath.row].searchRequest
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            coreData.deleteRequest(with: coreData.data[indexPath.row].searchRequest!)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchString = coreData.data[indexPath.row].searchRequest!
        self.performSegue(withIdentifier: "historyToResults", sender: self)
    }
}
