//
//  MoyaProvider+Extensions.swift
//  Odeon
//
//  Created by Sherlock, James on 22/12/2018.
//  Copyright © 2018 Sherlouk. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import enum Result.Result

extension MoyaProvider {
    
    @discardableResult
    func requestResiliently(_ target: Target, completion: @escaping Completion) -> Cancellable {
        
        // Make Request
        // If it fails then we should check network connectivity
        // If it's connected then try again after 3 seconds
        // If it's not connected then wait until we gain connectivity before retrying
        // If it fails again after retrying, then wait 10 seconds
        // then 20 seconds, then fail.
        
        // 30 seconds (ish) full timeout
        
        fatalError("Unimplemented")
        
    }
    
    @discardableResult
    func requestDecode<T: Decodable>(_ target: Target, completion: @escaping (_ result: Result<T, MoyaError>) -> Void) -> Cancellable {
        
        let decoder = JSONDecoder()
        
        return request(target) { result in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let value):
                do {
                    _ = try value.filterSuccessfulStatusCodes()
                    
                    let response = try value.map(T.self, using: decoder, failsOnEmptyData: true)
                    completion(.success(response))
                } catch let error as MoyaError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.underlying(error, value)))
                }
            }
            
        }
        
    }
    
    @discardableResult
    func requestDecodePromise<T>(_ target: Target, type: T.Type? = nil) -> Promise<T> where T: Decodable {
        
        return Promise<T> { resolver in
            
            requestDecode(target) { (result: Result<T, MoyaError>) in
                
                switch result {
                case .failure(let error):
                    resolver.reject(error)
                    
                case .success(let value):
                    resolver.fulfill(value)
                }
                
            }
            
        }
        
    }
    
    
}
