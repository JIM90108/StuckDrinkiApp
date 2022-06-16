//
//  OrderListTableViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/6.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    
    @IBOutlet weak var totalDrinkLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    //設定API
    let apiKey = "keyjel3tOKtSJGpyt"
    let urlStr = "https://api.airtable.com/v0/app2nxltVKfAsfrE5/OrderData"
    
    //設定資料
    var orderDrinkData = [DrinkOrder]()
    var orderListData : OrderRecords?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(urlStr: urlStr)

    }
    
    //更新資料
    override func viewWillAppear(_ animated: Bool) {
        fetchData(urlStr:urlStr)
    
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return orderDrinkData.count
    }
    
    //設定tableView裡的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell",for: indexPath) as! OrderListTableViewCell
        
        //存取資料
        let orderData = orderDrinkData[indexPath.row].fields
        let orderName = orderData.ordererName
        let drinkName = orderData.drinkName
        let drinkSize = orderData.size
        let drinkSugar = orderData.sugar
        let drinkTemp = orderData.temp
        let addFeed = orderData.feed
        let quantity = orderData.quantity
        let totalDrinkPrice = orderData.price

        //顯示資訊
        cell.ordererLabel.text = orderName
        cell.drinkNameLabel.text = drinkName
        cell.sizeLabel.text = drinkSize
        cell.tempLabel.text = drinkTemp
        cell.sugarLabel.text = drinkSugar
        cell.feedLabel.text = addFeed
        cell.totalDrinkCountLabel.text = quantity.description
        cell.totalPriceLabel.text = totalDrinkPrice.description
        
        //清單內飲料全部價格
        var totalPrice = 0
        for i in orderDrinkData{
            totalPrice += i.fields.price
            
            totalPriceLabel.text = totalPrice.description
            if totalPrice == 0{
                totalPriceLabel.text = "0"
            }
        }
        //清單內所有飲料總數
        var totalQuantity = 0
        for i in orderDrinkData{
            totalQuantity += i.fields.quantity
            totalDrinkLabel.text = totalQuantity.description
            if totalQuantity == 0{
                totalDrinkLabel.text = "0"
            }
        }
        
        //顯示飲料圖片
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
    
    // 刪除訂單
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let orderData = orderDrinkData[indexPath.row].fields
        let orderName = orderData.ordererName
        let drinkName = orderData.drinkName
        //加入刪除選項
        if editingStyle == .delete{
            let controller = UIAlertController(title: "\(orderName)的" + "\(drinkName)", message: "確定刪除此筆訂單？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
                let drinkID = self.orderDrinkData[indexPath.row].id
                self.deletefetchData(urlStr: self.urlStr, id: drinkID){
                    print("remove arr Data")
                    self.orderDrinkData.remove(at: indexPath.row)
                    // 刪除後更新
                    DispatchQueue.main.async {
                        //清單內飲料全部價格
                        var totalPrice = 0
                        for i in self.orderDrinkData{
                            totalPrice += i.fields.price
                            
                            self.totalPriceLabel.text = totalPrice.description
                        }
                        //清單內所有飲料總數
                        var totalQuantity = 0
                        for i in self.orderDrinkData{
                            totalQuantity += i.fields.quantity
                            self.totalDrinkLabel.text = totalQuantity.description
                    
                        }
                        if totalQuantity == 0 {
                            self.totalPriceLabel.text = "0"
                        }
                        if totalPrice == 0 {
                            self.totalDrinkLabel.text = "0"
                        }   
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.fetchData(urlStr: self.urlStr)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
            
        }
    }
    
  
    
    //取得資料
    func fetchData(urlStr:String){
        
        let url = URL(string: urlStr)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "Get"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    self.orderListData = try decoder.decode(OrderRecords.self, from: data)
                    DispatchQueue.main.async {
                        print("enter list")
                        self.orderDrinkData = self.orderListData!.records
                        self.tableView.reloadData()
                    }
                }catch{
                    print("fail")
                    print(error)
                }
            }
        }.resume()
    }
    
    //刪除資料
    func deletefetchData(urlStr: String, id: String,completionHandler: @escaping () -> Void){
        
        
        let deleteUrlStr = urlStr + "/\(id)"
        if let url = URL(string: deleteUrlStr){
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, res, err) in
                
                if let data = data {
                    do {
                        let dic = try JSONDecoder().decode(DeleteData.self, from: data)
                        completionHandler()
                        print(dic)
                        print("delete down")
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
        
    }

    //傳資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row,
           let controller = segue.destination as? OrderDrinkViewController{
            controller.delegate = self
            let selectedOrderDrinkData = self.orderDrinkData[row]

            // 將DrinkOrderView改為修改訂單模式
            controller.updateOrderData = true
            controller.orderDataID = selectedOrderDrinkData.id
            controller.ordererName = selectedOrderDrinkData.fields.ordererName
            controller.size = selectedOrderDrinkData.fields.size
            controller.temp = selectedOrderDrinkData.fields.temp
            controller.sugar = selectedOrderDrinkData.fields.sugar
            controller.drinkPrice = selectedOrderDrinkData.fields.price
            controller.drinkQuantity = selectedOrderDrinkData.fields.quantity
            controller.drinkImageURL = selectedOrderDrinkData.fields.drinkImage
            controller.drinkName = selectedOrderDrinkData.fields.drinkName

            // 將feed從String轉為[String]
            let feed = selectedOrderDrinkData.fields.feed
            print(feed)
            guard feed != "  " else {
                print("enter guard")
                return controller.feed = ["",""]
            }
            controller.feed = feed.components(separatedBy: " ")
        }
            
            
        }
    }

    
    

