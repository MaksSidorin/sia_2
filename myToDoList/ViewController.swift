//
//  ViewController.swift
//  myToDoList
//
//  Created by Максим Сидорин on 07.10.2021.
//

import UIKit

class ViewController: UIViewController {
        
    let maxCluster = 10
    let p = 0.95
    let d = 11
    let betta = 2
    let features =  "11111001001 10110001001 10101001111 10000001001 10101010011 11111111111 11100011101 10000000000"
    var prototype = "100011001"
    var res = ""
    
    var art1 = ART1()
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
    
        res = art1.start(maxCluster: maxCluster, p: Float(p), d: d, betta: betta, features: features)
        print(res)
        // Do any additional setup after loading the view.
    }
}


