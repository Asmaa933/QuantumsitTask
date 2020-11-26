//
//  DialogViewModel.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation

class DialogViewModel: BaseViewModel {
    
    private var aboutUs: AboutUsModel? {
        didSet {
            self.updateUIClosure?()
        }
    }
    
    
    func getAboutUs(token: String) {
        state = .loading
        apiHandler.getAboutUs(token: token) {[weak self] (result) in
            guard let self = self else {return}
            switch result {
            
            case .success(let resultData):
                if resultData?.status == true {
                    self.aboutUs = resultData?.innerData?[0]
                    self.state = .populated
                }else {
                    self.alertMessage = resultData?.message
                    self.state = .error
                }
                
            case .failure(let error):
                self.alertMessage = error.userInfo[NSLocalizedDescriptionKey] as? String
                self.state = .error

            }
        }
    }
    
    func getContent() -> String {
        return aboutUs?.content ?? ""
    }
}
