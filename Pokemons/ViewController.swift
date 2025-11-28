//
//  ViewController.swift
//  HttpRequest
//
//  Created by Mauro Juárez Zavaleta on 27/11/25.
//

import UIKit

class ViewController: UIViewController, ViewGeneral {
    /*var dataSource: [Model] = [
        Model(id: 1, title: "Title 1", subtitle: "Subtitle 1"),
        Model(id: 2, title: "El principito", subtitle: "Subtitle 2"),
        Model(id: 3, title: "Title 3", subtitle: "Subtitle 3")
    ]*/
    var dataSource: [Pokemon] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        addSubViews()
        setupConstraints()
        fetchPokemons()
    }
    func setupView() {
        view.backgroundColor = .cyan
    }
    func addSubViews() {
        view.addSubview(tableView)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func fetchPokemons() {
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("No data found")
                return
            }
            do {
                let decoder = JSONDecoder()
                let pokemons: PokemonResponse = try
                    decoder.decode(PokemonResponse.self, from: data)
                DispatchQueue.main.async {
                    self.successPokemon(response: pokemons)
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    func successPokemon(response: PokemonResponse) {
        dataSource = response.results
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()

        }
        
        let data = dataSource[indexPath.row]
        cell.setupCell(title: data.name, subtitle: data.url)
        return cell
    }
}

protocol ViewGeneral {
    func setupView()
    func addSubViews()
    func setupConstraints()
}

