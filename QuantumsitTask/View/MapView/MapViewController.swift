//
//  MapViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let x = ApiHandler ()
        x.getAboutUs { (_) in
            
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func button(_ sender: UIButton) {
     
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
