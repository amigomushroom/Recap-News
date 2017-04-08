//
//  ArticleView.swift
//  MiNews
//
//  Created by Ami Zou on 4/6/17.
//  Copyright © 2017 ECON327H. All rights reserved.
//  
//  Use newsAPI for news resources
//  API key: 3e56f15fb422469082480f36fa7609c4
/* Json sample:
 {
 "status": "ok",
 "source": "google-news",
 "sortBy": "top",
 -"articles": [
 -{
 "author": "Matt Flegenheimer",
 "title": "Senate Republicans Deploy ‘Nuclear Option’ to Clear Path for Gorsuch",
 "description": "With the filibuster done, Republicans abandoned long-held practices and lifted President Trump’s nominee, Neil M. Gorsuch, with a simple majority vote.",
 "url": "https://www.nytimes.com/2017/04/06/us/politics/neil-gorsuch-supreme-court-senate.html",
 "urlToImage": "https://static01.nyt.com/images/2017/04/07/us/07gorsuch1_hp/07gorsuch1_hp-facebookJumbo.jpg",
 "publishedAt": "2017-04-06T19:38:13Z"
 },
 */

import UIKit

class ArticleView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchArticles()
    }
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=google-news&sortBy=top&apiKey=3e56f15fb422469082480f36fa7609c4")! ) //put a string URL inside -- now: Google News
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            self.articles = [Article]() //pass the error check statement, now we can initialize the arry
            
            do { //see upper comment for Json example
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]]{ //array of article arrays
                    for articleFromJson in articlesFromJson{ //iterate through the list of articles
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String,
                           let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String,
                           let urlToImage = articleFromJson["urlToImage"] as? String {
                            article.headline = title
                            article.desc = desc
                            article.author = author
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async { //run in the main thread in stead of in back
                    self.tableView.reloadData() //reload data
                }
                
            } catch let error{
                print(error)
            }
        }
        task.resume() //resume the task
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell //type
        
        //cell.title.text = self.articles?[indexPath.item].headline //remember to unwrap it first
        //cell.desc.text = self.articles?[indexPath.item].desc
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.articles?.count ?? 0 //one-line if statement: or else return 0
        return 0
    }
    
    
}