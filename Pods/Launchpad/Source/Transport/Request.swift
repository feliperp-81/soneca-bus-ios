import Foundation

public class Request {

	var body: AnyObject?
	var headers: [String: String]
	var method: RequestMethod
	var params: [NSURLQueryItem]
	var url: String

	init(
		method: RequestMethod = .GET, headers: [String: String]?, url: String,
		params: [NSURLQueryItem]?, body: AnyObject? = nil) {

		self.method = method
		self.headers = headers ?? [:]
		self.headers["X-Requested-With"] = "api.swift"
		self.url = url
		self.params = params ?? []
		self.body = body
	}

	func setRequestBody(request: NSMutableURLRequest) throws {
		guard let b = body else {
			return
		}

		if let stream = b as? NSInputStream {
			request.HTTPBodyStream = stream
		}
		else if let string = b as? String {
			request.HTTPBody = string.dataUsingEncoding(NSUTF8StringEncoding)
		}
		else {
			request.setValue(
				"application/json", forHTTPHeaderField: "Content-Type")

			request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(
				b, options: NSJSONWritingOptions())
		}
	}

	func toURLRequest() throws -> NSURLRequest  {
		let URL = NSURLComponents(string: url)!
		URL.queryItems = params

		let request = NSMutableURLRequest(URL: URL.URL!)
		request.HTTPMethod = method.rawValue

		for (name, value) in headers {
			request.addValue(value, forHTTPHeaderField: name)
		}

		try setRequestBody(request)

		return request
	}

}