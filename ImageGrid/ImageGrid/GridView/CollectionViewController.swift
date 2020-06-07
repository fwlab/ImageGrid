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
    let remoteFeedLoader = RemoteFeedLoader(from: URL(string: "https://randomuser.me/api/?results=500")!,
                                            client: RemoteFeedClient())
    func loadData() {
        remoteFeedLoader.load { [weak self] (result) in
            switch result {
            case .success(let users):
                    DispatchQueue.main.async {
                        self?.users = users
                        self?.collectionView.reloadData()
                    }
            case .failure(_):
                print("could not load data")
            }
        }
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
