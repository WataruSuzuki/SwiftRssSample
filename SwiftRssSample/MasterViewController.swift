//
//  MasterViewController.swift
//  SwiftRssSample
//
//  Created by WataruSuzuki on 2016/11/21.
//  Copyright © 2016年 WataruSuzuki. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var rssHelper = RssHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(request))
        self.navigationItem.rightBarButtonItem = refreshButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        request()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func request() {
        rssHelper.didEndParse = {() in
            print(self.rssHelper.rssObj.count)
            print(self.rssHelper.rssObj)
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }

        rssHelper.loadRss(urlStr: CatWho.rssUrl)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let urlLink = rssHelper.rssObj[indexPath.row][CatWho.keyLink] {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = URL(string: urlLink)
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssHelper.rssObj.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.text = rssHelper.cutTitleStr(text: rssHelper.rssObj[indexPath.row][CatWho.keyTitle]!)
        cell.detailTextLabel?.text = rssHelper.cutDescriptionStr(text: rssHelper.rssObj[indexPath.row][CatWho.keyDescription]!)
        
        return cell
    }

}

