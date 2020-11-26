//
//  MapViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import RxSwift
import GoogleMaps

class MapViewController: BaseViewController {
    
    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupView()
        
    }
    
    override func initViewModel() {
        super.initViewModel()
        viewModel.loginSupervisor()
    }
}

fileprivate extension MapViewController {
    
    func setupView() {
        setupDrivers()
        aboutImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPopUp)))
    }
    
    func setupDrivers() {
        viewModel.pathSubject.observeOn(MainScheduler.instance)
            .bind { [weak self] (coordinates) in
                self?.drawLineTo(coordinates: coordinates)
            }.disposed(by: disposeBag)
        
        viewModel.pinsSubject.observeOn(MainScheduler.instance)
            .bind { [weak self] (pinsLocation) in
                self?.createPin(coordinates: pinsLocation, color: .cyan)
            }.disposed(by: disposeBag)
    }
    
    @objc func showPopUp(){
        guard let popUp = storyboard?.instantiateViewController(identifier: "DialogViewController") as? DialogViewController else {
            print("Error in instantiate")
            return
        }
        self.present(popUp, animated: true)
    }
    
    func createPin(coordinates: [CLLocationCoordinate2D],color: UIColor) {
        for coordinate in coordinates{
            let pin = GMSMarker(position: coordinate)
            pin.icon = GMSMarker.markerImage(with: color)
            getPlaceName(position: coordinate, completion: { (placeName) in
                pin.title = placeName
            })
            pin.appearAnimation = .pop
            pin.map = mapView
        }
        
    }
    
    func drawLineTo(coordinates: [CLLocationCoordinate2D]) {
        let camera : GMSCameraPosition = GMSCameraPosition(latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, zoom: 15.0)
        mapView.camera = camera
        let path = GMSMutablePath()
        createPin(coordinates: [coordinates[0],coordinates[coordinates.count - 1]], color: .red)
        for coordinate in coordinates{
            path.add(coordinate)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5
        polyline.geodesic = true
        polyline.strokeColor = .red
        polyline.map = mapView
    }
    
    func getPlaceName(position:CLLocationCoordinate2D, completion: @escaping (String) -> Void ){
        let geocoder = GMSGeocoder()
        var str:String?
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let lines = places.first?.lines {
                        str = lines.first
                        let token = str?.components(separatedBy: ",")
                        completion((token?[0] ?? ""))
                    }
                }
            }
        }
    }
}
