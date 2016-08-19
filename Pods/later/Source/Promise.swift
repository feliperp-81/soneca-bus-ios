import Foundation

public class Promise<T: Any> {

	var operations = [Operation]()
	var promise: (((Any?) -> (), (NSError) -> ()) -> ())?

	public init(_ block: () -> (T)) {
		addDependency(BlockOperation { input in
			return block()
		})
	}

	public init(promise: ((T) -> (), (NSError) -> ()) -> ()) {
		self.promise = { fulfill, reject in
			promise({ fulfill($0) }, reject)
		}

		addDependency(PromiseOperation(promise: self.promise!))
	}

	init(_ operations: [Operation]) {
		self.operations = operations
	}

	public func done(block: ((T?, NSError?) -> ())? = nil) {
		let queue = NSOperationQueue()

		for operation in operations {
			operation.catchError = getCatchError(queue, block: block)
		}

		if let done = block {
			addDependency(BlockOperation({ input in
				dispatch_async(dispatch_get_main_queue(), {
					done(input as! T?, nil)
				})
			}))
		}

		queue.addOperations(operations, waitUntilFinished: false)
	}

	public func then<U: Any>(block: (T) -> (U)) -> Promise<U> {
		addDependency(BlockOperation { input in
			return block(input as! T) as U
		})

		return Promise<U>(self.operations)
	}

	public func then<U: Any>(block: (T) -> (U, NSError?)) -> Promise<U> {
		addDependency(BlockTupleOperation { input in
			let output = block(input as! T)
			return (output.0, output.1)
		})

		return Promise<U>(self.operations)
	}

	public func then<U: Any>(block: (T) -> (Promise<U>)) -> Promise<U> {
		addDependency(PromiseOperation(block: { input in
			return block(input as! T).promise!
		}))

		return Promise<U>(self.operations)
	}

	func addDependency(operation: Operation) {
		if let last = operations.last {
			operation.addDependency(last)
		}

		operations.append(operation)
	}

	func getCatchError(
			queue: NSOperationQueue, block: ((T?, NSError?) -> ())?)
		-> ((NSError) -> ()) {

		return { error in
			queue.cancelAllOperations()

			if let done = block {
				dispatch_async(dispatch_get_main_queue(), {
					done(nil, error)
				})
			}
		}
	}

}