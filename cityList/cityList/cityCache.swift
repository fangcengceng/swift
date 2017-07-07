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

    // 读取城市数据源
    func readoutData() -> [CityModel] {
        
        openDb()
        var tempArray = [CityModel]()
        
        dbQueue?.inDatabase({ (db) in
            let sq = "select * from T_PCITY"
            guard   let sets = try? db.executeQuery(sq, values: nil) else{
                return
            }
            
         while   sets.next(){
                let model = CityModel()
            model.name = sets.string(forColumn: "Name")
            model.cityId = NSInteger( sets.int(forColumn: "PID"))
            model.orderBy = NSInteger (sets.int(forColumn: "OrderByID"))
            tempArray.append(model)
            }
            db.close()
        })
       
        return tempArray
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
 
       transInsertData()
    }
    
    // 插入数据
    func transInsertData() {
        
        
        let provinceSq = "insert or replace into T_PCITY(PID,Name,OrderByID) values (?,?,?)"
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
                    print("插入成功")
        
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

