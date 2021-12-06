//
//  BeerListTableViewController.swift
//  GetBeer
//
//  Created by 장기화 on 2021/12/06.
//

import UIKit

class BeerListTableViewController: UITableViewController {

    var beerList = [Beer]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "맥주"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        fetchBeer(of: currentPage)
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

//data fetching
private extension BeerListTableViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                      print("url session error!!! \(error?.localizedDescription ?? "")")
                      return
                  }
            
            switch response.statusCode {
            case 200...299:
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case 400...499:
                print("client error code: \(response.statusCode), response: \(response)")
            case 500...599:
                print("server error code: \(response.statusCode), response: \(response)")
            default:
                print("error code: \(response.statusCode), response: \(response)")
            }
        }
        dataTask.resume()
    }
}
