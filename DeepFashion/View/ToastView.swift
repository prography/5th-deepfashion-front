//
//  AlertInfoView.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 2019/12/26.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

final class ToastView: UILabel {
    var overlayView = UIView()
    var backView = UIView()
    var textLabel = UILabel()

    static let shared = ToastView()

    func configureToastView(_ view: UIView, message: String) {
        let whiteColor: UIColor = .white
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backView.center = view.center
        backView.backgroundColor = whiteColor
        backView.alpha = 0
        view.addSubview(backView)

        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60, height: 50)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 100)
        overlayView.backgroundColor = ColorList.brownishGray
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.alpha = 0

        textLabel.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        textLabel.center = overlayView.center
        textLabel.text = message
        textLabel.textAlignment = .center
        textLabel.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(textLabel)
        view.addSubview(overlayView)
    }

    func presentShortMessage(_ view: UIView, message: String) {
        configureToastView(view, message: message)

        // Perform Toast Animation
        UIView.animate(withDuration: 0.7, animations: {
            self.overlayView.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.6, delay: 0.5, animations: {
                self.overlayView.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    DispatchQueue.main.async {
                        self.overlayView.alpha = 0
                        self.textLabel.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.backView.removeFromSuperview()
                    }
                })
            }
        }
    }
}
