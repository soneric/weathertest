//
//  ClimaAnnotation.swift
//  weatherTest
//
//  Created by Eric Soares Filho on 28/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit
import MapKit

class ClimaAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var listaModel: ListaModel?
    var title: String?
    
    init(listaModel: ListaModel) {
        let myLocation = CLLocationCoordinate2D(latitude: listaModel.lat!, longitude: listaModel.lon!)

        self.coordinate = myLocation
        self.listaModel = listaModel
        self.title =  listaModel.temperatura! + "º" 
    }
}
