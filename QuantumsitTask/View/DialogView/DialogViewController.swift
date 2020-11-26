//
//  DialogViewController.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import UIKit
import WebKit
import RxSwift


class DialogViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupView()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismissView()
    }
    
    override func initViewModel() {
        super.initViewModel()
        viewModel.contentSubject.observeOn(MainScheduler.instance)
            .bind {[weak self] (content) in
                guard let self  = self else {return}
                self.mainView.isHidden = false
                self.loadWebView(content: content)
            }.disposed(by: disposeBag)
        viewModel.getAboutUs()
    }
}

fileprivate extension DialogViewController {
    
    func setupView() {
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        mainView.layer.cornerRadius = 10
        mainView.isHidden = true
        webView.navigationDelegate = self
    }
    
    func loadWebView(content: String) {
        webView.loadHTMLString(content, baseURL: nil)
    }
}

extension DialogViewController: WKNavigationDelegate {}
