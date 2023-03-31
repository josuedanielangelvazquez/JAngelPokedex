//
//  PokemonViewModel.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 27/03/23.
//

import Foundation
import UIKit
class PokemonViewModel{
    
    private var task: URLSessionDataTask?

   
    func loadImageAsync(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            completion(image)
        }

        task.resume()
    }
    func getallbytype(namecategorie : String,Type : String, pokeobjects : @escaping(pokemonbytype?)->Void ){
        let urlsession = URLSession.shared
        let url = URL(string: Type)
        if url != nil{
            urlsession.dataTask(with: url!){ [self] data, response, error in
                if let safedata = data{
                    let json = parsejsonbytype(data: safedata)
                    pokeobjects(json)
                }
            }.resume()
        }
        else{
            let url2 = URL(string: "https://pokeapi.co/api/v2/type/\(namecategorie)/")
            if url2 != nil{
                urlsession.dataTask(with: url2!){
                    data, response, error in
                    if let safedata = data{
                        let json = self.parsejsonbytype(data: safedata)
                        pokeobjects(json)
                    }
                }.resume()
            }
            else{
                pokeobjects(nil)
            }
            
        }
      
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
