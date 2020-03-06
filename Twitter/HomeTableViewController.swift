//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Benny Ooi Kean Hoe on 2/28/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == tweetArray.count {
//            loadMoreTweets()
//        }
//    }
    
    @objc func loadTweet() {
        //numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 20]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
//    func loadMoreTweets() {
//        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
//        numberOfTweet = numberOfTweet + 20
//        let myParams = ["count": numberOfTweet]
//        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
//            self.tweetArray.removeAll()
//            for tweet in tweets {
//                self.tweetArray.append(tweet)
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }, failure: { (error) in
//            print(error.localizedDescription)
//        })
//    }

    @IBAction func logoutPressed(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imgUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        cell.profileImageView.af_setImage(withURL: imgUrl!)
        cell.userNameLabel.text = (user["name"] as! String)
        cell.tweetContentLabel.text = (tweetArray[indexPath.row]["text"] as! String)
        return cell
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

  
}
