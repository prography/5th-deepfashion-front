//
//  RequestAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum APIPostMode: String {
    case userDataPost
    case loginDataPost
    case styleImagePost
}

struct APIURL {
    static let base = "http://127.0.0.1:8000/"
    struct SubURL {
        struct Get {}

        struct Post {
            static let userData = "accounts/"
            static let login = "accounts/login/"
            static let styleImage = "accounts/"
            static let clothing = "clothing/"
        }
    }
}

final class RequestAPI {
    static let shared: RequestAPI = RequestAPI()

    // MARK: - Properties

    private let urlSession = URLSession(configuration: .default)
    private var dataTask = URLSessionDataTask()

    weak var delegate: RequestAPIDelegate?

    func postAPIData<T>(userData: T, APIMode: APIPostMode, completion: @escaping (T.Type?, Bool) -> Void) {
        delegate?.requestAPIDidBegin()
        switch APIMode {
        case .loginDataPost:

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.login)"
            guard let userData = userData as? LoginAPIPostData else {
                delegate?.requestAPIDidError()
                completion(nil, false)
                return
            }

            let userDataToPost = LoginAPIPostData(userName: userData.userName, password: userData.password)
            print("userAPIData... : \(userDataToPost)")
            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()
                completion(nil, false)
                return
            }

            print("userAPIData... : \(userAPIData)")
            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                data, response, error in

                if error != nil {
                    print("Error Occurred...! : \(String(error?.localizedDescription ?? ""))")
                    self.delegate?.requestAPIDidError()
                    completion(nil, false)
                    return
                }

                guard let data = data,
                    let userData = try? JSONDecoder().decode(UserTokenAPIData.self, from: data) else {
                    self.delegate?.requestAPIDidError()
                    completion(nil, false)
                    return
                }

                // MARK: - Token Check

                CommonUserData.shared.setUserToken(userData.token)
                print("token is.. \(CommonUserData.shared.userToken)")
                print("userAPIData : \(userData)")

                if let response = response as? HTTPURLResponse {
                    print("post response : \(response)")

                    if (200 ... 299).contains(response.statusCode) {
                        print("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil, true)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        completion(nil, false)
                    }
                }
            }.resume()

        case .userDataPost:

            guard let userData = userData as? UserAPIPostData else {
                delegate?.requestAPIDidError()
                completion(nil, false)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.userData)"
            print("userDataPostURLString : \(userDataPostURLString)")
            let userDataToPost = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.styles, password: userData.password)
            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()
                completion(nil, false)
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                _, response, error in

                if error != nil {
                    print("Error Occurred...! : \(String(error?.localizedDescription ?? ""))")
                    self.delegate?.requestAPIDidError()
                    completion(nil, false)
                }

                if let response = response as? HTTPURLResponse {
                    print("post response : \(response)")

                    if (200 ... 299).contains(response.statusCode) {
                        print("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil, true)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        completion(nil, false)
                    }
                }
            }.resume()

        case .styleImagePost:

            guard let userData = userData as? UserClothingAPIData else {
                delegate?.requestAPIDidError()
                completion(nil, false)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.clothing)"
            print("userDataPostURLString : \(userDataPostURLString)")

            let userDataToPost = UserClothingAPIData(style: userData.style, name: userData.name, color: userData.color, season: userData.season, part: userData.part, image: userData.image)

            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()
                completion(nil, false)
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            // token 등록이 필요
            urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                _, response, error in

                if error != nil {
                    print("Error Occurred...! : \(String(error?.localizedDescription ?? ""))")
                    self.delegate?.requestAPIDidError()
                    completion(nil, false)
                }

                if let response = response as? HTTPURLResponse {
                    print("post response : \(response)")

                    if (200 ... 299).contains(response.statusCode) {
                        print("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil, true)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        completion(nil, false)
                    }
                }
            }.resume()
        }
    }
}
