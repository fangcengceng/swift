//
//  CityModel.swift
//  cityList
//
//  Created by 北极星 on 2017/7/7.
//  Copyright © 2017年 aa. All rights reserved.
//

import UIKit

class CityModel: NSObject {

    var name: String?
    var cityId: NSInteger? = 0
    var orderBy: NSInteger? = 0
    var parentId: NSInteger? = 0
    
      override init() {
         super.init()
    }
    convenience init(dict: [String: Any]) {
        self.init()
        self.name = dict["Name"] as? String
        self.cityId = dict["ID"] as? NSInteger
    }
    
 
//   class func citys() -> [CityModel]{
//        var citys  = [CityModel]()
//        
//        let path = Bundle.main.path(forResource: "province", ofType: "txt")
//        let citydata = NSData(contentsOfFile: path!)! as Data
//        guard let jsonArray:[[String: Any]] = try? JSONSerialization.jsonObject(with: citydata, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: Any]] else {
//            return []
//        }
//        for dict in jsonArray {
//            let model = CityModel(dict: dict)
//            citys.append(model)
//         }
//        return citys
//
//    }
}
