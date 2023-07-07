//
//  Pokemon.swift
//  Pokedex
//
//  Created by Harm on 7/7/23.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let types: [String]
    let abilities: [String]
    let sprite: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case types
        case abilities
        case sprites
        
        enum TypesDescriptionKeys: String, CodingKey {
            case type
            
            enum TypesKeys: String, CodingKey {
                case name
            }
        }
        
        enum AbilityDescriptionKeys: String, CodingKey {
            case ability
            
            enum AbilityKeys: String, CodingKey {
                case name
            }
        }
        
        enum SpritesKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //name
        name = try container.decode(String.self, forKey: .name)
        
        //id
        id = try container.decode(Int.self, forKey: .id)
        
        //types
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        var typesList: [String] = []
        while !typesContainer.isAtEnd {
            let typeDescriptionContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypesDescriptionKeys.self)
            let typeContainer = try typeDescriptionContainer.nestedContainer(keyedBy: CodingKeys.TypesDescriptionKeys.TypesKeys.self, forKey: .type)
            let type = try typeContainer.decode(String.self, forKey: .name)
            typesList.append(type)
        }
        types = typesList
        
        //abilities
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        var abilityNames: [String] = []
        while !abilitiesContainer.isAtEnd {
            let abilityDescriptionContainer = try abilitiesContainer.nestedContainer(keyedBy: CodingKeys.AbilityDescriptionKeys.self)
            let abilityContainer = try abilityDescriptionContainer.nestedContainer(keyedBy: CodingKeys.AbilityDescriptionKeys.AbilityKeys.self, forKey: .ability)
            let abilityName = try abilityContainer.decode(String.self, forKey: .name)
            abilityNames.append(abilityName)
        }
        abilities = abilityNames
        
        //sprite
        let spritesContainer = try container.nestedContainer(keyedBy: CodingKeys.SpritesKeys.self, forKey: .sprites)
        let spriteString = try spritesContainer.decode(String.self, forKey: .frontDefault)
        guard let spriteURL = URL(string: spriteString) else { fatalError("Sprite URL is not a URL.") }
        sprite = spriteURL
        
    }
    
}
