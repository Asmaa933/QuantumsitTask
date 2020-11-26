//
//  BaseViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import RxSwift
import CDAlertView

class BaseViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let disposeBag = DisposeBag()
    lazy var viewModel: ViewModel = {
        return ViewModel()
    }()
    

    func initViewModel() {

        viewModel.errorSubject.observeOn(MainScheduler.instance)
            .bind {[weak self] (message) in
                self?.showAlert(message: message , type: .error)
            }.disposed(by: disposeBag)

        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch self.viewModel.state {
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
        activityIndicator.color = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
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
