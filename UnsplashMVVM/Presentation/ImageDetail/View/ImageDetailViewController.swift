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
    
    let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
    
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
                        vc.imageDetailView.image = UIImage(data: data)
                    }
                }
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
        let imageURL = try! viewModel.imageUrl.value()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
//        activityController.excludedActivityTypes = [
//            UIActivity.ActivityType.assignToContact,
//            UIActivity.ActivityType.addToReadingList
//        ]
        
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
            }  else  {
            // 실패했을 때 작업
           }
        }
        
        present(activityController, animated: true)
    }
}
