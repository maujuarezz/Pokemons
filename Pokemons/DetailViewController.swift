//
//  DetailController.swift
//  Pokemons
//
//  Created by Mauro Juárez Zavaleta on 28/11/25.
//

import UIKit

class DetailViewController: UIViewController {
    lazy var namePokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "POKEMON NAME"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        print("Vista detalle")

        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        fetchPokemonDetail()
    }
    
    
    func setupView() {
        view.backgroundColor = .black
    }
    
    func addSubviews() {
        view.addSubview(namePokemonLabel)
    }
    
    func setupConstraints () {
        NSLayoutConstraint.activate([
            //constraints label nombre de pokemon
            namePokemonLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            namePokemonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func fetchPokemonDetail() {
        let urlString = "https://pokeapi.co/api/v2/pokemon/2/"
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
                let detalle: PokemonDetailResponse = try
                    decoder.decode(PokemonDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    self.successPokemonDetail(response: detalle)
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func successPokemonDetail(response: PokemonDetailResponse) {
        namePokemonLabel.text = response.name
    }
    
    func containerViewAction() {
        let detailViewController =  DetailViewController()

         self.navigationController?.pushViewController(detailViewController, animated: true)
         //self.navigationController?.popViewController(animated: true)
    }
}
