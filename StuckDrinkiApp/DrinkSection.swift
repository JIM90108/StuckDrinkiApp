//
//  DrinkSection.swift
//  StuckDrinkiApp
//
//  Created by 彭有駿 on 2022/6/2.
//

import Foundation
import Foundation

enum OrderInfo :CaseIterable {
case orderer
case size
case sugar
case temp
case feed
}
enum Size: String, CaseIterable {
    case medium = "中杯"
    case large = "大杯"
}
enum Sugar: String, CaseIterable {
    case normal = "正常糖"
    case less = "少糖"
    case half = "半糖"
    case few = "微糖"
    case two_cent = "二分糖"
    case cent = "一分糖"
    case nosuger = "無糖"
}

enum Temp: String, CaseIterable {
    case normalIce = "正常冰"
    case less = "少冰"
    case few = "微冰"
    case noice = "去冰"
    case hot = "熱"
}

enum Feed: String, CaseIterable {
    case white = "加奶昔"
    case black = "加巧克力奶昔"
}

enum FeedPrice: Int, CaseIterable {
    case white = 10
    case black = 15
}

// cast String as Enum
extension CaseIterable {
    static func from(string: String) -> Self? {
        return Self.allCases.first { string == "\($0)" }
    }
    func toString() -> String { "\(self)" }
}
