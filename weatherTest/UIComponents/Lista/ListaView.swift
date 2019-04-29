//
//  ListaView.swift
//  weatherTest
//
//  Created by entelgy on 25/04/19.
//  Copyright © 2019 ERIMIA. All rights reserved.
//

import UIKit
import CoreLocation

class ListaView: UIView, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var listaTemp = [ListaModel]()
    
    override init( frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder ) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ListaView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        registerNibs()
        
    }
    
    func valuesForTable(lista: [ListaModel]){
        listaTemp = lista
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func registerNibs() {
        let nib = UINib(nibName: "ListaTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ListaTableViewCell")
    }
    
    //Table View delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaTemp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaTableViewCell", for: indexPath) as! ListaTableViewCell
        
        cell.estadoLabel.text = listaTemp[indexPath.row].estado
        cell.ceuLabel.text = listaTemp[indexPath.row].ceu
        cell.tempLabel.text = listaTemp[indexPath.row].temperatura
        cell.maxLabel.text = listaTemp[indexPath.row].max
        cell.minLabel.text = listaTemp[indexPath.row].min
        cell.distLabel.text = listaTemp[indexPath.row].dist! + "KM"
        cell.iconImage.image = listaTemp[indexPath.row].iconImage
        
        /*
        if listaTemp[indexPath.row].iconeURL != nil {
            if let url = URL(string: "https://openweathermap.org/img/w/" + listaTemp[indexPath.row].iconeURL! + ".png"){
                let data = try? Data(contentsOf: url)
                cell.iconImage.image = UIImage(data: data!)
            }else {
                print("imagem nao encontrada")
            }
        }*/
        
        return cell
    }
}
