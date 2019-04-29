//
//  MapaView.swift
//  weatherTest
//
//  Created by entelgy on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaView: UIView, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var contentView: UIView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    override init( frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder ) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MapaView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        mapView.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestAlwaysAuthorization()
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        //gerenciadorLocalizacao.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            gerenciadorLocalizacao.startUpdatingLocation()
        }
    }
    
    func changeUserPosition( regiao: MKCoordinateRegion) {
        self.mapView.setRegion(regiao, animated: true)
    }
    
    func createPointInMap(listaModel: [ListaModel]) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        for list in listaModel {
                let anotacao = ClimaAnnotation(listaModel: list)//MKPointAnnotation()
                self.mapView.addAnnotation(anotacao)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let myAnnotation = annotation as! ClimaAnnotation
        //if annotation is MKUserLocation {
        
            if myAnnotation.listaModel?.iconeURL != nil {
                if let url = URL(string: "https://openweathermap.org/img/w/" + (myAnnotation.listaModel?.iconeURL!)! + ".png"){
                    let data = try? Data(contentsOf: url)
                    anotacaoView.image = UIImage(data: data!)
                }else {
                    print("imagem nao encontrada")
                }
            }
        
            //anotacaoView.image = UIImage(named: "human")
            var frame = anotacaoView.frame
            frame.size.height = 40
            frame.size.width = 40
            
            anotacaoView.frame = frame 
        //}
        
        
        return anotacaoView
        
    }
}
