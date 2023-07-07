//
//  PokemonSearchVC.swift
//  Pokedex
//
//  Created by Harm on 7/7/23.
//

import UIKit

class PokemonSearchVC: UIViewController, UISearchBarDelegate {
    
    var pokeController: PokeController!
    var pokemon: Pokemon?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        nameLabel.isHidden = true
        imageView.isHidden = true
        idLabel.isHidden = true
        typesLabel.isHidden = true
        abilitiesLabel.isHidden = true
        saveButton.isHidden = true
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let pokemon = pokemon else { return }
        pokeController.pokemonList.append(pokemon)
//        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        pokeController.fetchDetails(for: searchText) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.fillPage(with: success)
                    self.pokemon = success
                }
            case .failure(let failure):
                print("failed: \(failure)")
            }
        }
        
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
        
        saveButton.isHidden = false
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
