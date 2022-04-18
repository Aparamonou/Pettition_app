//
//  TableViewController.swift
//  Pettition_App
//
//  Created by Alex Paramonov on 9.03.22.
//

import UIKit
import WebKit

class TableViewController: UITableViewController {
     
     var petitions = [Petition]()
     var filterPetitions = [Petition]()
     var filter: Bool  = false
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          
          performSelector(onMainThread: #selector(getData), with: nil, waitUntilDone: false)
          
          setRightBarButton()
          setLeftBarItem()
          title = "Petitions"
          navigationController?.navigationBar.prefersLargeTitles = true
     }
     
     // MARK: - Logic
     
     @objc  func getData() {
          let urlString: String
          
          if navigationController?.tabBarItem.tag == 0 {
               urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
          } else {
               urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
          }
          
          if let url = URL(string: urlString) {
               if let data  = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
               }
          }
          performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
     }
     
     func parse(json: Data) {
          let decoder = JSONDecoder()
          
          if let jsonPetition = try? decoder.decode(Petitions.self, from: json) {
               petitions = jsonPetition.results
               
               tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
          } else {
               performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
          }
     }
     
     @objc func showError() {
          DispatchQueue.main.async {
               let alertController = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "Ok", style: .default))
               self.present(alertController, animated: true)
          }
     }
     
     private func setRightBarButton() {
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .done, target: self, action: #selector(creditsButton))
     }
     
     private func setLeftBarItem() {
          navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(filterButton))
     }
     
     @objc func creditsButton() {
          let alertController = UIAlertController(title: nil, message: "Data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Ok", style: .default))
          present(alertController, animated: true)
     }
     
     @objc func filterButton() {
          
          let alertController = UIAlertController(title: "Filter", message: "This is filter button", preferredStyle: .alert)
          alertController.addTextField()
          alertController.addAction(UIAlertAction(title: "Filter", style: .default, handler: { UIAlertAction
               in
               guard let word = alertController.textFields?[0].text else {return}
               self.filter = true
               DispatchQueue.global(qos: .userInitiated).async {
                    self.petitions.forEach { petition in
                         if petition.body.contains(word) || petition.title.contains(word) {
                              self.filterPetitions.insert(petition, at: 0)
                         }
                    }

               }
               DispatchQueue.main.async {
                    self.tableView.reloadData()
               }
          }))
          alertController.addAction(UIAlertAction(title: "Cancel filter", style: .cancel, handler: { UIAlertAction in
               self.filter = false
               self.tableView.reloadData()
          }))
          present(alertController, animated: true)
     }
     
     
     
     
     // MARK: - TableView
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if filter == false {
               return   petitions.count
          } else {
               return filterPetitions.count
          }
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          let petition = (filter) ? filterPetitions[indexPath.row] : petitions[indexPath.row]
          cell.textLabel?.text = petition.title
          cell.detailTextLabel?.text = petition.body
          return cell
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let viewController = DetailViewController()
          viewController.detailItem = (filter) ? filterPetitions[indexPath.row] : petitions[indexPath.row]
          navigationController?.pushViewController(viewController, animated: true)
     }
     
     
}

