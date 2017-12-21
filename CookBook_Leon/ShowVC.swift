//
//  ShowVC.swift
//  CookBook_Leon
//
//  Created by lai leon on 2017/12/21.
//  Copyright © 2017 clem. All rights reserved.
//

import UIKit
import WebKit

class ShowVC: UIViewController {

    let web: WKWebView = {
        let web = WKWebView(frame: YHNoNavRect)
        return web
    }()
    var ID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        web.navigationDelegate = self
        view.addSubview(web)
        guard ID != 0 else {
            return
        }
        NetManager.share.HUDShow()
        web.load(URLRequest(url: URL(string: "http://wp.asopeixun.com/?p=\(ID)")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShowVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载网页")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("加载网页到页面")
        NetManager.share.HUDHide()
    }
}
