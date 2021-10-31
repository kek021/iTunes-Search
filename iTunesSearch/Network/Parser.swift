//
//  Parser.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import Foundation

// MARK: - json parsing methods

class Parser{
    
    let loader = Loader()
    
    func parseAlbums(url: String, response: @escaping (Albums?) -> Void){
        loader.getData(url: url) { (results) in
            switch results {
            case .success(let data):
                do{
                    let result = try JSONDecoder().decode(Albums.self, from: data)
                  response(result)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func parseSongs(url: String, response: @escaping (Songs?) -> Void){
        loader.getData(url: url) { (results) in
            switch results {
            
            case .success(let data):
                do{
                    let result = try JSONDecoder().decode(Songs.self, from: data)
                  response(result)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}

