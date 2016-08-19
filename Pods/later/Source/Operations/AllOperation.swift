import Foundation

class AllOperation : Operation {

	var blocks: [(Any?) -> (Any?)]

	init(_ block: [(Any?) -> (Any?)]) {
		self.blocks = block
	}

	override func main() {
		var results = [Any?](count: self.blocks.count, repeatedValue: nil)
		let operation = dependencies.last as? Operation

		let group = dispatch_group_create()
		let queue = dispatch_get_global_queue(
			DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

		for (i, block) in blocks.enumerate() {
			dispatch_group_async(group, queue, { () -> () in
				results[i] = block(operation?.output)
			})
		}

		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

		output = results
	}

}