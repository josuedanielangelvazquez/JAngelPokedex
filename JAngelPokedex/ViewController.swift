//
//  ViewController.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 27/03/23.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var viewstackview: UIView!
    @IBOutlet weak var stackviewsearch: UIStackView!
    
    @IBOutlet weak var textsearhc: UITextField!
    
    @IBOutlet weak var poketableview: UITableView!
        var urlpokemonbycategorie = ""
        var paginacion = 0
        var pagina  = 0
        var objectspokemons = [pokemonModel]()
        var pokeObjects =  [results]()
         var tablecounts = 0
        let pokemonviewmodel = PokemonViewModel()
        var pokemoname = ""
        var busquedanormal = true
        var busquedabycategoria = false
    override func viewDidLoad() {
        super.viewDidLoad()
        poketableview.register(UINib(nibName: "pokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "pokecell")
        stackviewsearch.layer.cornerRadius = 20
        viewstackview.layer.cornerRadius = 20
        textsearhc.layer.borderColor = nil
        poketableview.delegate = self
        poketableview.dataSource = self
        view.addSubview(poketableview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            loadData()
        
    }
    
  
   
    func alertmessage(){
        let alert = UIAlertController(title: nil, message: "no existen pokemones con ese nombre", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func loadbyname(pokename : String, pokeimage : @escaping(String)->Void){
        objectspokemons = [pokemonModel]()
        pokemonviewmodel.getbyname(pokemon: pokename) { pokemonObject in
            DispatchQueue.main.async { [self] in
                if pokemonObject != nil{
                    pokeimage((pokemonObject?.sprites.front_default)!)
                    objectspokemons.append(pokemonObject as! pokemonModel)
                    tablecounts = objectspokemons.count
                    poketableview.reloadData()
                }
                else{
                    alertmessage()
                }
                
            }
        }
    }
    func loaddatabycategorie(){
        var pokeobj = [results]()
        var pokeresultss = [results]()
        var pokeobjectsbytype = [pokemons]()
        pokemonviewmodel.getallbytype(Type: urlpokemonbycategorie) { PokeoBJECTS in
            DispatchQueue.main.async { [self] in
                if PokeoBJECTS != nil{
                    pokeobjectsbytype = PokeoBJECTS?.pokemon as! [pokemons]
                    for pokeobjects in pokeobjectsbytype{
                        pokemonviewmodel.getbyname(pokemon: pokeobjects.pokemon.name) { objectpoke in
                            DispatchQueue.main.async {
                                if objectpoke != nil{
                                    var pokeresult = results(frontDefault: objectpoke?.sprites.front_default, name: objectpoke!.name)
                                    pokeobj.append(pokeresult)
                                }
                                pokeObjects = pokeobj
                                tablecounts = pokeObjects.count
                                poketableview.reloadData()

                                
                            }
                        }
                    }
                }
            }
        }
    }
    func createarrayfetall(pagina : Int){
        var pokeobj = [results]()
        var pokeresultss = [results]()
        pokemonviewmodel.getall(paginacion: pagina) { Objectspokemons in
            DispatchQueue.main.async { [self] in
                pokeresultss = Objectspokemons?.results as [results]
                for pokeobject in pokeresultss{
                    pokemonviewmodel.getbyname(pokemon: pokeobject.name) { objectpoke in
                        DispatchQueue.main.async {
                            var pokeresult = results(frontDefault: objectpoke?.sprites.front_default, name: pokeobject.name)
                            pokeobj.append(pokeresult)
                            
                            pokeObjects = pokeobj
                            tablecounts = pokeObjects.count
                            poketableview.reloadData()

                            
                        }
                      
                    }
                    
                }
                

                
            }
        }
    }
    func loadData(){
        if busquedanormal != true{
            guard let pokemonsearch = textsearhc.text, textsearhc.text != nil, textsearhc.text != "" else{
                textsearhc.backgroundColor = .red
                return
            }
            loadbyname(pokename: pokemonsearch) { String in
                print(String)
            }
        }
        else{
            if urlpokemonbycategorie == ""{
                createarrayfetall(pagina: paginacion)
            }
            else{
                loaddatabycategorie()
            }
            }
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablecounts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokecell", for: indexPath as IndexPath) as! pokemonTableViewCell
        cell.pokestackview.layer.cornerRadius = 20
//        elimina el color de la seleccion del didselect
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        --------
        if busquedanormal !=  true{
            cell.pokemonname.text = objectspokemons[indexPath.row].name
            var imageurl = objectspokemons[indexPath.row].sprites.front_default
            var url = URL(string: imageurl)
            if let data = try? Data(contentsOf: url!){
                DispatchQueue.main.async {
                    cell.sprites.image = UIImage(data: data)
                }
            }
            return cell}
        else{
            cell.pokemonname.text = pokeObjects[indexPath.row].name
            let url = URL(string: pokeObjects[indexPath.row].frontDefault!)
            cell.sprites.image = UIImage(data: try! Data(contentsOf: url!))
                
           return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textsearhc.text = nil
        if busquedanormal != true{
            pokemoname = objectspokemons[indexPath.row].name}
        else{
            objectspokemons = [pokemonModel]()
            pokemoname = pokeObjects[indexPath.row].name
        }
        busquedanormal = true
    performSegue(withIdentifier: "seguesdetail", sender: nil)
    }
    
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            urlpokemonbycategorie = ""
            if pagina == 0 {
                busquedanormal = true
               createarrayfetall(pagina: paginacion)
           }

            if pagina > 0{
                pagina -= 1
                paginacion -= 20
                createarrayfetall(pagina: paginacion)
                
            }
                    }
        else {
            if urlpokemonbycategorie == "" {
                pagina += 1
                
                paginacion += 20
                createarrayfetall(pagina: paginacion)
            }
        }
    }

    @IBAction func searchAcvtion(_ sender: Any) {
        objectspokemons = [pokemonModel]()
        busquedanormal = false
        loadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguesdetail"{
            let detail = segue.destination as! DetailViewController
            detail.pokemonname = pokemoname
            
        }
    }
}

