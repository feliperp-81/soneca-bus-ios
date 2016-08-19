import Foundation

class Operation : NSOperation {

	var catchError: ((NSError) -> ())?
	var output: Any?

}