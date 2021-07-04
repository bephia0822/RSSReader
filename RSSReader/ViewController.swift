//
//  ViewController.swift
//  RSSReader
//
//  Created by Sophia Wang on 2021/4/10.
//

import UIKit

struct NewsItem {
    var title: String?
    var link: String?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var myTableView: UITableView!
    var objects = [NewsItem]()
    let xmlAddress = "https://www.cnet.com/rss/news/"
    var session = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource  = self
        myTableView.delegate = self
        downloadXML(withXMLAddress: xmlAddress)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = objects[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showinfo"{
            if let dvc = segue.destination as? WebViewController{
                //dvc.linkFromViewOne
                if let selectedRow = myTableView.indexPathForSelectedRow?.row{
                    dvc.linkFromViewOne = objects[selectedRow].link
                }
            }
        }
    }
    
    func downloadXML(withXMLAddress xmlAddress: String) {
        if let url = URL(string: xmlAddress){
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil{
                    DispatchQueue.main.async {
                        self.popAlert(withTitle: "Sorry")
                    }
                    return
                }
                if let okData = data{
                    let parser = XMLParser(data: okData)
                    let rssParserDelegate = RSSParserDelegate()
                    parser.delegate = rssParserDelegate
                    if parser.parse() == true{
                        self.objects = rssParserDelegate.getResult()
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }else{
                        print("parse fail")
                    }
                }
                
            })
            task.resume()
        }
    }
    func popAlert(withTitle title: String) {
        let alert = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

