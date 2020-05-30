//
//  ViewController.swift
//  RxDemoApp
//
//  Created by hsu David on 2020/5/30.
//  Copyright © 2020 hsu David. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    private let viewModel = ViewModel()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let service = MoyaProvider<YelpServices.BusinessProvider>()
        //        service.request(.search(lat: 42.361145, lng: -71.057083)) { (result) in
        //            switch result {
        //            case.success(let response):
        //                let data = try? JSONSerialization.jsonObject(with: response.data, options: [])
        //                print(data)
        //            case.failure(let error):
        //                print(error)
        //            }
        //        }
        
        //(415) 215-9469
        //        service.request(.phoneSearch(phone: "2159469")) { (result) in
        //            switch result {
        //            case .success(let response):
        //                let data = try? JSONSerialization.jsonObject(with: response.data, options: [])
        //                print(data)
        //            case .failure(let error):
        //                print(error)
        //            }
        //        }
        
        //        let provider = MoyaProvider<NewYelpServices.Search>()
        //        provider.request(.init(lat: 42.361145, lng: -71.057083)) { (result) in
        //            switch result {
        //            case.success(let response):
        //                let data = try? JSONSerialization.jsonObject(with: response.data, options: [])
        //                print(data)
        //            case.failure(let error):
        //                print(error)
        //            }
        //        }
        
        //        let rxProvicer = MoyaProvider<NewYelpServices.Search>()
        //        rxProvicer.rx.request(.init(lat: 42.361145, lng: -71.057083))
        //        .filterSuccessfulStatusCodes()
        //            .mapObject(YelpModel.self)
        //            .subscribe(onSuccess: { (p) in
        //                print(p)
        //
        //            }) { (e) in
        //                print(e)
        //        }.disposed(by: disposeBag)
        
        
        
        //        API.shared.request(NewYelpServices.Search(lat: 42.361145, lng: -71.057083)).subscribe(onSuccess: { (modelResult) in
        //            print(modelResult.total)
        //        }) { (error) in
        //            print(error)
        //        }.disposed(by: disposeBag)
        //
        //
        //        API.shared.request(NewYelpServices.SearchB(lat: 42.361145, lng: -71.057083)).subscribe(onSuccess: { (model) in
        //            print(model.total)
        //        }) { (error) in
        //            print(error)
        //        }
        
        
        viewModel.total.observeOn(MainScheduler.instance)
            .map{"total: \($0)"}
            .bind(to: self.label.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.error.observeOn(MainScheduler.instance)
            .map{"Error \($0)"}
            .bind(to: self.label.rx.text)
            .disposed(by: disposeBag)
        
        self.textField.rx.text.asObservable()
            .map{($0! as NSString).doubleValue}
            .throttle(.milliseconds(3), scheduler: MainScheduler.instance)
            .subscribe { [weak self](event) in
                self?.viewModel.getTotal(lat: event.element!,lng: event.element!)
        }.disposed(by: disposeBag)
        
        
        self.button.rx.tap.subscribe { [weak self] (event) in
            print("tap")
            self?.viewModel.getTotal(lat: 23, lng: 181)
        }.disposed(by: disposeBag)
        
    }
    
    
}



