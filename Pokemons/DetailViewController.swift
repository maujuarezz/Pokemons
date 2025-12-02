//
//  DetailController.swift
//  Pokemons
//
//  Created by Mauro Juárez Zavaleta on 28/11/25.
//
import AVFoundation
import UIKit

class DetailViewController: UIViewController {
    var url: String?
    //var player: AVPlayer?


    lazy var pokemonImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    lazy var pokemonImageAnimated: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
                
    lazy var namePokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "POKEMON NAME"
        label.font = UIFont.boldSystemFont(ofSize: 20)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var typePokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Tipo: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var alturaPokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Altura: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pesoPokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Peso: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var habilidadesPokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Habilidades: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
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
        view.addSubview(typePokemonLabel)
        view.addSubview(alturaPokemonLabel)
        view.addSubview(pesoPokemonLabel)
        view.addSubview(habilidadesPokemonLabel)
        view.addSubview(pokemonImage)
        view.addSubview(pokemonImageAnimated)
    }
    
    func setupConstraints () {
        NSLayoutConstraint.activate([
            //constraints label nombre de pokemon
            namePokemonLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            namePokemonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //constraints label tipo de pokemon
            typePokemonLabel.topAnchor.constraint(equalTo: namePokemonLabel.bottomAnchor, constant: 15),
            typePokemonLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            //constraints label habilidades de pokemon
            habilidadesPokemonLabel.topAnchor.constraint(equalTo: typePokemonLabel.topAnchor, constant: 15),
            habilidadesPokemonLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            //constraints label altura de pokemon
            alturaPokemonLabel.topAnchor.constraint(equalTo: habilidadesPokemonLabel.topAnchor, constant: 15),
            alturaPokemonLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            //constraints label peso de pokemon
            pesoPokemonLabel.topAnchor.constraint(equalTo: alturaPokemonLabel.topAnchor, constant: 15),
            pesoPokemonLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            //constraints imageAnimated Pokemon
            pokemonImageAnimated.topAnchor.constraint(equalTo: pesoPokemonLabel.bottomAnchor, constant: 50),
            pokemonImageAnimated.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            //constraints imagen pokemon
            pokemonImage.topAnchor.constraint(equalTo: pokemonImageAnimated.topAnchor, constant: -80),
            pokemonImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            pokemonImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)

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
        //Se agrega nombre de Pokemon
        namePokemonLabel.text = response.name.uppercased()
        
        
        //se agregan tipos de pokemon
        guard var types = typePokemonLabel.text else {
            return
        }
        
        for typesPokemon in response.types {
            if types == "Tipo: " {
                types = types  + typesPokemon.type.name.capitalized
            } else {
                types = types  + ", " + typesPokemon.type.name.capitalized
            }

        }
        typePokemonLabel.attributedText = setBoldBegin(texto: types, count: 5)
        
        //se agregan habilidades de pokemon
        
        guard var habilidades = habilidadesPokemonLabel.text else {
            return
        }
        
        for habilidadesPokemon in response.abilities {
            if habilidades == "Habilidades: " {
                habilidades = habilidades  + habilidadesPokemon.ability.name.capitalized
            } else {
                habilidades = habilidades  + ", " + habilidadesPokemon.ability.name.capitalized
            }

        }
        habilidadesPokemonLabel.attributedText =  setBoldBegin(texto: habilidades, count: 12)
        
        //Se agrega valor de altura
        guard let altura = alturaPokemonLabel.text else {
            return
        }
        alturaPokemonLabel.attributedText = setBoldBegin(texto: altura + response.height.toString, count: 7)

        //Se agrega valor de peso
        guard let peso = pesoPokemonLabel.text else {
            return
        }
    
        pesoPokemonLabel.attributedText = setBoldBegin(texto: peso + response.weight.toString, count: 5)
        
        //descarga imagen de celda seleccionada
        pokemonImage.loadImage(url: response.sprites.other.home.front_default)
        pokemonImageAnimated.image = UIImage.gifImageWithData(url: response.sprites.versions.generationv.blackwhite.animated.front_default)
        //pokemonImage.image = UIImage.gifImageWithData(url: response.sprites.versions.generationv.blackwhite.animated.front_default)
        
        

    }
    
    func setBoldBegin(texto: String, count: Int) -> NSMutableAttributedString {
        
        let textoNegrita = NSMutableAttributedString(string: texto)

        textoNegrita.addAttribute(
            NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 18),
            range: NSRange(location: 0, length: count))

        return textoNegrita
    }
    
    /*func playOggFromURL(urlString: String) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Create an AVPlayerItem with the URL
        let playerItem = AVPlayerItem(url: url)

        // Initialize AVPlayer with the player item
        player = AVPlayer(playerItem: playerItem)

        // Play the audio
        player?.play()
    }*/
}

extension Int {
    var toString: String {
        return String(self)
    }
}

extension UIImageView {
    func loadImage(url: String) {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            do {
                guard let urlHttp = URL(string: url) else {
                    return
                }
                let data = try Data(contentsOf: urlHttp)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } catch {
                print("Error al cargar la imagen desde URL: \(error)")
            }
        }
    }
}
/*
extension UIImage {

    static func animatedGif(url: String, framesPerSecond: Double = 10) -> UIImage? {
        DispatchQueue.global().sync {
            do {
                guard let urlHttp = URL(string: url) else {
                    return nil
                }
                let data = try Data(contentsOf: urlHttp) // Download data on a background thread
                
                
                guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
                let imageCount = CGImageSourceGetCount(source)
                var images: [UIImage] = []
                for i in 0 ..< imageCount {
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        images.append(UIImage(cgImage: cgImage))
                    }
                }
                return UIImage.animatedImage(with: images, duration: Double(images.count)/framesPerSecond)
            }catch {
                print("Error loading image from URL: \(error)")
                // Handle error, e.g., set a placeholder image
            }
            return nil
        }
    }
}*/

extension UIImage {
    static func gifImageWithData(url: String) -> UIImage? {
        do {
            guard let urlHttp = URL(string: url) else {
                return nil
            }
            let data = try Data(contentsOf: urlHttp)
            
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
            return UIImage.animatedImageWithSource(source)
        } catch {
           
        }
        return nil
       
    }

    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var delays = [Int]()

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }

            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? Double {
                delays.append(Int(delayTime * 1000.0))
            }
        }

        let totalDelay = delays.reduce(0, +)
        let duration = Double(totalDelay) / 1000.0

        return UIImage.animatedImage(with: images, duration: duration)
    }
}
