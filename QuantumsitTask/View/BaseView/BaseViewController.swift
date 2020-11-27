//
//  BaseViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import RxSwift

//MARK: - BaseViewController

class BaseViewController: UIViewController {
    
    //MARK: - Variables

   private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var imageView: UIImageView!
    let disposeBag = DisposeBag()
    lazy var viewModel: ViewModel = {
        return ViewModel()
    }()
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorsObserver()
    }
    
    func showActivityIndicator(){
        activityIndicator.color = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    func removeImage() {
        imageView.removeFromSuperview()
        imageView = nil
    }
}

// MARK: - Helper Methods

fileprivate extension BaseViewController {
    
    func setupErrorsObserver() {
        viewModel.errorSubject.observeOn(MainScheduler.instance)
            .bind {[weak self] (message) in
                guard let self = self else {return}
                if message == ErrorMessages.connectionError {
                    self.handleNoInternet()
                }else{
                    self.showAlert(message: message)
                }
            }.disposed(by: disposeBag)
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch self.viewModel.state {
                case .loading:
                    self.view.isUserInteractionEnabled = false
                    self.showActivityIndicator()
                case .empty, .error,.populated:
                    self.view.isUserInteractionEnabled = true
                    self.removeActivityIndicator()
                }
            }
        }
    }
    
    func handleNoInternet() {
        imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 300, height: 300))
        imageView.center = view.center
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "internet", in: Bundle(for: type(of: self)), compatibleWith: nil)
        view.addSubview(imageView)
    }
    
   
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
   
}
