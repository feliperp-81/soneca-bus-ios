import Foundation

internal extension Dictionary {

	var asJSON: String {
		let data = try! NSJSONSerialization.dataWithJSONObject(
			self as! AnyObject, options: NSJSONWritingOptions())

		return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
	}

	var asQueryItems: [NSURLQueryItem] {
		var items = [NSURLQueryItem]()

		for (key, value) in self {
			if ((value is [AnyObject]) || (value is [String: AnyObject])) {
				let data = try! NSJSONSerialization.dataWithJSONObject(
					value as! AnyObject, options: NSJSONWritingOptions())

				let json = NSString(data: data, encoding: NSUTF8StringEncoding)

				items.append(
					NSURLQueryItem(name: "\(key)", value: json! as String))
			}
			else {
				items.append(NSURLQueryItem(name: "\(key)", value: "\(value)"))
			}
		}

		return items
	}

}