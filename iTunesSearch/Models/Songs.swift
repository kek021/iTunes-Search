//
//  Songs.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import Foundation

// MARK: - parsing model for json with list of tracks


struct Songs: Codable {
    var results: [Song]
}

struct Song: Codable {
    let wrapperType: String
    let trackCount: Int
    let trackName: String?
}
