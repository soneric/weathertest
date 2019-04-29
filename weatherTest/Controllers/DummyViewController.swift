//
//  DummyViewController.swift
//  weatherTest
//
//  Created by entelgy on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit
import MapKit

class DummyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapaDummy: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapaDummy.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestAlwaysAuthorization()
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        //gerenciadorLocalizacao.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            gerenciadorLocalizacao.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
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
