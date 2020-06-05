//
//  CollectionViewController.swift
//  ImageGridView
//
//  Created by Michele Fadda on 04/06/2020.
//

import UIKit

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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let screenWidth = collectionView.visibleSize.width
//
//        return CGSize(width: screenWidth/4-2, height: screenWidth/4-2)
//    }
//}


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
