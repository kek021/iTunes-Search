//
//  HistoryResultsViewController.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import UIKit

class HistoryResultsViewController: UIViewController {
    
    let parser = Parser()
    var historyDetailAlbums: Albums?
    var historyDetailAlbum: Album?
    var searchString = ""

    @IBOutlet weak var historyResultsCollectionView: UICollectionView!
    
    // MARK: - loading albums by search query from CoreData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyResultsCollectionView.delegate = self
        historyResultsCollectionView.dataSource = self
        loadAlbum(searchUrl: url(text: searchString))
    }
    
    // MARK: - preparing the screen for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.detailAlbum = historyDetailAlbum
        }
    }
    
    // MARK: - function of downloading albums by specific request + sorting by alphabet
    
    func loadAlbum(searchUrl: String){
        self.parser.parseAlbums(url: searchUrl) { historyAlbum in
        guard let historyAlbum = historyAlbum else { return }
            self.historyDetailAlbums = historyAlbum
            self.historyDetailAlbums?.results = historyAlbum.results.sorted(by: {$0.collectionName! < $1.collectionName!})
            self.historyResultsCollectionView.reloadData()
        }
    }
}

extension HistoryResultsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - set size for cells
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = (collectionView.frame.width / 2) - 20
        
        return CGSize(width: widthPerItem, height:widthPerItem + (widthPerItem * 0.4))
    }
    
    // MARK: - configuring cells + next screen segue function

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyDetailAlbums?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyResultsCell", for: indexPath) as! HistoryResultsCollectionViewCell
        let album = historyDetailAlbums?.results[indexPath.row]

        cell.historyResultsAlbumNameLabel.text = album?.collectionName
        cell.historyResultsArtistNameLabel.text = album?.artistName
        
        cell.historyResultsImageView.af.setImage(withURL: URL(string: album!.artworkUrl100!)!, placeholderImage: UIImage(named: "placeholder")!)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        historyDetailAlbum = historyDetailAlbums?.results[indexPath.row]
        self.performSegue(withIdentifier: "historyToDetail", sender: self)
    }
}
