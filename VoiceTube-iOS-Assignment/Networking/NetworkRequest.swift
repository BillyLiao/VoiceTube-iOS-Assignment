//
//  NetworkRequest.swift
//  CalendarApp
//
//  Created by David on 2016/9/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// NetworkRequestError
///
/// - invalidData:         Fail to parse data from response.
/// - apiUnacceptable:     Fail to connect with api. Error information attached.
/// - unknownError:        Unknown error.
/// - noNetworkConnection: no network connection.
public enum NetworkRequestError: Error {
	case invalidData
    case apiUnacceptable(error: Error, statusCode: Int?, responseBody: JSON?, errorCode: String?)
	case unknownError
    case noNetworkConnection
}

public typealias Progress = ((String) -> ())?

/// NetworkRequest
///
/// All information you need to make a network request.
public protocol NetworkRequest {
	associatedtype ResponseType
	
	// Required
	/// End Point.
	/// Must start with a /.
	/// e.g. /cards/:id/dislike
	var endpoint: String { get }
	/// Will transform given data to requested type of response.
	var responseHandler: (Data) throws -> ResponseType { get }
	/// Will transform given data to requested array of type of responses.
	var arrayResponseHandler: (Data, Progress) throws -> [ResponseType] { get }
	var progress: Progress { get }
	
	// Optional
	var baseURL: String { get }
	/// Method to make the request. E.g. get, post.
	var method: Alamofire.HTTPMethod { get }
	/// Parameter encoding. E.g. JSON, URLEncoding.default.
	var encoding: Alamofire.ParameterEncoding { get }
	
	var parameters: [String : Any]? { get }
    var headers: [String : String] { get }
	var multipartUploadData: Data { get }
	var multipartUploadName: String { get }
	var multipartUploadFileName: String { get }
	var multipartUploadMimeType: String { get }
	
	/// Client that helps you to make reqeust.
	var networkClient: NetworkClientType { get }
	
}

public extension NetworkRequest {
	/// URL to make the request.
	public var url: String { return baseURL + endpoint }
	/// Access token to make the api request.
	// public var accessToken: String { return ColorgyUserInformation.sharedInstance().userAccessToken ?? "" }
    public var baseURL: String { return "https://api.voicetube.com" }
	public var method: Alamofire.HTTPMethod { return .get }
	public var encoding: Alamofire.ParameterEncoding { return JSONEncoding.default }
	
	public var parameters: [String : Any]? { return nil }
    // public var headers: [String : String] { return ["Authorization": "Bearer \(accessToken)", "Colorgy-App-Platform": "ios", "Colorgy-App-Version": ColorgyConfig.appVersion] }
    public var headers: [String : String] { return [:] }
    public var multipartUploadData: Data { return Data() }
	public var multipartUploadName: String { return "" }
	public var multipartUploadFileName: String { return "" }
	public var multipartUploadMimeType: String { return "" }
	
	public var networkClient: NetworkClientType { return NetworkClient() }
	public var progress: Progress { return nil }
}

extension NetworkRequest where ResponseType: JSONDecodable {
	public var responseHandler: (Data) throws -> ResponseType { return jsonResponseHandler }
	public var arrayResponseHandler: (Data, Progress) throws -> [ResponseType] { return jsonArrayResponseHandler }
}

extension NetworkRequest where ResponseType == () {
	public var responseHandler: (Data) throws -> ResponseType { return voidResponseHandler }
	public var arrayResponseHandler: (Data, Progress) throws -> [ResponseType] { return voidArrayResponseHandler }
}

private func jsonResponseHandler<Response: JSONDecodable>(_ data: Data) throws -> Response {
    guard let json = try? JSON(data: data) else { throw NetworkRequestError.invalidData }
    
    do {
        return try Response(decodeUsing: json)
    } catch {
        throw NetworkRequestError.invalidData
    }
}

private func jsonArrayResponseHandler<Response: JSONDecodable>(_ data: Data, progress: Progress) throws -> [Response] {
    guard let json = try? JSON(data: data) else { throw NetworkRequestError.invalidData }
    
	guard json.isArray else { throw JSONDecodableError.parseError }
	var responses: [Response] = []
	let courseCount = json.count
	for (key, json) in json {
		Queue.main { progress?("\(key)/\(courseCount)") }
		if let response = try? Response(decodeUsing: json) {
			responses.append(response)
		}
	}
	return responses
}

private func voidResponseHandler(_ data: Data) throws -> () {
	return ()
}

private func voidArrayResponseHandler(_ data: Data, progress: Progress) throws -> [()] {
	return []
}
