//
//  ViewController.swift
//  JAngelPokedex
//
//  Created by MacBookMBA6 on 27/03/23.
//

import UIKit
import SDWebImage


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
  
 

    @IBOutlet weak var viewstackview: UIView!
    @IBOutlet weak var stackviewsearch: UIStackView!
    
    @IBOutlet weak var textsearhc: UITextField!
    
    @IBOutlet weak var tipopicker: UIPickerView!
    
    @IBOutlet weak var poketableview: UITableView!
    
    var urlpokemonbycategorie = ""
    var tipobusqueda = "Nombre"
        var componentespicker = ["Nombre", "id", "Categoria"]
        var paginacion = 0
        var pagina  = 0
        var objectspokemons = [pokemonModel]()
        var pokeObjects =  [results]?(nil)
         var tablecounts = 0
        let pokemonviewmodel = PokemonViewModel()
        var pokemoname = ""
        var busquedanormal = true
        var busquedabycategoria = false
    override func viewDidLoad() {
        textsearhc.delegate = self
        tipopicker.dataSource = self
        tipopicker.delegate = self
        super.viewDidLoad()
        poketableview.register(UINib(nibName: "pokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "pokecell")
        stackviewsearch.layer.cornerRadius = 20
        viewstackview.layer.cornerRadius = 20
        textsearhc.layer.borderColor = nil
        poketableview.delegate = self
        poketableview.dataSource = self
        view.addSubview(poketableview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokeObjects =  [results]?(nil)
            loadData()
        
    }
    
//    limitar tipo de acceso al textsearch
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if tipobusqueda == "id"{
            if textField == textsearhc{
                let allowingChars = "0123456789"
                let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
                let validString = string.rangeOfCharacter(from: numberOnly) == nil
                return validString
            }}
        else if tipobusqueda == "Nombre" || tipobusqueda == "Categoria"{
            if textField == textsearhc{
                let allowingChars = "abcdefghijklmnñopqrstuvwxyz"
                let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
                let validString = string.rangeOfCharacter(from: numberOnly) == nil
                return validString
            }
        }
        return true
        }

    
    
//   Comienzan funciones del picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return  componentespicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return componentespicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipobusqueda  = componentespicker[row]
        textsearhc.text = ""
    }
    
    
    
    
//    terminan funciones del picker
  
   
    func alertmessage(){
        let alert = UIAlertController(title: nil, message: "no existen pokemones con ese nombre", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    func alertmessagefalsecategory(){
        let alert = UIAlertController(title: nil, message: "No existe la categoria ingresada", preferredStyle: .alert)
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
                    busquedanormal = true
                    viewWillAppear(true)
                }
                
            }
        }
    }
    func loaddatabycategorie(){
        tipobusqueda = "Categoria"
        busquedanormal = true
        tablecounts = 0
        var pokeobj = [results]()
        var pokeresultss = [results]()
        var pokeobjectsbytype = [pokemons]()
        pokemonviewmodel.getallbytype(namecategorie: textsearhc.text ?? "", Type: urlpokemonbycategorie) { [self] PokeoBJECTS in
            DispatchQueue.main.async { [self] in
                if PokeoBJECTS != nil{
                    pokeobjectsbytype = PokeoBJECTS?.pokemon as! [pokemons]
                    for pokeobjects in pokeobjectsbytype{
                        pokemonviewmodel.getbyname(pokemon: pokeobjects.pokemon.name) { objectpoke in
                            DispatchQueue.main.async { [self] in
                                if objectpoke?.name != nil, objectpoke?.sprites.front_default != nil{
                                    var pokeresult = results(frontDefault: objectpoke?.sprites.front_default, name: objectpoke!.name)
                                    pokeobj.append(pokeresult)
                                    pokeObjects = pokeobj
                                    tablecounts = pokeObjects!.count
                                    poketableview.reloadData()
                                }
                                else {
                                 print("no existe")
                                }
                              
                               
                                

                            }
                         
                          
                          
                        }
                        
                    }
                  

                   
                }
                else{
                    alertmessagefalsecategory()
                     busquedanormal = true
                     viewWillAppear(true)
                }
               

                
            }

        }
           
        
     
       

    }
    func createarrayfetall(pagina : Int){
        pokeObjects =  [results]?(nil)
        var pokeobj = [results]()
        var pokeresultss = [results]?(nil)
        pokemonviewmodel.getall(paginacion: pagina) { Objectspokemons in
            DispatchQueue.main.async { [self] in
                pokeresultss = Objectspokemons?.results as [results]
                print(pokeresultss)
                for pokeobject in pokeresultss!{
                    pokemonviewmodel.getbyname(pokemon: pokeobject.name) { objectpoke in
                        DispatchQueue.main.sync { [self] in
                            var pokeresult = results( id: pokeobject.id, frontDefault: objectpoke?.sprites.front_default, name: pokeobject.name, url: pokeobject.url)
                            pokeobj.append(pokeresult)
                            
                            pokeObjects = pokeobj
                            tablecounts = pokeObjects!.count

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
            if tipobusqueda == "id" || tipobusqueda == "Nombre"{
                loadbyname(pokename: pokemonsearch) { String in
                    }
              
            }
           else  if tipobusqueda == "Categoria"{
                loaddatabycategorie()
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
            cell.sprites.sd_setImage(with: URL(string: objectspokemons[indexPath.row].sprites.front_default))
            
            return cell}
        else{
////
            cell.pokemonname.text = pokeObjects![indexPath.row].name
            cell.prepareForReuse()
            cell.sprites.sd_setImage(with: URL(string: pokeObjects![indexPath.row].frontDefault!))
//
           return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textsearhc.text = nil
        if busquedanormal != true{
            pokemoname = objectspokemons[indexPath.row].name}
        else{
            objectspokemons = [pokemonModel]()
            pokemoname = pokeObjects![indexPath.row].name
        }
        busquedanormal = true
    performSegue(withIdentifier: "seguesdetail", sender: nil)
    }
    
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if tipobusqueda != "Categoria"{
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y > 0 {
                print("arriba")
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
                print("abajo")
                if urlpokemonbycategorie == "" {
                    pagina += 1
                    
                    paginacion += 20
                    createarrayfetall(pagina: paginacion)
                }
            }}
        else{
            if scrollView.contentOffset.y <= 0 {
                pagina = 0
                paginacion  = 0
                tipobusqueda = "Nombre"
                urlpokemonbycategorie = ""
                busquedanormal = true
                viewWillAppear(true)
            }
            else{
                print("nada")
            }
        }}

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

