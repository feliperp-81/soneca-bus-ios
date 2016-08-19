import Foundation

public class Query : CustomStringConvertible {

	public private(set) var query = [String: AnyObject]()

	public enum QueryType: String {
		case COUNT = "count", FETCH = "fetch"
	}

	public enum Order: String {
		case ASC = "asc", DESC = "desc"
	}

	public var description: String {
		return query.asJSON
	}

	public init() {}

	public func count() -> Self {
		return type(.COUNT)
	}

	public func fetch() -> Self {
		return type(.FETCH)
	}

	public func filter(field: String, _ value: AnyObject) -> Self {
		return self.filter(Filter(field, value))
	}

	public func filter(field: String, _ op: String, _ value: AnyObject)
		-> Self {

		return self.filter(Filter(field, op, value))
	}

	public func filter(filter: Filter) -> Self {
		var filters = query["filter"] as? [[String: AnyObject]] ??
			[[String: AnyObject]]()

		filters.append(filter.filter)

		query["filter"] = filters
		return self
	}

	public func limit(limit: Int) -> Self {
		query["limit"] = limit
		return self
	}

	public func offset(offset: Int) -> Self {
		query["offset"] = offset
		return self
	}

	public func sort(name: String, order: Order = .ASC) -> Self {
		var sort = query["sort"] as? [[String: String]] ?? [[String: String]]()
		sort.append([name: order.rawValue])

		query["sort"] = sort
		return self
	}

	public func type(type: QueryType) -> Self {
		query["type"] = type.rawValue
		return self
	}

}