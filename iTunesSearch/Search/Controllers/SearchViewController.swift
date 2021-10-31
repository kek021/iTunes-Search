//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import UIKit
import AlamofireImage

class SearchViewController: UIViewController {
    
    let parser = Parser()
    let coreData = CoreDataInstance()
    var albums: Albums?
    var album: Album?
    
    let searchController = UISearchController()
    
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    // MARK: - preparing the screen for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.detailAlbum = album
        }
    }
    
    // MARK: - function of downloading albums by request + sorting by alphabet
    
    func loadAlbums(searchUrl: String){
        self.parser.parseAlbums(url: searchUrl) { albums in
        guard let albums = albums else { return }
        self.albums = albums
        self.albums?.results = albums.results.sorted(by: {$0.collectionName! < $1.collectionName!})
        self.searchCollectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - set size for cells
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = (collectionView.frame.width / 2) - 20
        
        return CGSize(width: widthPerItem, height:widthPerItem + (widthPerItem * 0.4))
    }
    
    // MARK: - configure cells

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchController.searchBar.text!.count == 0 {
            backgroundLabel.isHidden = false
        }
        else {
            backgroundLabel.isHidden = true
        }
        
        return albums?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        let album = albums?.results[indexPath.row]
        
        cell.searchAlbumNameLabel.text = album?.collectionName
        cell.searchArtistNameLabel.text = album?.artistName
        cell.searchImageView.af.setImage(withURL: URL(string: album!.artworkUrl100!)!, placeholderImage: UIImage(named: "placeholder")!)

        return cell
    }
    
    // MARK: - go to next screen
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let currentAlbum = albums?.results[indexPath.row]
        album = currentAlbum
        self.performSegue(withIdentifier: "searchToDetail", sender: self)
    }
}

// MARK: - extension for searchbar + saving request in CoreData

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        self.loadAlbums(searchUrl: url(text: searchBar.text!))
        self.coreData.addNewRequest(with: searchBar.text!, date: Date())
    }
}

