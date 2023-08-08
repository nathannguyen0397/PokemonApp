//
//  Model.swift
//  Pokemon
//
//  Created by Ngoc Nguyen on 8/8/23.
//

import Foundation
struct PokemonResponse : Codable {
    let count : Int
    let next : String?
    let previous : String?
    let results : [Pokemon]
}

struct Pokemon : Codable, Identifiable {
    let id = UUID()
    let name : String
    let url : String
    
    func getImageUrl() -> String{
        let baseURL = "https://img.pokemondb.net/artwork/large/"
        return baseURL + self.name + ".jpg"
    }
    
    func getRank() -> String{
        let components = url.split(separator: "/")
        if let lastComponent = components.last {
            return "#" + String(lastComponent)
        }
        return ""
    }
}
