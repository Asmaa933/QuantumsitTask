//
//  BaseApi.swift
//  QuantumsitTask
//
//  Created by Asmaa Tarek on 11/26/20.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType>{

    func fetchData<M: Decodable>(target: T, responseClass: M.Type,completion: @escaping (_ result:Result<M?,NSError>) -> Void) {
        let url = target.baseURL + target.path
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParameters(task: target.task)
        AF.request(url, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseJSON { (response) in
            switch response.result{

            case .success(_):
                guard let jsonResponse = response.data else {
                    let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.generalError])
                    completion(.failure(error))
                    return
                }
                
                guard let responseObj = try? JSONDecoder().decode(M.self, from: jsonResponse) else {
                    let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.generalError])
                    completion(.failure(error))
                    return
                }
                
                completion(.success(responseObj))
                
            case .failure(let error):
                print(error.localizedDescription.description)
                let error = NSError(domain: url, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessages.generalError])
                completion(.failure(error as NSError))
            }
        }
    }
    
    private func parseJSON() {
        
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
