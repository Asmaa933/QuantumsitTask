//
//  DialogViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

//MARK: - DialogViewController

class DialogViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var mainView: UIView!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initViewModel()
    }
    
    //MARK: - Actions
    
    @IBAction private func closeButtonAction(_ sender: UIButton) {
        self.dismissView()
    }
    
}

//MARK: - Helper Methods

fileprivate extension DialogViewController {
    
    // Initialize ViewModel
    func initViewModel() {
        setupObserver()
        viewModel.getAboutUs()
    }
    
    func setupView() {
        retryWhileDownSwipe()
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        mainView.layer.cornerRadius = 10
        mainView.isHidden = true
        webView.navigationDelegate = self
    }
    
    func setupObserver() {
        viewModel.contentSubject.observeOn(MainScheduler.instance)
            .bind {[weak self] (content) in
                guard let self  = self else {return}
                self.loadWebView(content: content)
                self.mainView.isHidden = false
            }.disposed(by: disposeBag)
    }
    
    func loadWebView(content: String) {
        webView.loadHTMLString(content, baseURL: nil)
    }
    
    func retryWhileDownSwipe(){
        showActivityIndicator()
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.retry))
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    @objc func retry() {
        removeImage()
        viewModel.getAboutUs()
    }
}

extension DialogViewController: WKNavigationDelegate {}
