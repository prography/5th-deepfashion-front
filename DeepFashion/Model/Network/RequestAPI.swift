//
//  RequestAPIData.swift
//  DeepFashion
//
//  Created by MinKyeongTae on 10/11/2019.
//  Copyright © 2019 MinKyeongTae. All rights reserved.
//

import UIKit

enum NetworkError {
    case client
    case server
    case wrongType
    case unknown

    var errorTitle: String {
        switch self {
        case .client:
            return "클라이언트 에러"
        case .server:
            return "서버 에러"
        case .wrongType:
            return "올바르지 않은 입력"
        case .unknown:
            return "예기치 못한 에러"
        }
    }

    var errorMessage: String {
        switch self {
        case .client:
            return "클라이언트 문제가 발생했습니다. "
        case .server:
            return "네트워크 상태가 불안정 합니다."
        case .wrongType:
            return "올바른 입력을 해주시기 바랍니다."
        case .unknown:
            return "예기치 못한 에러가 발생했습니다."
        }
    }
}

enum APIPostMode: String {
    case userDataPost
    case loginDataPost
    case clothingPost
    case clothingUploadPost
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
            static let clothingUpload = "clothing/upload"
        }
    }
}

final class RequestAPI {
    static let shared: RequestAPI = RequestAPI()

    // MARK: - Properties

    private let urlSession = URLSession(configuration: .default)
    private var dataTask = URLSessionDataTask()

    weak var delegate: RequestAPIDelegate?

    private func createBody(parameters: [String: String],
                            boundary: String,
                            data: Data,
                            mimeType: String,
                            filename: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        return body as Data
    }

    func postAPIData<T>(userData: T, APIMode: APIPostMode, completion: @escaping (NetworkError?) -> Void) {
        var nowStatusCode = 0
        var errorType: NetworkError = .unknown

        delegate?.requestAPIDidBegin()
        switch APIMode {
        case .loginDataPost:

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.login)"
            guard let userData = userData as? LoginAPIPostData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.wrongType)
                return
            }

            let userDataToPost = LoginAPIPostData(userName: userData.userName, password: userData.password)

            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()

                completion(NetworkError.unknown)
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                data, response, error in
                nowStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

                if error != nil {
                    self.delegate?.requestAPIDidError()
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(errorType)
                    return
                }

                guard let data = data,
                    let userData = try? JSONDecoder().decode(UserLoginAPIData.self, from: data) else {
                    self.delegate?.requestAPIDidError()
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(errorType)
                    return
                }

                print("now PrivateData is \(userData)")

                // MARK: - Token Check

                CommonUserData.shared.setUserPrivateData(token: userData.token, pk: userData.pk)

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        print("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(errorType)
                    }
                }
            }.resume()

        case .userDataPost:

            guard let userData = userData as? UserAPIPostData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.wrongType)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.userData)"
            print("userDataPostURLString : \(userDataPostURLString)")
            let userDataToPost = UserAPIPostData(userName: userData.userName, gender: userData.gender, styles: userData.styles, password: userData.password)
            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()
                completion(NetworkError.unknown)
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
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(errorType)
                }

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        print("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(errorType)
                    }
                }
            }.resume()

        case .clothingPost:

            guard let userData = userData as? UserClothingAPIData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.wrongType)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.clothing)"
            print("userDataPostURLString : \(userDataPostURLString)")

            let userDataToPost = UserClothingAPIData(style: userData.style, name: userData.name, color: userData.color, owner: userData.owner, season: userData.season, part: userData.part, images: userData.images)

            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
                let postURL = URL(string: userDataPostURLString) else {
                delegate?.requestAPIDidError()
                completion(NetworkError.unknown)
                return
            }

            var urlRequest = URLRequest(url: postURL)
            urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
                resultData, response, error in

                if error != nil {
                    print("Error Occurred...! : \(String(error?.localizedDescription ?? ""))")
                    self.delegate?.requestAPIDidError()
                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                    completion(errorType)
                }

                guard let postAPIResultData = resultData else {
                    completion(errorType)
                    return
                }

                guard let postResultData = try? JSONDecoder().decode(UserClothingPostAPIResultData.self, from: postAPIResultData) else {
                    print("UserClothingPostAPIResultData Decode Error")
                    completion(errorType)
                    return
                }

                //                print("postResultData is.. \(postResultData)")
                CommonUserData.shared.setClothingCode(postResultData.images[0].clothing)

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        print("request successed : \(response.statusCode)")
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
                        completion(errorType)
                    }
                }
            }.resume()

        case .clothingUploadPost:
            // 구현예정)
            //            guard let userData = userData as? UserClothingUploadData else {
            //                delegate?.requestAPIDidError()
            //                completion(NetworkError.wrongType)
            //                return
            //            }
            //
            //            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.clothingUpload)"
            completion(nil)
            //            let userDataToPost = UserClothingAPIData(style: userData.style, name: userData.name, color: userData.color, owner: userData.owner, season: userData.season, part: userData.part, images: userData.images)
            //
            //            guard let userAPIData = try? JSONEncoder().encode(userDataToPost),
            //                let postURL = URL(string: userDataPostURLString) else {
            //                delegate?.requestAPIDidError()
            //                completion(NetworkError.unknown)
            //                return
            //            }

            //            var urlRequest = URLRequest(url: postURL)
            //            urlRequest.setValue("token \(CommonUserData.shared.userToken)", forHTTPHeaderField: "Authorization")
            //            urlRequest.httpMethod = "POST"
            //            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            // URLSession을 만들어 Post 작용을 시작한다.
            //            urlSession.uploadTask(with: urlRequest, from: userAPIData) {
            //                resultData, response, error in
            //
            //                if error != nil {
            //                    print("Error Occurred...! : \(String(error?.localizedDescription ?? ""))")
            //                    self.delegate?.requestAPIDidError()
            //                    self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
            //                    completion(errorType)
            //                }
            //
            //                guard let postAPIResultData = resultData else {
            //                    completion(errorType)
            //                    return
            //                }
            //
            //                guard let postResultData = try? JSONDecoder().decode(UserClothingPostAPIResultData.self, from: postAPIResultData) else {
            //                    print("UserClothingPostAPIResultData Decode Error")
            //                    completion(errorType)
            //                    return
            //                }
            //                print("postResultData is.. \(postResultData)")
            //
            //                if let response = response as? HTTPURLResponse {
            //                    if (200 ... 299).contains(response.statusCode) {
            //                        print("request successed : \(response.statusCode)")
            //                        self.delegate?.requestAPIDidFinished()
            //                        completion(nil)
            //                    } else {
            //                        print("request failed : \(response.statusCode)")
            //                        self.delegate?.requestAPIDidError()
            //                        self.classifyErrorType(statusCode: nowStatusCode, errorType: &errorType)
            //                        completion(errorType)
            //                    }
            //                }
            //            }.resume()
        }
    }

    func classifyErrorType(statusCode: Int, errorType: inout NetworkError) {
        if statusCode / 100 == 4 { errorType = .client }
        else if statusCode / 100 == 5 { errorType = .server }
        else { errorType = .unknown }
    }
}
