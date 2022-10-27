//
//  ImageDetailViewController.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/28.
//

import UIKit
import RxSwift
import RxCocoa

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageDetailView: UIImageView!
    
    let viewModel = ImageDetailViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindData()
        
    }
    
    func bindData() {
        
//        viewModel.imageUrl
//            .map { URL(string: $0)! }
//            .map { try! Data(contentsOf: $0) }
//            .map { UIImage(data: $0) }
//            .bind(to: imageDetailView.rx.image)
//            .disposed(by: disposeBag)
        
        viewModel.imageUrl
            .withUnretained(self)
            .subscribe { (vc, url) in
                DispatchQueue.global().async {
                    let url = URL(string: url)!
                    let data = try? Data(contentsOf: url)

                    DispatchQueue.main.async {
                        guard let data = data else { return }
                        print(data)
                        vc.imageDetailView.image = UIImage(data: data)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
