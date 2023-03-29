//
//  DetailViewController.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 28/03/23.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
var pokemonname = ""
    var stacts = [stats]()
    var frontShiny = ""
    var frontNormal = ""
    var pokemonviewmodel = PokemonViewModel()
    @IBOutlet weak var spriteFrontalNormal: UIImageView!
    @IBOutlet weak var spriteFrontalShiny: UIImageView!
    @IBOutlet weak var namePokemon: UILabel!
    @IBOutlet weak var noPokemon: UILabel!
    @IBOutlet weak var Tipelbl: UILabel!
    @IBOutlet weak var tablestacks: UITableView!
    
    //detailcolors
    
    @IBOutlet weak var ViewDetailColor1: UIView!
    @IBOutlet weak var ViewDetailColor2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablestacks.dataSource = self
        tablestacks.delegate = self
        view.addSubview(tablestacks)
        tablestacks.register(UINib(nibName: "DetailTableViewCell", bundle: .main), forCellReuseIdentifier: "statsdetailcel")

            loaddatatableview()
    }

    func loaddatatableview(){
        pokemonviewmodel.getbyname(pokemon: pokemonname) { ObjectPokemon in
            DispatchQueue.main.async { [self] in
                frontShiny = (ObjectPokemon!.sprites.front_shiny)
                frontNormal = (ObjectPokemon!.sprites.front_default)
                let urlShiny = URL(string: frontShiny)
                let urlNormal = URL(string: frontNormal)
                spriteFrontalNormal.image = UIImage(data: try! Data(contentsOf: urlNormal!))
                spriteFrontalShiny.image = UIImage(data: try! Data(contentsOf: urlShiny!))
                if ObjectPokemon != nil{}
                stacts = ObjectPokemon!.stats as [stats]
                namePokemon.text = ObjectPokemon!.name
                Tipelbl.text = ObjectPokemon!.types[0].type.name
                noPokemon.text = String(ObjectPokemon!.id)
                tablestacks.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stacts.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsdetailcel", for: indexPath as! IndexPath) as! DetailTableViewCell
       
        cell.namestatelbl.text = "\(stacts[indexPath.row].stat.name):"
        cell.baseStatelbl.text = String(stacts[indexPath.row].base_stat)
        return cell
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
