import Foundation
import Socket_IO_Client_Swift

public class SocketIOClientFactory {

	class func create(
			url: String, params: [NSURLQueryItem]? = [],
			var options: Set<SocketIOClientOption> = [])
		-> SocketIOClient {

		if (!options.contains(.ForceNew(false))) {
			options.insert(.ForceNew(true))
		}

		let url = parseURL(url, params: params)

		options.insert(.ConnectParams(["EIO": "3", "url": url.query]))
		options.insert(.Path(url.path))

		let socket = SocketIOClient(socketURL: url.host, options: options)
		socket.connect()

		return socket
	}

	class func parseURL(url: String, params: [NSURLQueryItem]? = [])
		-> (host: String, path: String, query: String) {

		let URL = NSURLComponents(string: url)!
		URL.queryItems = params

		let host = URL.host ?? ""
		var port = ""

		if let p = URL.port where URL.port != 80 {
			port = ":\(p)"
		}

		let path = URL.path!
		var query = path

		if let q = URL.query {
			query = "\(path)?\(q)"
		}

		return ("\(host)\(port)", path, query)
	}

}