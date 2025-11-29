//
//  Model.swift
//  HttpRequest
//
//  Created by Mauro Juárez Zavaleta on 27/11/25.
//
struct Model {
    var id: Int
    let title: String
    let subtitle: String
}

struct PokemonResponse: Decodable {
    let count: Int
    let next: String
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Decodable {
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}

struct Sprites: Decodable {
    let front_default: String
    let other: Other
}

struct Other: Decodable {
    let home: Home
}
struct Home: Decodable {
    let front_default: String
}
