//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    let parser = Parser()
    var detailAlbum: Album?
    var detailSongs: Songs?
    var filteredSongs: [Song]?
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailAlbumNameLabel: UILabel!
    @IBOutlet weak var detailArtistNameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    // MARK: - display data received from the previous controller and load list of songs

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.af.setImage(withURL: URL(string: (detailAlbum?.artworkUrl100)!)!, placeholderImage: UIImage(named: "placeholder")!)
        detailAlbumNameLabel.text = detailAlbum?.collectionName
        detailArtistNameLabel.text = (detailAlbum?.artistName)! + " · " + formattedDate(date: (detailAlbum?.releaseDate)!)
        if detailAlbum!.trackCount > 1 {
            trackCountLabel.text = "\(String(describing: detailAlbum!.trackCount)) tracks"
        } else {
            trackCountLabel.text = "\(String(describing: detailAlbum!.trackCount)) track"
        }
        detailTableView.delegate = self
        detailTableView.dataSource = self
        loadSongs(collectionId: detailAlbum!.collectionId)
    }
    
    // MARK: - bring date to a suitable format
    
    func formattedDate(date: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'00'Z"
        
        let year = DateFormatter()
        year.dateFormat = "yyyy"
        let date = year.string(from: formatter.date(from: date)!)
        return date
    }
    
    // MARK: - function of downloading and parsing the list of songs
    
    func loadSongs(collectionId: Int) {
        
        self.parser.parseSongs(url: "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song") { songs in

            guard let songs = songs else { return }
            self.detailSongs = songs
            self.filteredSongs = songs.results.filter({$0.wrapperType == "track"})
            self.detailSongs?.results = self.filteredSongs!
            self.detailTableView.reloadData()
        }
    }
}

// MARK: - configuring cells with a list of tracks

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredSongs?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
        cell.textLabel?.text = "\(indexPath.row + 1)  \(filteredSongs![indexPath.row].trackName!)"
        return cell
    }
}

