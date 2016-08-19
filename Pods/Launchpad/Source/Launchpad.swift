import Foundation
import later
import Socket_IO_Client_Swift

public class Launchpad {

	var auth: Auth?
	var headers = [String: String]()
	var path = ""
	var query = Query()
	var transport: Transport = NSURLSessionTransport()

	var params: [NSURLQueryItem] {
		return _params + query.query.asQueryItems
	}

	var url: String {
		return _url + path
	}

	var _params = [NSURLQueryItem]()
	var _url: String

	public init(_ url: String) {
		_url = url
	}

	public class func url(url: String) -> Launchpad {
		return Launchpad(url)
	}

	public func auth(auth: Auth) -> Self {
		self.auth = auth
		return self
	}

	public func count() -> Self {
		query.count()
		return self
	}

	public func delete() -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .DELETE, headers: self.headers, url: self.url,
				params: self.params)

			self.auth?.authenticate(request)
			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func filter(field: String, _ value: AnyObject) -> Self {
		query.filter(field, value)
		return self
	}

	public func filter(field: String, _ op: String, _ value: AnyObject)
		-> Self {

		query.filter(field, op, value)
		return self
	}

	public func filter(filter: Filter) -> Self {
		query.filter(filter)
		return self
	}

	public func get() -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				headers: self.headers, url: self.url, params: self.params)

//			self.auth?.authenticate(request)
			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func header(name: String, _ value: String) -> Self {
		headers[name] = value
		return self
	}

	public func limit(limit: Int) -> Self {
		query.limit(limit)
		return self
	}

	public func offset(offset: Int) -> Self {
		query.offset(offset)
		return self
	}

	public func param(name: String, _ value: String) -> Self {
		_params.append(NSURLQueryItem(name: name, value: value))
		return self
	}

	public func patch(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .PATCH, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.auth?.authenticate(request)
			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func path(path: String) -> Self {
		self.path += path
		return self
	}

	public func post(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .POST, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.auth?.authenticate(request)
			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func put(body: AnyObject?) -> Promise<Response> {
		let promise = Promise<Response>(promise: { fulfill, reject in
			let request = Request(
				method: .PUT, headers: self.headers, url: self.url,
				params: self.params, body: body)

			self.auth?.authenticate(request)
			self.transport.send(request, success: fulfill, failure: reject)
		})

		return promise
	}

	public func sort(name: String, order: Query.Order = .ASC) -> Self {
		query.sort(name, order: order)
		return self
	}

	public func use(transport: Transport) -> Self {
		self.transport = transport
		return self
	}

	public func watch(options: Set<SocketIOClientOption> = [])
		-> SocketIOClient {

		return SocketIOClientFactory.create(
			self.url, params: self.params, options: options)
	}

}