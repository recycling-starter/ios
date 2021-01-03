//
//  BoxListViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 03.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit

class BoxListViewController: UITableViewController {
    
    var boxList: [BoxData]
    let router = Router()
    let token: String
    
    init(token: String, boxList: [BoxData]) {
        self.token = token
        self.boxList = boxList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.register(BoxCell.self, forCellReuseIdentifier: String(describing: BoxCell.self))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BoxCell.self), for: indexPath) as! BoxCell
        let box = boxList[indexPath.row]
        cell.configute(with: box)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let box = boxList[indexPath.row]
        router.presentBoxManagmentVC(token: token, boxData: box)
    }
}
