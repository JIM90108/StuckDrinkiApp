//
//  OrderListViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/2.
//

import UIKit

class OrderListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var totalDrinkLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    @IBOutlet weak var ListTableView: UITableView!
    
    let apiKey = "keyjel3tOKtSJGpyt"
    let urlStr = "https://api.airtable.com/v0/app2nxltVKfAsfrE5/OrderData"
    
    
    var menuData: Array<Record> = []
    var orderDrinkData = [DrinkOrder]()
    
    var orderListData : OrderRecords?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(urlStr: urlStr)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData(urlStr: urlStr)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDrinkData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell",for: indexPath) as! OrderListTableViewCell
        
        let orderData = orderDrinkData[indexPath.row].fields
        let orderName = orderData.ordererName
        let drinkName = orderData.drinkName
        let drinkSize = orderData.size
        let drinkTemp = orderData.temp
        let drinkSugar = orderData.sugar
        let drinkFeed = orderData.feed
        let drinkQuantity = orderData.quantity
        
        cell.ordererLabel.text = orderName
        cell.drinkNameLabel.text = drinkName
        cell.sizeLabel.text = drinkSize
        cell.tempLabel.text = drinkTemp
        cell.sugarLabel.text = drinkSugar
        cell.feedLabel.text = drinkFeed
        cell.totalDrinkCountLabel.text = String(drinkQuantity)
        
        if let imageUrl = URL(string: orderData.drinkImage) {
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
    
    
    
    
    func fetchData(urlStr:String){
        
        let url = URL(string: urlStr)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "Get"
        urlRequest.setValue("Bearer\(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    self.orderListData = try decoder.decode(OrderRecords.self, from: data)
                    DispatchQueue.main.async {
                        print("OK")
                        self.orderDrinkData = self.orderListData!.records
                        self.ListTableView.reloadData()
                    }
                }catch{
                    print("fail")
                    print(error)
                }
            }
        }.resume()
    }
    
    
    
    
    
    
}
 

