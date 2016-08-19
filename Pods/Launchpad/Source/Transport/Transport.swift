import Foundation

public protocol Transport {

	func send(
		request: Request, success: (Response -> ()), failure: (NSError -> ()))

}

public class NSURLSessionTransport : Transport {

	public func send(
		request: Request, success: (Response -> ()), failure: (NSError -> ())) {

		let success = dispatchMainThread(success)
		let failure = dispatchMainThread(failure)
        
		let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
		let session = NSURLSession(configuration: config)

		do {
			let request = try request.toURLRequest()

			session.dataTaskWithRequest(
				request,
				completionHandler: { (data, r, error) in
					if let e = error {
						failure(e)
						return
					}

					let httpURLResponse = r as! NSHTTPURLResponse
					let headerFields = httpURLResponse.allHeaderFields
					var headers = [String: String]()

					for (key, value) in headerFields {
						headers[key.description] = value as? String
					}

					let response = Response(
						statusCode: httpURLResponse.statusCode,
						headers: headers, body: data!)

					success(response)
				}
			).resume()
		}
		catch let e as NSError {
			failure(e)
			return
		}
	}

	func dispatchMainThread<T>(block: (T -> ())) -> (Any? -> ()) {
		return { value in
			dispatch_async(dispatch_get_main_queue(), {
				block(value as! T)
			})
		}
	}

}