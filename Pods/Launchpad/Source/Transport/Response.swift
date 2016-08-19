import Foundation

public class Response {

	public private(set) var body: AnyObject?
	public let headers: [String: String]
	public let statusCode: Int

	public var contentType: String? {
		return headers["Content-Type"]
	}

	public var succeeded: Bool {
		return (statusCode >= 200) && (statusCode <= 399)
	}

	init(statusCode: Int, headers: [String: String], body: NSData) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = parse(body)
	}

	func parse(body: NSData) -> AnyObject? {
		if (contentType?.rangeOfString("application/json") != nil) {
			do {
				let parsed = try NSJSONSerialization.JSONObjectWithData(
					body, options: .AllowFragments)

				return parsed
			}
			catch {
				return parseString(body)
			}
		}
		else {
			return parseString(body)
		}
	}

	func parseString(body: NSData) -> NSString? {
		var string: NSString?

		if (body.length > 0) {
			string = NSString(data: body, encoding: NSUTF8StringEncoding)
		}

		return string
	}

}