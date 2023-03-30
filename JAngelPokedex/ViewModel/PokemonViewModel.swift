//
//  PokemonViewModel.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 27/03/23.
//

import Foundation
class PokemonViewModel{
    
    func getallbytype(Type : String, pokeobjects : @escaping(pokemonbytype?)->Void ){
            let urlsession = URLSession.shared
        let url = URL(string: Type)
        urlsession.dataTask(with: url!){ [self] data, response, error in
            if let safedata = data{
                let json = parsejsonbytype(data: safedata)
                pokeobjects(json)
            }
        }.resume()
        
    }
    func parsejsonbytype(data : Data)->pokemonbytype?{
        let decodable = JSONDecoder()
        do{
            let request = try decodable.decode(pokemonbytype.self, from: data)
            let pokemons = pokemonbytype(pokemon: request.pokemon)
            print(pokemons.pokemon)
            return pokemons
        }
        catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func gettypes(objectsTypes : @escaping(pokemonModelGetAll?)->Void){
        let urlsession = URLSession.shared
        let url = URL(string: "https://pokeapi.co/api/v2/type/")
        urlsession.dataTask(with: url!){ [self] data, response, error in
            if let safedata = data{
                let json = parsejsongetall(data: safedata)
                objectsTypes(json)
            }
        }.resume()
    }
    func getall(paginacion : Int, pokemonObjects : @escaping(pokemonModelGetAll?)->Void){
        let urlsession = URLSession.shared
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(paginacion)&limit=20")
        
        urlsession.dataTask(with: url!){ [self]
            data, response, error in
            if let safedata = data{
                let json = parsejsongetall(data: safedata)
                pokemonObjects(json)
            }
        }.resume()
    }
    
    func parsejsongetall(data: Data)-> pokemonModelGetAll?{
        let decodable = JSONDecoder()
        do{
            let request = try decodable.decode(pokemonModelGetAll.self, from: data)
            let pokeobjects = pokemonModelGetAll(next: request.next, results: request.results)
            return pokeobjects
        }
        catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getbyname(pokemon : String, pokemonObject : @escaping(pokemonModel?)->Void){
        let urlsession = URLSession.shared
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemon)")
      
        urlsession.dataTask(with: url!){ [self]
            data, response, error in
            if let safedata = data{
                let json = parsejson(data: safedata)
                
                    pokemonObject(json)
                
            }
        }.resume()
    }
    
    func parsejson(data : Data)->pokemonModel?{
        let decodable = JSONDecoder()
        do{
            let request = try decodable.decode(pokemonModel.self, from: data)
            let pokemonm = pokemonModel(id: request.id, name: request.name, sprites: request.sprites, types: request.types, stats: request.stats)
            print(pokemonm)
            return pokemonm
        }
        catch let error{
            print(error.localizedDescription)

            return nil
        }
    }
    
}
