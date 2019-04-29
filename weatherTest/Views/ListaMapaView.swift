//
//  ListaMapaView.swift
//  weatherTest
//
//  Created by entelgy on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit
import MapKit

class ListaMapaView: UIView {
    
    @IBOutlet weak var listaView: ListaView!
    @IBOutlet weak var mapaView: MapaView!
    
    func setup(){
        listaView.isHidden = false
        mapaView.isHidden = true
    }
    
    func actualizeListaViewCells(listaModel: [ListaModel]){
        listaView.valuesForTable(lista: listaModel)
    }
    
    func changeVisibility(isLista: Bool) {
        if isLista {
            self.listaView.isHidden = false
            self.mapaView.isHidden = true
        } else {
            self.listaView.isHidden = true
            self.mapaView.isHidden = false
        }
    }
    
    func createPinPointInMap(listaModel: [ListaModel]) {
        self.mapaView.createPointInMap(listaModel: listaModel)
    }
    
    func changeMapUserPosition (regiao: MKCoordinateRegion) {
        self.mapaView.changeUserPosition(regiao: regiao)
    }
    
    func isListaViewVisible() -> Bool {
        
        if listaView.isHidden == false {
            return true
        } else {
            return false
        }
    }
}
