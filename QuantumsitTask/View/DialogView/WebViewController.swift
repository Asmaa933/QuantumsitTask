//
//  WebViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import WebKit


class DialogViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var mainView: UIView!

    private lazy var viewModel: DialogViewController = {
        return DialogViewController()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initViewModel()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismissView()
    }
}

fileprivate extension DialogViewController {
    
    func setupView() {
        bgView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismissView)))
        webView.navigationDelegate = self
    }
    
    func initViewModel() {
        viewModel.updateUIClosure = { [weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loadWebView(content: self.viewModel.getContent())
            }
        }
        
        viewModel.showAlertClosure = {[weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showAlert(message: self.viewModel.alertMessage ?? "", type: .error)
            }
        }
        
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
        viewModel.getAboutUs()
    }

    
    func loadWebView(content: String) {
        webView.loadHTMLString(content, baseURL: nil)
    }
}

extension DialogViewController: WKNavigationDelegate {}
