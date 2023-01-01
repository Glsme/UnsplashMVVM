//
//  CommonViewModel.swift
//  UnsplashMVVM
//
//  Created by Seokjune Hong on 2022/11/01.
//

import Foundation

import RxSwift

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposebag: DisposeBag) -> Output
}
