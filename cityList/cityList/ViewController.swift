//
//  ViewController.swift
//  cityList
//
//  Created by 北极星 on 2017/7/7.
//  Copyright © 2017年 aa. All rights reserved.
//

import UIKit

let kScrenWidth = UIScreen.main.bounds.size.width
let kScrenHeigth = UIScreen.main.bounds.size.height
class ViewController: UIViewController {

    
    var dataArray = [CityModel]()
    var cityArray = [BIgModel]()
    var provinceView: UITableView?
    var cityView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dataArray =  cityCache.sharedCity.readoutProvinceData()
       cityArray = cityCache.sharedCity.readoutAllCityData()
        print(cityArray.count)
        
//        cityArray = cityCache.sharedCity.readoutCityData()
        setupProvinceView()
        setupChildView()
        
        
    }
    func setupChildView()  {
        cityView = UITableView(frame: CGRect.init(x: kScrenHeigth*0.3, y: 64, width: kScrenWidth*0.7, height: kScrenHeigth - 64), style: .grouped)
        cityView?.dataSource = self
        cityView?.delegate = self
        cityView?.rowHeight = 30
        cityView?.register(UITableViewCell.self, forCellReuseIdentifier: "city")
        view.addSubview(cityView!)

    }
    

    func setupProvinceView() {
        
        provinceView = UITableView(frame: CGRect.init(x: 0, y: 64, width: kScrenWidth*0.3, height: kScrenHeigth - 64), style: .plain)
        provinceView?.dataSource = self
        provinceView?.delegate = self
        provinceView?.rowHeight = 30
        provinceView?.register(UITableViewCell.self, forCellReuseIdentifier: "province")
        view.addSubview(provinceView!)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == provinceView ? 1 : cityArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == provinceView ?  dataArray.count : cityArray[section].citysArray.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == provinceView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "province", for: indexPath)
            cell.textLabel?.text = dataArray[indexPath.row].name!
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
            let model = cityArray[indexPath.section].citysArray[indexPath.row];
            
//            cell.textLabel?.text = "\(indexPath.section)" + "\(indexPath.row)"
            cell.textLabel?.text = model.name
            return cell
        }
        
    }
    
}
