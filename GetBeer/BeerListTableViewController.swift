//
//  BeerListTableViewController.swift
//  GetBeer
//
//  Created by 장기화 on 2021/12/06.
//

import UIKit

class BeerListTableViewController: UITableViewController {

    var beerList = [Beer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "맥주"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
    }
}

extension BeerListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailTableViewController()
        detailViewController.beer = selectedBeer
        show(detailViewController, sender: nil)
    }
}
