//
//  ListaMapaViewController.swift
//  weatherTest
//
//  Created by entelgy on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit
import MapKit

class ListaMapaViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var listaMapBarItem: UIBarButtonItem!
    @IBOutlet weak var tempBarItem: UIBarButtonItem!
    var gerenciadorLocalizacao = CLLocationManager()
    var firstRequest = true
    var actualLocation: CLLocation?
    var actualValuesForWeather: WeatherModel?
    var actualListOfModel: [ListaModel]?
    var countToReload = 0
    var tempCelsius = true
    var isInList = true
    
    fileprivate var mainView: ListaMapaView {
        guard let view = self.view as? ListaMapaView else {
            fatalError("ListaMapaView cast failed!")
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setup()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestAlwaysAuthorization()
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            gerenciadorLocalizacao.startUpdatingLocation()
        }
        if tempCelsius == true {
            self.tempBarItem.title = "℃"
        } else {
            self.tempBarItem.title = "℉"
        }
        
        if isInList == true {
            self.listaMapBarItem.title = "Mapa"
        } else {
            self.listaMapBarItem.title = "Lista"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .authorizedWhenInUse && status != .authorizedAlways) && status != .notDetermined {
            let alertController = UIAlertController(title: "Permissão de Localização", message: "Para conseguir utilizar o APP precisamos da autorização.", preferredStyle: .alert)
            let acaoConfig = UIAlertAction(title: "Abrir Configurações", style: .default) { (alertaConfiguracoes) in
                if let config = NSURL(string:  UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(config as URL)
                }
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfig)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tempBarButtonClicked(_ sender: Any) {
        if tempCelsius == true {
            self.tempCelsius = false
            self.tempBarItem.title = "℉"
            self.changeTempAPI()
        } else {
            self.tempCelsius = true
            self.tempBarItem.title = "℃"
            self.changeTempAPI()
        }
    }
    
    @IBAction func listaMapaButtonClicked(_ sender: Any) {
        if isInList == true {
            self.isInList = false
            self.listaMapBarItem.title = "Lista"
            self.mainView.changeVisibility(isLista: false)
            self.countToReload = 5
        } else {
            self.isInList = true
            self.listaMapBarItem.title = "Mapa"
            self.mainView.changeVisibility(isLista: true)
            
        }
    }
    
    
    func reloadListCell(listaModel: [ListaModel]) {
        mainView.actualizeListaViewCells(listaModel: listaModel)
    }
    
    func convertWeatherModelToListaModel(weather: WeatherModel, location: CLLocation) -> [ListaModel] {
        var result = [ListaModel]()
        
        for list in weather.list! {
            var model = ListaModel()
            
            let latitude: CLLocationDegrees = Double((list.coord?.lat)!)
            let longitude: CLLocationDegrees = Double((list.coord?.lon)!)
            let dist = location.distance(from: CLLocation(latitude: latitude, longitude: longitude)) / 1000
            if dist < 50 {
                model.id = list.id
                model.estado = list.name
                model.ceu = list.weather![0].description
                model.iconeURL = list.weather![0].icon
                model.max = list.main?.temp_max?.description
                model.min = list.main?.temp_min?.description
                model.temperatura = list.main?.temp?.description
                model.dist = Int(dist).description
                model.lat = list.coord?.lat
                model.lon = list.coord?.lon
                
                result.append(model)
            }
        }
        
        return result
    }
    
    func changeTempAPI() {
        DispatchQueue.main.async {
            self.countToReload = 60//5
            openWeatherRepositories().getFromDistLatAndLong(lat: Double(self.actualLocation!.coordinate.latitude), lon:Double(self.actualLocation!.coordinate.longitude), isCelsius: self.tempCelsius){ (result: openWeatherRepositories.Result ) in
                switch result {
                case .success(let object):
                    self.actualValuesForWeather = object
                    let listaModelList = self.convertWeatherModelToListaModel(weather: object, location: self.actualLocation!)
                    self.actualListOfModel = listaModelList
                    if self.mainView.isListaViewVisible() {
                        self.reloadListCell(listaModel: listaModelList)
                    } else {
                        self.mainView.createPinPointInMap(listaModel: listaModelList)
                    }
                case .failureError(let error):
                    print(error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.actualLocation = userLocation
        if !self.mainView.isListaViewVisible(){
            if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
                let regiao = MKCoordinateRegion(center: coordenadas, latitudinalMeters: 50000, longitudinalMeters: 50000)
                self.mainView.changeMapUserPosition(regiao: regiao)
            }
        }
        
        DispatchQueue.main.async {
            if self.countToReload == 0 {
                self.changeTempAPI()
            } else {
                self.countToReload = self.countToReload - 1
                print(self.countToReload)
            }
        }
    }
}
