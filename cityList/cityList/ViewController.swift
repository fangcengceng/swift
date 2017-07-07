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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dataArray =  cityCache.sharedCity.readoutProvinceData()
       setupProvinceView()
        
    }
    
    

    func setupProvinceView() {
        
        let tableView = UITableView(frame: CGRect.init(x: 12, y: 64, width: kScrenWidth*0.3, height: kScrenHeigth - 64), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 30
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "province")
        view.addSubview(tableView)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "province", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row].name!

        return cell
    }
    
}
