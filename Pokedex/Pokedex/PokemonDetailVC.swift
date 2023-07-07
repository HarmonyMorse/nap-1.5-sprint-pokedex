//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Harm on 7/7/23.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokeController: PokeController!
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillPage(with: pokemon)

        // Do any additional setup after loading the view.
    }
    
    func fillPage(with pokemon: Pokemon) {
        
        nameLabel.isHidden = false
        nameLabel.text = pokemon.name
        
        imageView.isHidden = false
        pokeController.fetchImage(at: pokemon.sprite, completion: { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.imageView.image = success
                }
            case .failure(let failure):
                print("Failure getting image: \(failure)")
            }
        })
        
        idLabel.isHidden = false
        idLabel.text = "ID: \(pokemon.id)"
        
        var typesText = "Types: "
        for type in pokemon.types {
            typesText.append("\(type), ")
        }
        typesText = String(typesText.dropLast(2))
        typesLabel.isHidden = false
        typesLabel.text = typesText
        
        var abilitiesText = "Abilities: "
        for ability in pokemon.abilities {
            abilitiesText.append("\(ability), ")
        }
        abilitiesText = String(abilitiesText.dropLast(2))
        abilitiesLabel.isHidden = false
        abilitiesLabel.text = abilitiesText
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
