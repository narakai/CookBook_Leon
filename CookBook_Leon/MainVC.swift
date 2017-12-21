//
//  MainVC.swift
//  CookBook_Leon
//
//  Created by lai leon on 2017/12/21.
//  Copyright © 2017 clem. All rights reserved.
//

import UIKit
import SideMenu


struct ShowData {
    var jianjie: String
    var tags: String
    var thumb_2: String
    var views: NSInteger
    var title: String
    var thumb: String
    var ID: NSInteger
    var catename: String
    var subcatename: String
    var edittime: String
    var menuTitle: String

    static func parseData(data: Any?) -> [ShowData]? {
        if let data = data {
            var result = [ShowData]()
            let dic = data as! NSDictionary
            let arr = dic["list"] as! NSArray
            for content in arr {
                let dic = content as! NSDictionary
                let arr = dic["list"] as! NSArray
                let title = dic["title"] as! String
                for content in arr {
                    let dic = content as! NSDictionary
                    let menu = ShowData(jianjie: dic["jianjie"] as! String,
                            tags: dic["tags"] as! String,
                            thumb_2: dic["thumb_2"] as! String,
                            views: dic["views"]! as! NSInteger,
                            title: dic["title"] as! String,
                            thumb: dic["thumb"] as! String,
                            ID: dic["ID"]! as! NSInteger,
                            catename: dic["catename"] as! String,
                            subcatename: dic["subcatename"] as! String,
                            edittime: dic["edittime"] as! String,
                            menuTitle: title)
                    result.append(menu)
                }
                return result
            }
        }
        return nil
    }
}

class MainVC: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: YHNoNavRect, style: .plain)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    let reuseIdentifer = "MainCell"
    var datas = [ShowData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NetManager.share.mainData(url: mainURL)
        NetManager.share.delegates.append(self)
        configSideMenu()
        setupView()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        title = "菜谱"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: self, action: #selector(showSideMunu))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bgimg"), for: .topAttached, barMetrics: .default)
        navigationController?.navigationBar.barStyle = .black//如果有导航栏，需要设置状态栏颜色，需要通过该方法实现

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainCustomCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
    }

    @objc func showSideMunu() {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    func configSideMenu() {
        let menu = UISideMenuNavigationController(rootViewController: ViewController())
        menu.leftSide = true
        SideMenuManager.menuLeftNavigationController = menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .viewSlideInOut
        SideMenuManager.menuAnimationFadeStrength = 0.5//隐藏度
        SideMenuManager.menuShadowOpacity = 0.5//阴影透明度
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MainCustomCell
        cell.buildUI(data: datas[indexPath.row])
        return cell
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = datas[indexPath.row]
        let show = ShowVC()
        show.ID = data.ID
        show.title = data.title
        navigationController?.pushViewController(show, animated: true)
    }
}

extension MainVC: NetDelegate {
    func dataDownload<DATA>(datas: [DATA]?, type: DataType) {
        guard let datas = datas, type == DataType.MainData else {
            return
        }
        self.datas.removeAll()
        for data in datas {
            self.datas.append(data as! ShowData)
        }
        DispatchQueue.main.async {
            let data = self.datas.first
            self.title = data?.menuTitle
            self.tableView.reloadData()
            NetManager.share.HUDHide()
        }
    }


}