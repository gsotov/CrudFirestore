//
//  EditarViewController.swift
//  CrudFirestore
//
//  Created by Tecnova on 1/16/19.
//  Copyright © 2019 Gabriel Soto Valenzuela. All rights reserved.
//

import UIKit
import Firebase

class EditarViewController: UIViewController {

    var editarUsuario : Usuarios!
    var ref: DocumentReference!
    var id = ""
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nombre.text = editarUsuario.nombre!
        apellido.text = editarUsuario.apellido!
        
        id = editarUsuario.id!
        ref = Firestore.firestore().collection("usuarios").document(id)
        // Do any additional setup after loading the view.
    }
    
    func limpiar(){
        nombre.text = ""
        apellido.text = ""
    }
    
    @IBAction func editar(_ sender: UIButton)
    {
        let dataNombre = nombre.text
        let dataApellido = apellido.text
        
        if dataNombre == nil || dataApellido == nil
        {
            let campos : [String:Any] = ["nombre": nombre.text!,
                                         "apellido": apellido.text!]
            ref.setData(campos) { (error) in
                if let error = error?.localizedDescription{
                    print("fallo al actualizar", error)
                }else{
                    print("acutalizo")
                    self.limpiar()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else
        {
            
            let alert = UIAlertController(title: "Alerta", message: "Debes completar todos los campos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        
        
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
