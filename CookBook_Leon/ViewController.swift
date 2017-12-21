//
//  ViewController.swift
//  CookBook_Leon
//
//  Created by lai leon on 2017/12/21.
//  Copyright © 2017 clem. All rights reserved.
//

import UIKit

//后面的菜系菜单

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)

struct MenuData {
    var title: String
    var type: String
    var apiurl: String
    var icon: String

    static func parseData(data: Any?) -> [MenuData]? {
        if let data = data {
            var result = [MenuData]()
            let dic = data as! NSDictionary
            let arr = dic["category"] as! NSArray
            for content in arr {
                let dic = content as! NSDictionary
                var menu = MenuData(title: dic["title"] as! String,
                        type: dic["type"] as! String,
                        apiurl: dic["apiurl"] as! String,
                        icon: dic["icon"] as! String)
                if menu.title == "首页" {
                    menu.apiurl = mainURL
                }
                result.append(menu)
            }
            print(result)
            return result
        }
        return nil
    }
}

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: YHRect, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: YHWidth - 280)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    let reuseIdentifer = "ReuseIdentifer"
    var datas = [MenuData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.isNavigationBarHidden = true
        NetManager.share.menuData()
        NetManager.share.delegates.append(self)
        setupView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        view.layer.contents = UIImage(named: "menu_bg")?.cgImage
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        let data = self.datas[indexPath.row]
        cell.selectionStyle = .gray
        cell.backgroundColor = .clear
        cell.textLabel?.text = "          " + data.title
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        let oldImage = cell.viewWithTag(1) ?? UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        cell.addSubview(oldImage)
        guard let url = URL(string: data.icon) else {
            return cell
        }
        NetManager.share.downImage(imageView: oldImage as! UIImageView, imageURL: url)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        if ["收藏", "更多"].contains(data.title) {

        } else {
            NetManager.share.mainData(url: data.apiurl)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: NetDelegate {
    func dataDownload<DATA>(datas: [DATA]?, type: DataType) {
        guard let datas = datas, type == DataType.MenuData else {
            return
        }
        for data in datas {
            self.datas.append(data as! MenuData)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            NetManager.share.HUDHide()
        }
    }
}
