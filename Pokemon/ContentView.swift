//
//  ContentView.swift
//  Pokemon
//
//  Created by Ngoc Nguyen on 8/8/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel(service: Service())
//    var service = Service()
    var body: some View {
        NavigationView {
            VStack {
                if let pokemonResponse = viewModel.pokemonResponse {
                    List(pokemonResponse.results, id: \.id) { pokemon in
                        HStack{
                            if let imageUrl = URL(string: pokemon.getImageUrl()) { // Convert the string to a URL
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(pokemon.name)
                                    Text(pokemon.getRank())
                                        .foregroundColor(.gray)
                                    Text("See more")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pokemon")
        }
        .padding()
        .onAppear{
//            service.getAllPokemon()
            viewModel.fetchAllPokemon()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
