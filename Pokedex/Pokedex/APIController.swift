//
//  APIController.swift
//  Pokedex
//
//  Created by Harm on 7/7/23.
//

import Foundation
import UIKit

final class APIController {
    
    enum NetworkError: Error {
        case errorReceiving, noData
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    private lazy var jsonDecoder = JSONDecoder()
    
    func fetchDetails(for pokemonSearch: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void ) {
        
        var request = URLRequest(url: baseURL.appendingPathComponent(pokemonSearch))
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error receiving Pokemon detail data: \(error)")
                completion(.failure(.errorReceiving))
                return
            }
            
            guard let data = data else {
                print("No data received from fetchDetails for Pokemon: \(pokemonSearch)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let pokemon = try self.jsonDecoder.decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                print("Error decoding Pokemon (\(pokemonSearch)) detail data: \(error)")
            }
        }
        
        task.resume()
    }
    
    func fetchImage(at imageURL: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void ) {
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error receiving animal image: \(imageURL), error: \(error)")
                completion(.failure(.errorReceiving))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            completion(.success(image))
        }
        
        task.resume()
    }
    
}
