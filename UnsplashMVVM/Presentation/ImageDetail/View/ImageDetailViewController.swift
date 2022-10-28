//
//  ImageDetailViewController.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/28.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var imageDetailView: UIImageView!
    @IBOutlet weak var imageProgressView: UIProgressView!
    
    let viewModel = ImageDetailViewModel()
    let disposeBag = DisposeBag()
    
    let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindData()
    }
    
    func configureUI() {
        navigationItem.rightBarButtonItem = shareBarButton
        imageProgressView.progressViewStyle = .default
        imageProgressView.progress = 0.0
    }
    
    func bindData() {
        viewModel.imageUrl
            .withUnretained(self)
            .subscribe { (vc, url) in
                var percent: Float = 0.0
                vc.imageDetailView.isHidden = true
                vc.shareBarButton.isEnabled = false
                
                vc.imageDetailView.kf.setImage(with: URL(string: url)!) { receivedSize, totalSize in
//                    print("received : \(receivedSize) | totalSize: \(totalSize)")
                    percent = Float(receivedSize) / Float(totalSize)
                    vc.imageProgressView.progress = percent
                } completionHandler: { result in
                    switch result {
                    case .success(_):
                        vc.imageProgressView.isHidden = true
                        vc.imageDetailView.isHidden = false
                        vc.shareBarButton.isEnabled = true
                    case .failure(let error):
                        print(error)
                        vc.imageProgressView.isHidden = true
                        vc.imageDetailView.image = UIImage(systemName: "questionmark.circle")
                        vc.imageDetailView.isHidden = false
                    }
                }
                
//                DispatchQueue.global().async {
//                    let url = URL(string: url)!
//                    let data = try? Data(contentsOf: url) // pop 시 계속 캐스팅되는지?
//
//                    DispatchQueue.main.async {
//                        guard let data = data else { return }
//                        vc.imageDetailView.image = UIImage(data: data)
//                        print("succeed") //dimmed 해제 / Kingfisher -> placeholder image 와 대박/
//                        // Kingfisher progress 설정
//                        // URLSession closure / UISessionDelegate 실시간으로 확인 가능
//                    }
//                }
            }
            .disposed(by: disposeBag)
        
        shareBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.showActivityController()
            }
            .disposed(by: disposeBag)
    }
    
    func showActivityController() {
        guard let image = imageDetailView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                if let act = activity {
                    switch act {
                    case .saveToCameraRoll:
                        print("saveToCameraRoll")
                    default:
                        break
                    }
                }
            }
        }
        
        present(activityController, animated: true)
    }
}
