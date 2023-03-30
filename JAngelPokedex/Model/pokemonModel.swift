//
//  File.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 27/03/23.
//

import Foundation

struct pokemonModelGetAll: Codable{
    var next : String?
    var results : [results]
}
struct results : Codable{
    var frontDefault : String?
    var name : String
    var url : String?
}

// structs de getbyname
struct pokemonModel: Codable{
    var id: Int
    var name: String
    var sprites : sprites
    var types : [types]
    var stats: [stats]
}

struct sprites : Codable {
    var front_default : String
    var front_shiny : String
}
struct types : Codable {
    var type : type
}
struct type : Codable{
    var name: String
}
struct stats : Codable{
    var base_stat : Int?
    var stat : stat?
}
struct stat : Codable{
    var name : String?
}

//getyallbytype
struct pokemonbytype : Codable{
    var pokemon : [pokemons]
}
struct pokemons : Codable{
    var pokemon : pokemon
}
struct pokemon : Codable {
    var name : String
    var url : String
}

