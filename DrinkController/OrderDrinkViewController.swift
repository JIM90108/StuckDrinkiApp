//
//  ViewController.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/5/31.
//

import UIKit

class OrderDrinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var reduceCountButton: UIButton!
    
    @IBOutlet weak var addCountButton: UIButton!
    
    @IBOutlet weak var drinkQuantityLabel: UILabel!
    @IBOutlet weak var drinkTotalPriceLabel: UILabel!
    
    @IBOutlet weak var customSelectionTableView: UITableView!
    
    @IBOutlet weak var addToOrderListButton: UIButton!
    //串接API的網址
    let urlStr = "https://api.airtable.com/v0/app2nxltVKfAsfrE5/OrderData"
    //API Key
    let apiKey = "keyjel3tOKtSJGpyt"

    //代理(修改頁面跟訂購頁面共用)
    var delegate: OrderListTableViewController?
    
    //接收MenuTableViewController傳來的資料
    //接收資料addToOrderListButton
    var drinkName:String!
    var drinkDescribe:String!
    var drinkImageURL: String!
    var updateOrderData = false
    var orderDataID:String!
    
    //接收MenuTableViewController傳來的資料
    var mediumPrice: Int!
    var largePrice : Int!
    
    //另外儲存的參數
    var orderPrice:Int!
    var drinkPrice = 0
    var feedPrice = 0
    var drinkQuantity = 0
    var ordererName:String!
    var sugar: String!
    var temp: String!
    var feed = ["",""]
    var size: String!
    
    
    //設定選擇飲料的Array並以Boolean判斷
    var sizeChecked = Array(repeating: false, count: Size.allCases.count)
    var tempChecked = Array(repeating: false, count: Temp.allCases.count)
    var sugarChecked = Array(repeating: false, count: Sugar.allCases.count)
    var feedChecked = Array(repeating: false, count: Feed.allCases.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //顯示飲料資訊
        showDrinkMessage()
        print(mediumPrice ?? "")
        print(largePrice ?? "")
        
        //修改訂單
        if updateOrderData {
            addToOrderListButton.setTitle("修改訂單", for: .normal)
        } else {
            addToOrderListButton.setTitle("加入訂單", for: .normal)
            drinkPrice = mediumPrice
        }
        //顯示飲料資訊
        showOrderPrice()
        
        //取得飲料價錢
        getAllDrinkPrice()
        
}
    

    
    //DrinkSection裡OrderInfo設置所設置的
    func numberOfSections(in tableView: UITableView) -> Int {
        OrderInfo.allCases.count
    }
    
    //設定飲料選擇的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let orderInfoType = OrderInfo.allCases[section]
        switch orderInfoType {
        case .size:
            return "容量"
        case .sugar :
            return "甜度"
        case .temp :
            return "溫度"
        case .feed :
            return "加料"
        case .orderer:
            return ""
        }
    }
    
    //選擇飲料內容的設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let orderInfoType = OrderInfo.allCases[section]
        switch orderInfoType {
        case .orderer:
            return 1
        case .size :
            return Size.allCases.count
        case .sugar :
            //這些飲料沒有無糖
            guard drinkName == "咖啡星冰樂" || drinkName == "焦糖星冰樂" || drinkName == "焦糖可可碎片星冰樂" || drinkName == "摩卡可可碎片星冰樂" || drinkName == "芝麻杏仁豆腐星冰樂" || drinkName == "夏日海灘芒果風味星冰樂" || drinkName == "粉紅夢幻星冰樂" || drinkName == "香草風味星冰樂" || drinkName ==  "巧克力可可碎片星冰樂" || drinkName == "抹茶奶霜星冰樂" || drinkName == "雙果果汁星冰樂"
            else {return Sugar.allCases.count}
            return 6
        case .temp :
            //這些飲料沒有去冰
            guard drinkName == "咖啡星冰樂" || drinkName == "焦糖星冰樂" || drinkName == "焦糖可可碎片星冰樂" || drinkName == "摩卡可可碎片星冰樂" || drinkName == "芝麻杏仁豆腐星冰樂" || drinkName == "夏日海灘芒果風味星冰樂" || drinkName == "粉紅夢幻星冰樂" || drinkName == "香草風味星冰樂" || drinkName ==  "巧克力可可碎片星冰樂" || drinkName == "抹茶奶霜星冰樂" || drinkName == "雙果果汁星冰樂"
            else {return Temp.allCases.count}
            return 3
        case .feed :
            return Feed.allCases.count
        }
    }
    
    //設定tableView裡cell的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderInfoType = OrderInfo.allCases[indexPath.section]
        
        switch orderInfoType {
        case .orderer :
            let cell = customSelectionTableView.dequeueReusableCell(withIdentifier: "OrdererTableViewCell") as! OrdererTableViewCell
            cell.ordererLabel.text = "訂購人"
            cell.ordererTextField.placeholder = "請輸入名字"
            cell.ordererTextField.delegate = self
            cell.ordererTextField.text = ordererName
            guard let ordererName = ordererName else { return cell }
            cell.ordererTextField.text = ordererName
            return cell
        case .size :
            let cell = customSelectionTableView.dequeueReusableCell(withIdentifier: "OrderDrinkTableViewCell") as! OrderDrinkTableViewCell
            cell.addPriceLabel.isHidden = true
            cell.feedAddPriceLabel.isHidden = true
            cell.drinkMessageLabel.text = Size.allCases[indexPath.row].rawValue
            
            //設定選擇按鈕
            if sizeChecked[indexPath.row] {
                cell.optionBtnImageView.image = UIImage(named: "radio_on")
            } else {
                cell.optionBtnImageView.image = UIImage(named: "radio_off")
            }

            return cell
            
            
        case .sugar :
            let cell = customSelectionTableView.dequeueReusableCell(withIdentifier: "OrderDrinkTableViewCell") as! OrderDrinkTableViewCell
            cell.addPriceLabel.isHidden = true
            cell.feedAddPriceLabel.isHidden = true
            cell.drinkMessageLabel.text = Sugar.allCases[indexPath.row].rawValue
            
            if sugarChecked[indexPath.row] {
                cell.optionBtnImageView.image = UIImage(named: "radio_on")
            } else {
                cell.optionBtnImageView.image = UIImage(named: "radio_off")
            }
            return cell
        case .temp :
            let cell = customSelectionTableView.dequeueReusableCell(withIdentifier: "OrderDrinkTableViewCell") as! OrderDrinkTableViewCell
            cell.addPriceLabel.isHidden = true
            cell.feedAddPriceLabel.isHidden = true
            cell.drinkMessageLabel.text = Temp.allCases[indexPath.row].rawValue
            
            if tempChecked[indexPath.row] {
                cell.optionBtnImageView.image = UIImage(named: "radio_on")
            } else {
                cell.optionBtnImageView.image = UIImage(named: "radio_off")
            }
            return cell
        case .feed :
            let cell = customSelectionTableView.dequeueReusableCell(withIdentifier: "OrderDrinkTableViewCell") as! OrderDrinkTableViewCell
            cell.drinkMessageLabel.text = Feed.allCases[indexPath.row].rawValue
            
            if feedChecked[indexPath.row] {
                cell.optionBtnImageView.image = UIImage(named: "radio_on")
            } else {
                cell.optionBtnImageView.image = UIImage(named: "radio_off")
            }
            
            cell.addPriceLabel.isHidden = false
            cell.feedAddPriceLabel.isHidden = false
            if cell.drinkMessageLabel.text == Feed.white.rawValue {
                cell.feedAddPriceLabel.text = String(FeedPrice.white.rawValue)
            } else {
                cell.feedAddPriceLabel.text = String(FeedPrice.black.rawValue)
            }
            return cell
        }
        
        
    }
    
    
    //cell點擊事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderInfoType = OrderInfo.allCases[indexPath.section]
        switch orderInfoType {
        case .orderer :
            return
        case .size:
            //設定為false，每次點選都只能選一個
            sizeChecked = Array(repeating: false, count: Size.allCases.count)
            sizeChecked[indexPath.row] = !sizeChecked[indexPath.row]
            size = Size.allCases[indexPath.row].rawValue
            if sizeChecked[indexPath.row] {
                if indexPath.row == 0 {
                    drinkQuantity = 1
                    drinkPrice = mediumPrice
                } else {
                    guard let largePrice = largePrice else { return drinkPrice = mediumPrice }
                    drinkPrice = largePrice
                }
            }
            
            showOrderPrice()
        case .sugar:
            sugarChecked = Array(repeating: false, count: Sugar.allCases.count)
            sugarChecked[indexPath.row] = !sugarChecked[indexPath.row]
            sugar = Sugar.allCases[indexPath.row].rawValue
        case .temp:
            print(!tempChecked[indexPath.row])
            tempChecked = Array(repeating: false, count: Temp.allCases.count)
            tempChecked[indexPath.row] = !tempChecked[indexPath.row]
            temp = Temp.allCases[indexPath.row].rawValue
        case .feed:
            //不強制設定為false還是true，因為可以多選
            feedChecked[indexPath.row] = !feedChecked[indexPath.row]
            //可以印出來看
            print(feedChecked[indexPath.row])
            //如果是ture則要加價錢
            if feedChecked[indexPath.row] {
                feedPrice += FeedPrice.allCases[indexPath.row].rawValue
                feed[indexPath.row] = Feed.allCases[indexPath.row].rawValue
            } else {
                feedPrice -= FeedPrice.allCases[indexPath.row].rawValue
                feed[indexPath.row] = ""
            }
            showOrderPrice()
        }
        tableView.reloadData()
    }
    
    //顯示價格
    func showOrderPrice() {
        print("show Order Price")
        orderPrice = (drinkPrice + feedPrice) * drinkQuantity
        drinkQuantityLabel.text = drinkQuantity.description
        drinkTotalPriceLabel.text = orderPrice.description
    }
   
    
    
    
    
    //設定飲料減少數量
    @IBAction func reduceCountAction(_ sender: Any) {
        if drinkQuantity > 1 {
            drinkQuantity -= 1
        } else {
            drinkQuantity = 0
        }
        drinkQuantityLabel.text = drinkQuantity.description
        showOrderPrice()
    }
    
    
    //設定飲料增加數量
    @IBAction func addCountAction(_ sender: Any) {
        
        drinkQuantity += 1
        drinkQuantityLabel.text = drinkQuantity.description
        showOrderPrice()
    }
    
    
    // 設置將飲料上傳至Airtable裡的OrderData
    func updateData(){
        let orderData = OrderData(ordererName: ordererName , drinkName: drinkName, temp: temp, sugar: sugar, size: size, feed: feedToString(), quantity: drinkQuantity, drinkImage: drinkImageURL,price: orderPrice)
        let drinkOrderData = PostDrinkOrder(fields: orderData)
        // set request method ＆ content type
        let url: URL?
        //如果updateOrderData是false則修改否則上傳
        if updateOrderData {
            guard let id = orderDataID else { return }
            let updateURL = urlStr + "/\(id)"
            url = URL(string: updateURL)!
        } else {
            url = URL(string: urlStr)!
        }
        var urlRequest = URLRequest(url: url!)
        if updateOrderData {
            urlRequest.httpMethod = "PUT"
        } else {
            urlRequest.httpMethod = "POST"
        }
        // set HTTPHeaderField
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 搭配jsonEncoder將自訂型別變成JSON格式的Data
        let jsonEncoder = JSONEncoder()
        print("bulid jsonEncoder")
        if let data = try? jsonEncoder.encode(drinkOrderData) {
            print("try json encoder")
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                // 檢查是否上傳成功
                if let response = res as? HTTPURLResponse,
                   response.statusCode == 200,
                   err == nil {
                    print("success")
                } else {
                    print(err)
                }
            }.resume()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ordererName = textField.text
        //print(ordererName)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    
    
    @IBAction func addOrderDrinkBtn(_ sender: Any) {
        //判斷button為加入訂單或是修改訂單
        var addToOrderListtButtonTitle: String!
        if addToOrderListButton.titleLabel?.text == "加入訂單" {
            addToOrderListtButtonTitle = "加入訂單"
        } else {
            addToOrderListtButtonTitle = "修改訂單"
        }
        let controller = UIAlertController(title: addToOrderListtButtonTitle, message: "", preferredStyle: .alert)
        
        //按下確認後透過handler顯示alert並將資料上傳至Aittable
        let action = UIAlertAction(title: "確定", style: .default,handler: {action in
            // 檢查選項
            guard self.checkOption() else { return }
            // 將訂單上傳至Database
            self.updateData()
            //判斷button為修改訂單時alert顯示為修改完成並跳回主頁面
            if self.addToOrderListButton.titleLabel?.text == "修改訂單"{
                addToOrderListtButtonTitle = "修改完成"
            }
                let controller = UIAlertController(title: addToOrderListtButtonTitle, message: "", preferredStyle: .alert)
            //按下確認後透過handler執行
            let action = UIAlertAction(title: "確認", style: .default,handler: {action in
                
                //跳回主頁面
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                self.present(vc!, animated: true,completion: nil)
            })
            controller.addAction(action)
            self.present(controller, animated: true,completion: nil)
        })
        let cancel = UIAlertAction(title: "取消", style: .cancel,handler: nil)
        controller.addAction(action)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
        
    }
    
    //判斷飲料資訊是否都有選擇
    func checkOption() -> Bool {
        print(sizeChecked,sugarChecked,tempChecked,ordererName)
        var check = false
        sizeChecked.forEach {
            guard $0 == true else { return }
            sugarChecked.forEach {
                guard $0 == true else { return }
                tempChecked.forEach {
                    guard $0 == true else { return }
                    guard let _ = ordererName else { return }
                    check = true
                }
            }
        }
        
        if check == false {
            let controller = UIAlertController(title: "", message: "資料未填寫完全", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        return check
    }
    
    
    //轉型
    func feedToString() -> String {
        var feedStr = ""
        for feed in feed {
            feedStr += feed+" "
        }
        return feedStr
    }
    
    
    
    
    //顯示飲料資訊
    func showDrinkMessage(){
        drinkNameLabel.text = drinkName
        describeLabel.text = drinkDescribe
        if let imageUrl = URL(string: drinkImageURL){
            URLSession.shared.dataTask(with: imageUrl ) {data, response, error in
                if let photo = data {
                    DispatchQueue.main.async {
                        self.drinkImageView.image = UIImage(data: photo)
                    }
                }
            }.resume()
        }
        
    }
    
    //獲取飲料價格資訊
    func getAllDrinkPrice(){
        var drinkName = drinkNameLabel.text
        
        if drinkName == "咖啡星冰樂"{
            mediumPrice = 105
            largePrice = 125
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "焦糖星冰樂"{
            mediumPrice = 130
            largePrice = 150
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "焦糖可可碎片星冰樂"{
            mediumPrice = 145
            largePrice = 165
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "摩卡可可碎片星冰樂"{
            mediumPrice = 145
            largePrice = 165
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
            
        }else if drinkName == "芝麻杏仁豆腐星冰樂"{
            mediumPrice = 140
            largePrice = 160
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
            
        }else if drinkName == "夏日海灘芒果風味星冰樂"{
            mediumPrice = 145
            largePrice = 165
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "粉紅夢幻星冰樂"{
            mediumPrice = 130
            largePrice = 150
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "香草風味星冰樂"{
            mediumPrice = 95
            largePrice = 115
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "巧克力可可碎片星冰樂"{
            mediumPrice = 120
            largePrice = 140
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "抹茶奶霜星冰樂"{
            mediumPrice = 140
            largePrice = 160
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "雙果果汁星冰樂"{
            mediumPrice = 115
            largePrice = 135
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "福吉茶那堤"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰醇濃抹茶那堤"{
            mediumPrice = 135
            largePrice = 150
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰福吉茶那堤"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "粉紅夢幻醇濃抹茶那堤"{
            mediumPrice = 140
            largePrice = 155
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "伯爵茶那堤"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰經典紅茶那堤"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰抹茶那堤"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰搖檸檬紅茶"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰蜜柚紅茶"{
            mediumPrice = 125
            largePrice = 140
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "冰搖檸檬果茶"{
            mediumPrice = 110
            largePrice = 120
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "每日精選咖啡"{
            mediumPrice = 85
            largePrice = 95
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "可可綿雲瑪奇朵"{
            mediumPrice = 140
            largePrice = 155
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "可可瑪奇朵"{
            mediumPrice = 140
            largePrice = 155
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "雲朵冰搖濃縮咖啡"{
            mediumPrice = 130
            largePrice = 145
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "那堤"{
            mediumPrice = 120
            largePrice = 135
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "焦糖瑪奇朵"{
            mediumPrice = 140
            largePrice = 155
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "摩卡"{
            mediumPrice = 135
            largePrice = 150
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "卡布奇諾"{
            mediumPrice = 120
            largePrice = 135
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else if drinkName == "特選馥郁那堤"{
            mediumPrice = 145
            largePrice = 160
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }else{
            mediumPrice = 135
            largePrice = 150
            drinkQuantityLabel.text = "0"
            drinkTotalPriceLabel.text = "0"
        }
        
    }
    
    
}

