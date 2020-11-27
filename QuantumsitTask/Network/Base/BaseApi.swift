//
//  BaseApi.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import Alamofire
import RxSwift

// MARK:- BaseAPI

class BaseAPI<T: TargetType>{
    
    private let disposeBag = DisposeBag()
    
    func fetchData<M: Codable>(target: T, responseClass: M.Type) -> Observable<M> {
        let url = target.baseURL + target.path
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParameters(task: target.task)
        return Observable.create { (observer) -> Disposable in
            let request =  AF.request(url, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseJSON { (response) in
                switch response.result{
                
                case .success(_):
                    
                    guard let jsonResponse = response.data else {
                        let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.generalError])
                        observer.onError(error)
                        return
                        
                    }
                    guard let responseObj = try? JSONDecoder().decode(M.self, from: jsonResponse) else {
                        let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.generalError])
                        observer.onError(error)
                        return
                    }
                    observer.onNext(responseObj)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print(error.localizedDescription.description)
                    let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.generalError])
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func buildParameters(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
    
}
