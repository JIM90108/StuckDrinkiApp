//
//  Menu2TableViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/7.
//

import UIKit
private let cellID = "Menu2TableViewCell"
class Menu2TableViewController: UITableViewController {
    var menuData : Array<Record> = []
    
    let urlStr = "https://api.airtable.com/v0/app2nxltVKfAsfrE5/Menu2?sort[][field]=sort"
    let apiKey = "keyjel3tOKtSJGpyt"

    override func viewDidLoad() {
        super.viewDidLoad()

        fectchData(urlStr: urlStr)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! Menu2TableViewCell
        cell.drinkNameLabel.text = menuData[indexPath.item].fields.drinkName
        cell.mediumPriceLabel.text = String(menuData[indexPath.item].fields.mediumPrice)
        cell.lagerPriceLabel.text = String(menuData[indexPath.item].fields.largePrice)
        cell.drinkImageView.image = nil
        if let imageUrl = URL(string: menuData[indexPath.item].fields.drinkImage[0].url){
            
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                
                if let data = data {
                    DispatchQueue.main.async {
                        cell.drinkImageView.image = UIImage(data: data)
                    }
                }
                
            }.resume()
            
        }
        return cell
    }
    func fectchData(urlStr:String){
        
        let url = URL(string: urlStr)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "Get"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let result = try decoder.decode(ResponseData.self, from: data)
                    self.menuData = result.records
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
            }
            
        }.resume()
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? OrderDrinkViewController
        if let row = tableView.indexPathForSelectedRow?.row{
            controller?.drinkName = menuData[row].fields.drinkName
            controller?.drinkDescribe = menuData[row].fields.describe
            controller?.drinkImageURL = menuData[row].fields.drinkImage[0].url
            controller?.mediumPrice = menuData[row].fields.mediumPrice
            controller?.largePrice = menuData[row].fields.largePrice
            
            

        }
    }

    
    
    

}
