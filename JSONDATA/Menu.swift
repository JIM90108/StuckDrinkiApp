//
//  Menu.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/1.
//

import Foundation

struct ResponseData: Codable {
    let records: [Record]
}

struct Record: Codable{
    let id :String
    let fields: Field
}
struct Field:Codable{
    let drinkName:String
    let mediumPrice:Int
    let largePrice:Int
    let drinkImage:[DrinkImage]
    let describe:String
}
struct DrinkImage:Codable{
    let url: String
}

