import Foundation

class PromiseOperation : Operation {

	var block: ((Any?) -> (((Any?) -> (), (NSError) -> ()) -> ()))?
	var promise: (((Any?) -> (), (NSError) -> ()) -> ())?

	init(promise: (((Any?) -> (), (NSError) -> ()) -> ())) {
		self.promise = promise
	}

	init(block: (Any?) -> (((Any?) -> (), (NSError) -> ()) -> ())) {
		self.block = block
	}

	override func main() {
		let group = dispatch_group_create()
		dispatch_group_enter(group)

		if let b = block, op = dependencies.last as? Operation {
			promise = b(op.output)
		}

		promise!({
			self.output = $0
			dispatch_group_leave(group)
		}, {
			self.catchError?($0)
			dispatch_group_leave(group)
		})

		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
	}

}