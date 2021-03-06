//
//  ViewController.swift
//  CrudFirestore
//
//  Created by Tecnova on 1/16/19.
//  Copyright © 2019 Gabriel Soto Valenzuela. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var tabla: UITableView!
    
    var ref: DocumentReference!
    var getRef: Firestore!
    
    var listaUsuarios = [Usuarios]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        getRef = Firestore.firestore()
        //self.todo()
        self.realTime()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listaUsuarios.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviar", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar"
        {
            if let id = tabla.indexPathForSelectedRow
            {
                let fila = listaUsuarios[id.row]
                let destino = segue.destination as! EditarViewController
                destino.editarUsuario = fila
                
                if let index = self.tabla.indexPathForSelectedRow
                {
                    self.tabla.deselectRow(at: index, animated: true)
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let borrar = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            let user : Usuarios
            user = self.listaUsuarios[indexPath.row]
            let id = user.id
            self.getRef.collection("usuarios").document(id!).delete()
        }
        return[borrar]
    }
    
    func realTime()
    {
        getRef.collection("usuarios").addSnapshotListener { (querySnapshot, error) in
            if let error = error{
                print("Error", error)
            }else{
                self.listaUsuarios.removeAll()
                
                for document in (querySnapshot?.documents)!
                {
                    let id = document.documentID
                    let valores = document.data()
                    let nombre = valores["nombre"] as? String ?? "no hay dato de nombre"
                    let appelido = valores["apellido"] as? String ?? "no hay dato de apellido"
                    
                    let users = Usuarios(nombre: nombre, apellido: appelido, id: id)
                    self.listaUsuarios.append(users)
                    self.tabla.reloadData()
                }
                
            }
        }
    }
    func todo()
    {
        /*
        getRef.collection("usuarios").whereField("nombre", isEqualTo: "Leslie").getDocuments { (querySnapshot, error) in
            if let error = error{
                print("Error", error)
            }else{
                
                for document in (querySnapshot?.documents)!
                {
                    let valores = document.data()
                    let nombre = valores["nombre"] as? String ?? "no hay dato de nombre"
                    let appelido = valores["apellido"] as? String ?? "no hay dato de apellido"
                    
                    let users = Usuarios(nombre: nombre, apellido: appelido)
                    self.listaUsuarios.append(users)
                    self.tabla.reloadData()
                }
                
            }
        }
        */
        /*
        getRef.collection("usuarios").getDocuments { (querySnapshot, error) in
            if let error = error{
                print("Error", error)
            }else{
                
                for document in (querySnapshot?.documents)!
                {
                    let valores = document.data()
                    let nombre = valores["nombre"] as? String ?? "no hay dato de nombre"
                    let appelido = valores["apellido"] as? String ?? "no hay dato de apellido"
                    
                    let users = Usuarios(nombre: nombre, apellido: appelido)
                    self.listaUsuarios.append(users)
                    self.tabla.reloadData()
                }
                
            }
        }
 */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user: Usuarios
        user = listaUsuarios[indexPath.row]
        
        cell.textLabel?.text = user.nombre
        cell.detailTextLabel?.text = user.apellido
        
        return cell
    }
    
    @IBAction func guardar(_ sender: UIButton)
    {
        let campos : [String:Any] = ["nombre": nombre.text!, "apellido": apellido.text!]
        ref = getRef.collection("usuarios").addDocument(data: campos, completion: { (error) in
            if let error = error?.localizedDescription
            {
                print("error de firebase al guardar ", error)
            }
            else
            {
                print("guardo correctamente")
                self.limpiarText()
                self.tabla.reloadData()
            }
        })
    }
    
    func limpiarText(){
        nombre.text = ""
        apellido.text = ""
    }
    
}

