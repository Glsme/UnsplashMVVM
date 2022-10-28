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
    
    let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindData()
    }
    
    func configureUI() {
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    func bindData() {
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
    
    func showActivityController() {
        let image = imageDetailView.image
        let imageURL = try! viewModel.imageUrl.value()
        let activityController = UIActivityViewController(activityItems: [image, imageURL], applicationActivities: nil)
    }
}
