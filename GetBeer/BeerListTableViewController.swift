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
    var dataTasks = [URLSessionTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title = "맥주"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        tableView.prefetchDataSource = self
        fetchBeer(of: currentPage)
    }
}

extension BeerListTableViewController: UITableViewDataSourcePrefetching {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
//        print("Rows: \(indexPath.row)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailTableViewController()
        detailViewController.beer = selectedBeer
        show(detailViewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        indexPaths.forEach {
//            print("prefetchRows: \($0.row)")
//        }
        guard currentPage != 1 else { return }
        indexPaths.forEach {
            if ($0.row + 1) / 25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

//data fetching
private extension BeerListTableViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
        dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else { return } // datatask 중복방지
        
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
        dataTasks.append(dataTask)
    }
}
