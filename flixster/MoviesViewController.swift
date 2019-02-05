//
//  MoviesViewController.swift
//  flixster
//
//  Created by Dany Munoz on 2/1/19.
//  Copyright © 2019 danielmunoz. All rights reserved.
//

import UIKit
import AlamofireImage


//import data and delegate for table view
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //creation of an array of dictionaries
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //results from movies API are now stored in movies variable
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                //call all functions below again
                self.tableView.reloadData()
                print(dataDictionary)
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //recycle cells, good practice for tables with many cells used
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        
        //cell.textLabel?.text = title
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        //add image with 185px size
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        
        
        
        
        
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
