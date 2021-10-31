//
//  Loader.swift
//  iTunesSearch
//
//  Created by Александр Жуков on 31.10.2021.
//

import Foundation
import Alamofire

// MARK: - method to load json

class Loader {
    func getData(url: String, completion: @escaping (Result<Data, Error>) -> Void){
        AF.request(url).responseJSON { response in
                DispatchQueue.main.async {
                    if let error = response.error{
                    completion(.failure(error))
                    return
                }
                    guard let data = response.data else { return }
                completion(.success(data))
            }
        }
    }
}
