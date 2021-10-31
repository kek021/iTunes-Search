//
//  Albums.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import Foundation

// MARK: - parsing model for json with list of albums

struct Albums: Codable {
    var results: [Album]
}

struct Album: Codable {
    let collectionId: Int
    let artistName, collectionName: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let trackCount: Int
}
