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
    
    private var boxList: [BoxData] {
        didSet {
            boxList.reverse()
        }
    }
    private var userData: UserData
    private let router = Router()
    private let userService = UserServices()
    private var refreshControl = UIRefreshControl()
    
    let tableView = UITableView()
    
    init(userData: UserData) {
        var list = userData.boxes
        list?.reverse()
        self.boxList = list ?? []
        self.userData = userData
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
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -24)
        tableView.clipsToBounds = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColor.background
        view.backgroundColor = AppColor.background
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.backgroundView = refreshControl
    }
}

extension BoxListViewController {
    @objc func refresh(_ sender: AnyObject) {
        reloadList {
            self.refreshControl.endRefreshing()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let box = boxList[indexPath.section]
        let boxVC = configureBoxVC(boxData: box, isAdmin: userData.isAdmin)
        self.navigationController?.pushViewController(boxVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func configureBoxVC(boxData: BoxData, isAdmin: Bool) -> BoxManagmentViewController {
        let vc = BoxManagmentViewController(boxData: boxData, isAdmin: isAdmin)
        vc.delegate = self
        return vc
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

extension BoxListViewController: BoxManagmentDelegate {
    func didClose() {
        reloadList()
    }
    
    private func reloadList(complition: @escaping () -> Void = {}) {
        userService.getUserData { (userData) in
            guard let userData = userData else { return }
            if self.boxList != userData.boxes {
                self.boxList = userData.boxes ?? []
                self.tableView.reloadData()
            }
            complition()
        }
    }
}
