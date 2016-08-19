extension Promise {

	 public func all(block: (T) -> (Any?)...) -> Promise<[Any?]> {
		var blocks: [Any? -> Any?] = []

		for b in block {
			blocks.append({ input in
				return b(input as! T)
			})
		}

		addDependency(AllOperation(blocks))

		return Promise<[Any?]>(self.operations)
	}

}