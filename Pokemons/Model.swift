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
    let types: [TypesPokemon]
    let abilities: [abilities]
    let cries: Cries
}
struct Cries: Decodable {
    let legacy: String
}
struct Sprites: Decodable {
    let front_default: String
    let other: Other
    let versions: Versions
}

struct Versions: Decodable {
    let generationv: Generationv
    private enum CodingKeys: String, CodingKey {
        case generationv = "generation-v"
    }
}

struct Generationv : Decodable {
    let blackwhite: Blackwhite
    private enum CodingKeys: String, CodingKey {
        case blackwhite = "black-white"
    }
}

struct Blackwhite: Decodable {
    let animated: Animated
}

struct Animated: Decodable {
    let front_default: String
}



struct Other: Decodable {
    let home: Home
}
struct Home: Decodable {
    let front_default: String
}

struct TypesPokemon: Decodable {
    let slot: Int
    let type: TypePokemon
}

struct TypePokemon: Decodable {
    let name: String
}

struct abilities: Decodable {
    let ability: Ability
}

struct Ability: Decodable {
    let name: String
}
