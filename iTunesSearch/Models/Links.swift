//
//  Links.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import Foundation

// MARK: - function that returns a formatted link as String

func url(text: String) -> String{
    let editedText = text.components(separatedBy: " ").filter { !$0.isEmpty }.joined(separator: "+").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    return "https://itunes.apple.com/search?term=\(editedText)&entity=album&attribute=albumTerm"
}
