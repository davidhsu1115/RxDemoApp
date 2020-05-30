//
//  ViewModel.swift
//  RxDemoApp
//
//  Created by hsu David on 2020/5/30.
//  Copyright © 2020 hsu David. All rights reserved.
//

import Foundation
import RxSwift
import Moya


class ViewModel {
    
    private let disposeBag = DisposeBag()
    var total: PublishSubject<Int> = PublishSubject()
    var error: PublishSubject<String> = PublishSubject()
    
    func getTotal(){
        API.shared.request(NewYelpServices.Search(lat: 0, lng: 181)).subscribe(onSuccess: { [weak self](model) in
            if model.total != nil{
                self?.total.onNext(model.total!)
            }
            
        }) { [weak self] (e) in
            if let e = e as? MoyaError, let errorMessage = try? e.response?.mapJSON() {
                let errDict = errorMessage as! Dictionary<String, Any>
                let error = errDict["error"] as! Dictionary<String, Any>
                let msg = error["description"] as! String
                self?.error.onNext(msg)
            }
        }.disposed(by: disposeBag)
    }
    
    
}
