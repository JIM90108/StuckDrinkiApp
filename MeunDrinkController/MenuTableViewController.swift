//
//  MenuTableViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/1.
//

import UIKit

//設定TableViewCell的identify
private let cellID = "MenuTableViewCell"

class MenuTableViewController: UITableViewController {
    
    //抓取資料
    var menuData : Array<Record> = []
    
    //設置API //sort[][field]=sort利用這個做排序
    let urlStr = "https://api.airtable.com/v0/app2nxltVKfAsfrE5/Menu?sort[][field]=sort"
    let apiKey = "keyjel3tOKtSJGpyt"

    override func viewDidLoad() {
        super.viewDidLoad()
        //抓取資料
        fectchData(urlStr: urlStr)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    //設定tableview的section總數為Menu的總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuData.count
    }
    //設置TableViewCell裡的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.item)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MenuTableViewCell
        cell.drinkNameLabel.text = menuData[indexPath.item].fields.drinkName
        cell.mediumPriceLabel.text = String(menuData[indexPath.item].fields.mediumPrice)
        cell.lagerPriceLabel.text = String(menuData[indexPath.item].fields.largePrice)
        cell.drinkImageView.image = nil
        if let imageUrl = URL(string: menuData[indexPath.item].fields.drinkImage[0].url){
            
            //圖片需利用URLSession顯示
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
    
    
    //抓取資料利用JSONDecoder解析
    func fectchData(urlStr:String){
        
        let url = URL(string: urlStr)
        var urlRequest = URLRequest(url: url!)
        //抓取資料
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
    
    //將資料傳至OrderDrinkViewController
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
