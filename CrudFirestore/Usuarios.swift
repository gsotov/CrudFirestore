//
//  Usuarios.swift
//  CrudFirestore
//
//  Created by Tecnova on 1/16/19.
//  Copyright © 2019 Gabriel Soto Valenzuela. All rights reserved.
//

import Foundation

class Usuarios {
    
    var nombre: String?
    var apellido: String?
    
    init(nombre: String, apellido: String)
    {
        self.nombre = nombre
        self.apellido = apellido
    }
}
