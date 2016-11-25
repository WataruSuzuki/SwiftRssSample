//
//  DetailViewController.swift
//  SwiftRssSample
//
//  Created by WataruSuzuki on 2016/11/21.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let web = self.myWebView {
                web.loadRequest(URLRequest(url: detail))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: URL? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

