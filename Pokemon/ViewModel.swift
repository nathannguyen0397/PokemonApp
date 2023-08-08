//
//  ViewModel.swift
//  Pokemon
//
//  Created by Ngoc Nguyen on 8/8/23.
//

import Foundation
import Combine

class ViewModel : ObservableObject {
    @Published var pokemonResponse : PokemonResponse? = nil
    let service : ServiceProtocol

    init(service : ServiceProtocol){
        self.service = service
    }
    
    var cancellables = Set<AnyCancellable>()


    func fetchAllPokemon(){
        service.getAllPokemon()
            .sink{completion in
                switch completion{
                case .finished:
                    break
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { [weak self]response in
                self?.pokemonResponse = response
//                print(response)
            }
            .store(in: &cancellables)
    }
}
