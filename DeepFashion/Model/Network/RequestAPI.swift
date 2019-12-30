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

enum APIDeleteMode: String {
    case deleteUser
}

struct APIURL {
    static let base = "http://deepfashion-dev.us-west-2.elasticbeanstalk.com/"
    struct SubURL {
        struct Delete {
            static let deleteUser = "accounts/"
        }

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
                            fileKey _: String,
                            imageName _: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\("img")\"; filename=\"\("clothing.jpg")\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        return body as Data
    }

    func deleteAPIData(APIMode: APIDeleteMode, completion: @escaping (NetworkError?) -> Void) {
        var errorType: NetworkError = .unknown

        delegate?.requestAPIDidBegin()

        switch APIMode {
        case .deleteUser:
            let deleteUserURLString = "\(APIURL.base)\(APIURL.SubURL.Delete.deleteUser)\(UserCommonData.shared.pk)/"
            guard let deleteURL = URL(string: deleteUserURLString) else {
                errorType = .client
                delegate?.requestAPIDidError()
                completion(errorType)
                return
            }

            var urlRequest = URLRequest(url: deleteURL)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("token \(UserCommonData.shared.userToken)", forHTTPHeaderField: "Authorization")

            urlSession.dataTask(with: urlRequest) { _, response, error in
                if error != nil {
                    errorType = .client
                    self.delegate?.requestAPIDidError()
                    completion(errorType)
                    return
                }

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
                        self.delegate?.requestAPIDidFinished()
                        completion(nil)
                    } else {
                        print("request failed : \(response.statusCode)")
                        self.delegate?.requestAPIDidError()
                        self.classifyErrorType(statusCode: response.statusCode, errorType: &errorType)
                        completion(errorType)
                    }
                }

            }.resume()
        }
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

                UserCommonData.shared.setUserPrivateData(token: userData.token, pk: userData.pk)

                if let response = response as? HTTPURLResponse {
                    if (200 ... 299).contains(response.statusCode) {
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

            guard let userData = userData as? ClothingAPIData else {
                delegate?.requestAPIDidError()
                completion(NetworkError.wrongType)
                return
            }

            let userDataPostURLString = "\(APIURL.base)\(APIURL.SubURL.Post.clothing)"
            guard let postURL = URL(string: userDataPostURLString) else { return }
            print("userDataPostURLString : \(userDataPostURLString)")

            let imageName = AssetIdentifier.Image.clothing
            userData.image?.accessibilityIdentifier = imageName

            // post 처리 할 parameter를 정의한다.
            let parameter = [
                "name": "\(userData.name)",
                "style": "\(userData.style)",
                "owner": "\(UserCommonData.shared.pk)",
                "color": "\(userData.color)",
                "season": "\(userData.season)",
                "part": "\(userData.part)",
            ]

            // request 설정
            var urlRequest = URLRequest(url: postURL)
            urlRequest.setValue("token \(UserCommonData.shared.userToken)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"

            // multipart form-data로 보낼 것임을 설정한다.
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let clothingMimeType = "image/jpg"
            let clothingImageKey = "img"

            let imageData = userData.image!.jpegData(compressionQuality: 1)!

            urlRequest.httpBody = createBody(parameters: parameter, boundary: boundary, data: imageData, mimeType: clothingMimeType, fileKey: clothingImageKey, imageName: imageName)
            // URLSession을 만들어 Post 작용을 시작한다.
            urlSession.dataTask(with: urlRequest) { _, response, _ in
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
            break
        }
    }

    func classifyErrorType(statusCode: Int, errorType: inout NetworkError) {
        if statusCode / 100 == 4 { errorType = .client }
        else if statusCode / 100 == 5 { errorType = .server }
        else { errorType = .unknown }
    }
}
