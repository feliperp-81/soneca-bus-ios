[![Build Status](https://travis-ci.org/launchpad-project/api.swift.svg?branch=master)](https://travis-ci.org/launchpad-project/api.swift)

## Connect to your API

```ruby
pod 'Launchpad'
```

```swift
import Launchpad
```

## Read and Write Data

```swift
Launchpad
	.url("http://liferay.io/<YOUR-APP>/<YOUR-SERVICE>/items")
	.post([
		"title": "Star Wars IV",
		"year": 1977
	])
	.then { response in
		print("Data saved")
	}
.done()
```

```swift
Launchpad
	.url("http://liferay.io/<YOUR-APP>/<YOUR-SERVICE>/items")
	.get()
	.then { response in
		let movies = response.body as? [String: AnyObject]
		print(movies)
	}
.done()
```

```swift
Launchpad
	.url("http://liferay.io/app/service/movies")
	.filter("year", ">", 2000)
	.sort("rating")
	.limit(2)
	.offset(1)
	.get()
	.then { response in
		let movies = response.body as? [String: AnyObject]
		print(movies)
	}
.done()
```
