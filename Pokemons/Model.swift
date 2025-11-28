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
    let previus: String?
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}
