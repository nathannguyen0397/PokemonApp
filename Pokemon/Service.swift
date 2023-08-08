//
//  Service.swift
//  Pokemon
//
//  Created by Ngoc Nguyen on 8/8/23.
//

import Foundation
import Combine

enum APIError : Error {
    case invalidURL
    case decodingError
}

protocol ServiceProtocol {
    func getAllPokemon() -> Future<PokemonResponse, Error>
}

class Service : ServiceProtocol {
    let urlString = "https://pokeapi.co/api/v2/pokemon/?limit=100&offset=0"
    var cancellables = Set<AnyCancellable>()
    
    func getAllPokemon() -> Future<PokemonResponse, Error> {
        return Future{[weak self] promise in
            guard let self = self, let url = URL(string: urlString)
            else {
                print("Invalid URL")
                promise(.failure(APIError.invalidURL))
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .map{$0.data}
                .decode(type: PokemonResponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: {completion in
                    switch completion{
                    case .finished:
                        break
                    case .failure(let err):
                        promise(.failure(err))
                    }
                }) { pokemonResponse in
//                    print(pokemonResponse)
                    promise(.success(pokemonResponse))
                }
                .store(in: &cancellables)
        }
    }
}
