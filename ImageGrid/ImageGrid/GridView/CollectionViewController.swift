//
//  CollectionViewController.swift
//  ImageGridView
//
//  Created by Michele Fadda on 04/06/2020.
//

import UIKit
import FeedLoaderiOS

private let reuseIdentifier = "GridViewCell"


class CollectionViewController: UICollectionViewController {

    func loadData() {
        let jsonUrlString = "https://randomuser.me/api/?results=500"
        guard let url = URL (string: jsonUrlString)
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            let decoder = JSONDecoder()
            if let results = try? decoder.decode(Results.self, from: data) {
            
                DispatchQueue.main.async {
                    self.users = results.results;
                    self.collectionView.reloadData()
                }
            } else {
                print ("decoding error")
            }
        }.resume()
    }

    var users: [User] = []
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridViewCell 
    
        // Configure the cell

        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        if let urlStringThumbnail = users[indexPath.item].picture.thumbnail {
            if let url = URL(string: urlStringThumbnail) {
                cell.image.fetchImage(from: url)
            }
        }
        
        return cell
    }
    
}


extension CollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print ("Prefetch: \(indexPaths)" )
        
        for item in indexPaths.map({ip in ip.row }) {
            if let urlString = users[item].picture.thumbnail {
                print (urlString)
            }
        }
    }
}
