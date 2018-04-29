//
//  NetworkClient.swift
//  CalendarApp
//
//  Created by David on 2016/9/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

public protocol NetworkClientType {
	func performRequest<Request: NetworkRequest>(_ networkRequest: Request) -> Promise<Data>
	func performArrayRequest<Request: NetworkRequest>(_ networkRequest: Request) -> Promise<(Data, Progress)>
	func performUploadRequest<Request: NetworkRequest>(_ networkRequest: Request) -> Promise<Data>
}

public struct NetworkClient: NetworkClientType {
	
	public func performRequest<Request : NetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
		
		let (promise, fulfill, reject) = Promise<Data>.pending()
		print("🔗", #function, "send request to url:", networkRequest.url)
        print("📩 method:", networkRequest.method)
        print("🚠 parameters:", networkRequest.parameters ?? [:])
		
		request(networkRequest.url,
		        method: networkRequest.method,
		        parameters: networkRequest.parameters,
		        encoding: networkRequest.encoding,
		        headers: networkRequest.headers)
			.validate().response { (response) in
				if let data = response.data , response.error == nil {
					fulfill(data)
				} else if let error = response.error, let data = response.data {
					let e = handleNetworkRequestError(error, data: data, urlResponse: response.response)
					reject(e)
                    print(e)
				} else {
                    print("網路發生未知錯誤")
					reject(NetworkRequestError.unknownError)
				}
		}
		
		return promise
	}
	
	public func performArrayRequest<Request : NetworkRequest>(_ networkRequest: Request) -> Promise<(Data, Progress)> {
		return performRequest(networkRequest).then { data in
			return Promise(value: (data, networkRequest.progress))
		}
	}
	
	public func performUploadRequest<Request : NetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
		
		let (promise, fulfill, reject) = Promise<Data>.pending()
		
		let formData = MultipartFormData()
		formData.append(networkRequest.multipartUploadData, withName: "avatar", fileName: "file", mimeType: "image/jpeg")

		upload(multipartFormData: { multipartFormData in
			multipartFormData.append(networkRequest.multipartUploadData, withName: "avatar", fileName: "file", mimeType: "image/jpeg")
			}, usingThreshold: 0, to: networkRequest.url, method: networkRequest.method, headers: networkRequest.headers) { (encodingResult) in
				switch encodingResult {
				case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
					request.response(completionHandler: { (response) in
						if let data = response.data , response.error == nil {
							fulfill(data)
						} else if let error = response.error, let data = response.data {
							let e = handleNetworkRequestError(error, data: data, urlResponse: response.response)
							reject(e)
						} else {
							reject(NetworkRequestError.unknownError)
						}
					})
				case .failure(let error):
					reject(error)
				}
		}
		
		return promise
	}
	
}

private func handleNetworkRequestError(_ error: Error, data: Data?, urlResponse: HTTPURLResponse?) -> Error {
    if (error as NSError).code == -1009 {
        return NetworkRequestError.noNetworkConnection
    } else {
        let responseBody: JSON? = (data != nil ? try? JSON(data: data!) : nil)
        let statusCode = urlResponse?.statusCode
        let errorCode = responseBody?["error_code"].string
        let e = NetworkRequestError.apiUnacceptable(error: error, statusCode: statusCode, responseBody: responseBody, errorCode: errorCode)
        return e as Error
    }
}
