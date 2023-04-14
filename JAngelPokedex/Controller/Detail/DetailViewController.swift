//
//  DetailViewController.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 28/03/23.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate{
 
    var pokemonname = ""
    var stacts = [stats]()
    var Types = [results]()
    var frontShiny = ""
    var frontNormal = ""
    var url = ""
    var modeltypes = [types]()
    var pokemonviewmodel = PokemonViewModel()
    
    @IBOutlet weak var Viewdate: UIView!
    
    @IBOutlet weak var spriteFrontalNormal: UIImageView!
    @IBOutlet weak var spriteFrontalShiny: UIImageView!
    @IBOutlet weak var namePokemon: UILabel!
    @IBOutlet weak var noPokemon: UILabel!
    @IBOutlet weak var tablestacks: UITableView!
    
    //detailcolors
    @IBOutlet weak var typescollectionview: UICollectionView!
    
    @IBOutlet weak var ViewDetailColor1: UIView!
    @IBOutlet weak var ViewDetailColor2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Viewdate.layer.cornerRadius = 40
        typescollectionview.dataSource = self
        typescollectionview.delegate = self
        view.addSubview(typescollectionview)
        tablestacks.dataSource = self
        tablestacks.delegate = self
        view.addSubview(tablestacks)
        tablestacks.register(UINib(nibName: "DetailTableViewCell", bundle: .main), forCellReuseIdentifier: "statsdetailcel")
        self.typescollectionview.register(UINib(nibName: "DetailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "typecell")
            loaddatatableview()
        loaddataCollectionView()
    }
    func loaddataCollectionView(){
        pokemonviewmodel.gettypes { [self] ObjectsType in
            
            DispatchQueue.main.async {
                if ObjectsType != nil{
                    Types = ObjectsType?.results as [results]
                    
                }
                print("Sin Elementos")
            }
           
        }
    }
    func loaddatatableview(){
        pokemonviewmodel.getbyname(pokemon: pokemonname) { ObjectPokemon in
            DispatchQueue.main.async { [self] in
                frontShiny = (ObjectPokemon!.sprites.front_shiny)
                frontNormal = (ObjectPokemon!.sprites.front_default)
             
                pokemonviewmodel.loadImageAsync(from: frontNormal) { Objectimage in
                    DispatchQueue.main.async { [self] in
                        spriteFrontalNormal.image = Objectimage
                        
                    }
                }
                pokemonviewmodel.loadImageAsync(from: frontShiny) { Objectimage2 in
                    DispatchQueue.main.async {
                        spriteFrontalShiny.image = Objectimage2
                    }
                }
                if ObjectPokemon != nil{
                    stacts = ObjectPokemon!.stats as [stats]
                    
                    modeltypes = ObjectPokemon?.types as [types]
                    print(modeltypes)
                    var color = ObjectPokemon?.types[0].type.name
                    self.ViewDetailColor1.backgroundColor = UIColor(named: color!)
                    self.ViewDetailColor2.backgroundColor = UIColor(named: color!)?.withAlphaComponent(0.2)
                    namePokemon.text = ObjectPokemon!.name
                    noPokemon.text = String(ObjectPokemon!.id)
                    tablestacks.reloadData()
                    typescollectionview.reloadData()

                }
             
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stacts.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsdetailcel", for: indexPath as! IndexPath) as! DetailTableViewCell
       
        cell.namestatelbl.text = "\(stacts[indexPath.row].stat!.name!):"
        cell.baseStatelbl.text = String(stacts[indexPath.row].base_stat!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        modeltypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typecell", for: indexPath as IndexPath) as! DetailCollectionViewCell
        cell.typelbl.text = modeltypes[indexPath.row].type.name
        cell.typeimage.image = UIImage(named: modeltypes[indexPath.row].type.name)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        url = Types[indexPath.row].url!
        dismiss(animated: true)
        performSegue(withIdentifier: "seguespokemons", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguespokemons"{
            let detail = segue.destination as! ViewController
            detail.tipobusqueda = "Categoria"
            detail.urlpokemonbycategorie = url
        }
    }

    

}
