//
//  cityCache.swift
//  cityList
//
//  Created by 北极星 on 2017/7/7.
//  Copyright © 2017年 aa. All rights reserved.
//

import UIKit
import FMDB

class cityCache: NSObject {
    var dbQueue:FMDatabaseQueue?
    static  let sharedCity = cityCache()
    var provinctArr = [CityModel]()
    
    // 读取省份数据源
    func readoutProvinceData() -> [CityModel] {
        
        openDb()
        transInsertData()


        dbQueue?.inDatabase({ (db) in
            let sq = "select PID,Name from T_PCITY where parentID is NULL"
            guard   let sets = try? db.executeQuery(sq, values: nil) else{
                return
            }
            
         while   sets.next(){
                let model = CityModel()
            model.name = sets.string(forColumn: "Name")
            model.cityId = NSInteger( sets.int(forColumn: "PID"))
            provinctArr.append(model)
            }
            db.close()
        })
        return provinctArr
    }
    
    func readoutCityData() -> [[CityModel]] {
        
        var cityArray = [CityModel]()
        
        var bigArray = [[CityModel]]()

            for model in provinctArr {
                openDb()

                dbQueue?.inDatabase({ (db) in
                    let sq = "select PID,Name from T_PCITY where parentID = ?"
                guard let sets = db.executeQuery(sq, withArgumentsIn: [model.cityId]) else{
                     return
                }
                
                while sets.next(){
                    let model = CityModel()
                    model.name = sets.string(forColumn: "Name")
                    model.cityId = NSInteger( sets.int(forColumn: "PID"))
                    cityArray.append(model)
                }
                
                    
                    
                 db.close()
                })
                bigArray.append(cityArray)

            }
        
      
        return bigArray
    }
    
    
    func readoutAllCityData() -> [[CityModel]] {
        
        openDb()
        
        var modelArray = [CityModel]()
        
        let sql = "select PID,Name from T_PCITY where parentID is not NULL"
        
        
        dbQueue?.inDatabase({ (db) in

                guard let sets = try? db.executeQuery(sql, values: []) else{
                    return
                }
                while sets.next(){
                    let model = CityModel()
                    model.name = sets.string(forColumn: "Name")
                    model.cityId = NSInteger( sets.int(forColumn: "PID"))
                    model.parentId =  NSInteger( sets.int(forColumn: "parentID"))
                    modelArray.append(model)
                    
                }
            db.close()

        })

       
       print(modelArray.count)
        
        return resestSectionArray(array: modelArray)
    }
    
    func resestSectionArray(array: [CityModel]) -> [[CityModel]] {
        var sectionArray = [[CityModel]]()
        var currentArray = [CityModel]()
        let model = array[0]
        currentArray.append(model)
        sectionArray.append(currentArray)
        

        if array.count > 1 {
            
            for i  in 1..<array.count {
                let preArr = [sectionArray[sectionArray.count - 1]]
                let firstModel = preArr[0][0]
                
                let comparModel = array[i]
                if comparModel.parentId == firstModel.parentId {
                    currentArray.append(comparModel)
                }else{
                    currentArray = [CityModel]()
                    currentArray.append(comparModel)
                    sectionArray.append(currentArray)
                }
                
                
            }

        }
        
                return sectionArray
    }
    
    // 打开数据库
     private  func openDb() {
        // 路径
     let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
     let cityPath =  path?.stringByappendingComponentes(string: "city")
        

        if !FileManager.default.fileExists(atPath: cityPath!) {
            guard (try? FileManager.default.createDirectory(atPath: cityPath!, withIntermediateDirectories: false, attributes: nil)) != nil else {
                return
            }
            
        }
        let filePath = cityPath?.stringByappendingComponentes(string: "user005")
        dbQueue = FMDatabaseQueue(path: filePath)
        print("打开数据库成功")
        createTable()
    }
    // 建表
    private func createTable(){
        
        let sq = "create table if not exists T_PCITY(PID integer primary key not null, Name text, OrderByID integer, parentID integer)"
        dbQueue?.inDatabase({ (db) in
           
            guard (try?  db.executeUpdate(sq, values: nil)) != nil else{
                return
            }
        })
        print("建表成功")
 
    }
    
    // 插入数据
    func transInsertData() {
        
        
        let provinceSq = "insert or replace into T_PCITY(PID,Name,OrderByID) values (?,?,?)"
        let citySq =  "insert or replace into T_PCITY(PID,Name,OrderByID,parentID) values (?,?,?,?)"

        let path = Bundle.main.path(forResource: "province", ofType: "txt")
        let citydata = NSData(contentsOfFile: path!)! as Data
        guard let jsonArray:[[String: Any]] = try? JSONSerialization.jsonObject(with: citydata, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: Any]]  else {
            return
        }
        
        guard jsonArray.count > 0 else {
            return
        }
        print(jsonArray.count)
        
        dbQueue?.inTransaction({ (db, rollback) in
            do {
                for dict in jsonArray {
                    let name = dict["Name"]
                    let pid = dict["ID"]
                    let  orderid = dict["OrderByID"]
                    
                    try db.executeUpdate(provinceSq, values: [pid,name,orderid])
                    
                    if (dict["Childlist"] != nil){
                        let childList:[[String: Any]] = dict["Childlist"] as! [[String: Any]]
                        
                        for childDict in childList {
                            guard db.executeUpdate(citySq, withArgumentsIn: [childDict["ID"],childDict["Name"],childDict["OrderByID"],dict["ID"]]) else{
                                return
                            }
                            print("插入成功")
                        }

                    }
        
                }
            }catch{
               rollback.pointee = true
            }
        })

    }

    // 插入数据
    private   func insertData()  {

        
        let provinceSq = "insert or replace into T_PCITY(PID,Name,OrderByID) values (?,?,?)"
        let path = Bundle.main.path(forResource: "province", ofType: "txt")
        let citydata = NSData(contentsOfFile: path!)! as Data
        guard let jsonArray:[[String: Any]] = try? JSONSerialization.jsonObject(with: citydata, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: Any]] else {
            return
        }
        
        print(jsonArray.count)
        
  
        dbQueue?.inDatabase({ (db) in
                guard  db.executeUpdate(provinceSq, withArgumentsIn: [1,"好的",2]) else{
                    return
               
            }
            print("插入成功")

        })
        
        
        
    }
    
    func deletData(naem: String) {
        let sq = "delete from T_PCITY where Name = ?"
        dbQueue?.inDatabase({ (db) in
            guard  db.executeUpdate(sq, withArgumentsIn: ["好的"]) else{
                print("删除失败")
                return
            }
        })
    }
  
    
//    func checkProvinceDatExist() -> NSInteger{
//        
//        var count = 0
//        let sq = "select * from T_CITY where parentID in null"
//        dbQueue?.inDatabase({ (db) in
//            
//            guard let sets = try? db.executeQuery(sq, values: nil) else{
//
//                return 0
//            }
//            while sets.next() {
//             count += 1
//            }
//            if count > 0 {
//                return true
//            }
//            return false
//        })
//    }
    
   
}

extension String {
    func stringByappendingComponentes(string: String) -> String {
        let components = (self as NSString).appendingPathComponent(string)
        return components
    }
}

