//
//  ViewController.swift
//  HttpRequest
//
//  Created by Mauro Juárez Zavaleta on 27/11/25.
//

import UIKit

class ViewController: UIViewController, ViewGeneral, UIScrollViewDelegate {
        
    /*var dataSource: [Model] = [
        Model(id: 1, title: "Title 1", subtitle: "Subtitle 1"),
        Model(id: 2, title: "El principito", subtitle: "Subtitle 2"),
        Model(id: 3, title: "Title 3", subtitle: "Subtitle 3")
    ]*/
    var dataSource: [Pokemon] = []
    var previousUrl: String = ""
    var nextUrl: String = ""
    
    @IBOutlet weak var containerView: UIScrollView!

    
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
        addSubviews()
        setupConstraints()
        fetchPokemons(urlPokemons: "https://pokeapi.co/api/v2/pokemon")
        
    }
    func setupView() {
        view.backgroundColor = .cyan
    }
    func addSubviews() {
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
    func fetchPokemons(urlPokemons: String) {
        let urlString = urlPokemons
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
                    self.dataSource = pokemons.results
                    self.tableView.reloadData()
                    
                    
                    self.nextUrl = pokemons.next
                    guard let previa = pokemons.previous else {
                        return
                    }
                    self.previousUrl = previa
                    
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }

    // función para detectar el final de scroll en pantalla
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Scrolling ended after deceleration.")
        // Example: Load more data if scrolled near the end
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            print("Reached the bottom of the scroll view.")
            // Trigger load more data
            fetchPokemons(urlPokemons: self.nextUrl)
        } else {
            print("Inicio")
            fetchPokemons(urlPokemons: self.previousUrl)
        }
    }

   /** func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            print("Scrolling ended immediately after dragging.")
            // Perform actions if scrolling stopped without deceleration
        }
    }*/
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, CustomCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()

        }
        cell.delegate = self
        let data = dataSource[indexPath.row]
        cell.setupCell(title: data.name, subtitle: data.url)
        cell.tag = indexPath.row
        return cell
    }
    
    func labelTapped(in cell: CustomTableViewCell) {

        let  detailViewController =  DetailViewController()
        detailViewController.url = dataSource[cell.tag].url
        self.navigationController?.pushViewController(detailViewController, animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
}

