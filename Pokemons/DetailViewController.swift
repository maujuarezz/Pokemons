//
//  DetailController.swift
//  Pokemons
//
//  Created by Mauro Juárez Zavaleta on 28/11/25.
//

import UIKit

class DetailViewController: UIViewController {
    var url: String?

    lazy var pokemonImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
                
    lazy var namePokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "POKEMON NAME"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var alturaPokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Altura:   "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pesoPokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Peso:     "
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
        view.addSubview(alturaPokemonLabel)
        view.addSubview(pesoPokemonLabel)
        view.addSubview(pokemonImage)
    }
    
    func setupConstraints () {
        NSLayoutConstraint.activate([
            //constraints label nombre de pokemon
            namePokemonLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            namePokemonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //constraints label altura de pokemon
            alturaPokemonLabel.topAnchor.constraint(equalTo: namePokemonLabel.topAnchor, constant: 50),
            alturaPokemonLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            //constraints label peso de pokemon
            pesoPokemonLabel.topAnchor.constraint(equalTo: alturaPokemonLabel.topAnchor, constant: 15),
            pesoPokemonLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            //constraints imagen pokemon
            pokemonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func fetchPokemonDetail() {
        guard let urlString = url else { return }
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
        guard let altura = alturaPokemonLabel.text else {
            return
        }
        alturaPokemonLabel.text = altura + response.height.toString
        guard let peso = pesoPokemonLabel.text else {
            return
        }
        pesoPokemonLabel.text = peso + response.weight.toString
        
        pokemonImage.loadImage(from: URL(string: response.sprites.other.home.front_default)!)
        print(response.sprites.other.home.front_default)
    }
}

extension Int {
    var toString: String {
        return String(self)
    }
}
extension UIImageView {
    func loadImage(from url: URL) {
        // Ensure the UI update happens on the main thread
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return } // Safely unwrap self

            do {
                let data = try Data(contentsOf: url) // Download data on a background thread
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image // Update the image on the main thread
                    }
                }
            } catch {
                print("Error loading image from URL: \(error)")
                // Handle error, e.g., set a placeholder image
            }
        }
    }
}
