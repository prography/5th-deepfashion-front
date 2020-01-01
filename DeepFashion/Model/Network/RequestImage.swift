//
//  RequestImage.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2020/01/01.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

final class RequestImage {
    static let shared = RequestImage()

    // MARK: - Property

    weak var delegate: RequestImageDelegate?
    private var requestingImageKey = Set<String>()

    // MARK: - Method

    // MARK: Setting

    func isImageKeyEmpty() -> Bool {
        return requestingImageKey.isEmpty
    }

    private func insertImageKey(_ imageKey: String) {
        requestingImageKey.insert(imageKey)
    }

    private func removeImageKey(_ imageKey: String) {
        requestingImageKey.remove(imageKey)
    }

    func setImageFromCache(_ thumbnailImageURLString: String, placeHolder: UIImage) -> UIImage {
        if let cachedImage = UserCommonData.shared.thumbnailImageCache.object(forKey: NSString(string: thumbnailImageURLString)) {
            // 이미지셋팅 후 작업을 마친다. 이미지캐시가 없다면 URL에 대한 데이터처리를 준비한다.
            return cachedImage
        } else {
            return placeHolder
        }
    }

    // MARK: Request API

    // UIImageView객체 내 추가로 URL에따른 데이터 요청 및 이미지 설정 메서드를 추가한다.
    // 인자값으로 URL값과 Default Image(placeHolder)값을 받는다.
    func setImageFromServerURL(_ thumbnailImageURLString: String, placeHolder: UIImage, completion: @escaping (UIImage) -> Void) {
        delegate?.imageRequestDidBegin()

        if let cachedImage = UserCommonData.shared.thumbnailImageCache.object(forKey: NSString(string: thumbnailImageURLString)) {
            delegate?.imageRequestDidFinished(cachedImage, imageKey: thumbnailImageURLString)
            completion(cachedImage)
            return
        }

        insertImageKey(thumbnailImageURLString)

        if let imageUrl = URL(string: thumbnailImageURLString) {
            URLSession.shared.dataTask(with: imageUrl, completionHandler: { data, _, error in

                if error != nil {
                    self.removeImageKey(thumbnailImageURLString)
                    self.delegate?.imageRequestDidError("thumbnailImage URL Loading Error!: \(error?.localizedDescription ?? "")")
                    completion(placeHolder) // 이미지의 설정은 비동기 과정에서 진행한다.
                    return
                }

                DispatchQueue.main.async {
                    if let thumbnailImageData = data {
                        if let thumbnailImage = UIImage(data: thumbnailImageData) {
                            // 이미지 캐싱 후 해당 이미지에 최종적으로 처리된 이미지를 셋팅한다.
                            UserCommonData.shared.thumbnailImageCache.setObject(thumbnailImage, forKey: NSString(string: thumbnailImageURLString))

                            self.removeImageKey(thumbnailImageURLString)
                            self.delegate?.imageRequestDidFinished(thumbnailImage, imageKey: thumbnailImageURLString)
                            completion(thumbnailImage)
                        }
                    }
                }

            }).resume()
        }
    }
}
