//
//  BaseViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import CDAlertView

class BaseViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .large)

    func initViewModel(viewModel: BaseViewModel) {
        
        viewModel.showAlertClosure = {[weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showAlert(message: viewModel.alertMessage ?? "", type: .error)
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch viewModel.state {
                case .loading:
                    self.showActivityIndicator()
                case .empty, .error,.populated:
                    self.removeActivityIndicator()
                }
            }
        }
    }
    
    func showAlert(message: String,type: CDAlertViewType) {
        let alert = CDAlertView(title: "", message: message, type: type)
        alert.add(action: CDAlertViewAction(title: "Ok"))
        alert.show()
    }
    
    func showActivityIndicator(){
        activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    func removeActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}
