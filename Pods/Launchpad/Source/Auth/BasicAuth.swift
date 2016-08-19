import Foundation

public class BasicAuth : Auth {

	public var password: String
	public var username: String

	public init(_ username: String, _ password: String) {
		self.username = username
		self.password = password
	}

	public func authenticate(request: Request) {
		var credentials = "\(username):\(password)"
		let data = credentials.dataUsingEncoding(NSUTF8StringEncoding)
		credentials = data!.base64EncodedStringWithOptions(
			NSDataBase64EncodingOptions(rawValue: 0))

		request.headers["Authorization"] = "Basic " + credentials
	}

}