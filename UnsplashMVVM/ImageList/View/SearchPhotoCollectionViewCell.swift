//
//  SearchPhotoCollectionViewCell.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/10/27.
//

import UIKit
import SnapKit

class SearchPhotoCollectionViewCell: UICollectionViewCell {
    
    let searchedImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        [searchedImageView].forEach {
            self.addSubview($0)
        }
    }
    
    func setConstraints() {
        searchedImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(self.snp.height).multipliedBy(0.8)
            make.leading.equalTo(self.snp.leading).offset(20)
        }
    }
    
}
