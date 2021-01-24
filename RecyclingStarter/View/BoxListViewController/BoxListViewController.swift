//
//  BoxListViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 03.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints

class BoxListViewController: UIViewController {
    
    var boxList: [BoxData]
    let router = Router()
    let token: String
    
    let tableView = UITableView()
    
    init(token: String, boxList: [BoxData]) {
        self.token = token
        self.boxList = boxList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupSubViews()
        tableView.register(BoxCell.self, forCellReuseIdentifier: String(describing: BoxCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSubViews() {
        self.view.addSubview(tableView)
        tableView.edgesToSuperview(insets: .left(24) + .right(24), usingSafeArea: true)
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColor.background
        view.backgroundColor = AppColor.background
    }
}

extension BoxListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return boxList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BoxCell.self), for: indexPath) as! BoxCell
        let box = boxList[indexPath.section]
        cell.configute(with: box)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? BoxCell else { return }
        if !cell.beingAnimated {
            cell.startProgressAnimation()
            cell.beingAnimated = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let box = boxList[indexPath.section]
        self.navigationController?.pushViewController(BoxManagmentViewController(token: token, boxData: box), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BoxListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
