# URLQueryEncoder

A customizable Swift `Encoder` that encodes instances of data types as URL query items. Supports all [OpenAPI] query parameter [serialization options](https://swagger.io/docs/specification/serialization/).

## Examples

### Encoding Primitives

```swift
let encoder = URLQueryEncoder()
encoder.encode(["id": id])

print(encoder.queryItems)
// [URLQueryItem(name: "id", value: "5")]
```

### Encoding Arrays

```swift
let ids = [3, 4, 5]
let encoder = URLQueryEncoder()
encoder.encode(["id": ids])

// Query: "id=3&id=4&id=5"
```

With an `explode` option disabled:

```swift
let ids = [3, 4, 5]
let encoder = URLQueryEncoder()
encoder.encode(["id": ids], explode: false)

// Query: "id=3,4,5"
```

With an `explode` option disabled and a custom delimiter:

```swift
let ids = [3, 4, 5]
let encoder = URLQueryEncoder()
encoder.encode(["id": ids], explode: false, delimiter: "|")

// Query: "id=3|4|5"
```

### Encoding Objects

```swift
let user = User(role: "admin", name: "kean")

let encoder = URLQueryEncoder()
encoder.encode(user)

// Query: "role=admin&name=kean"
```

With an `explode` option disabled:

```swift
let user = User(role: "admin", name: "kean")

let encoder = URLQueryEncoder()
encoder.encode(user, explode: false)

// Query: "id=role,admin,name,kean"
```

As a "deep" object:

```swift
let user = User(role: "admin", name: "kean")

let encoder = URLQueryEncoder()
encoder.encode(user, isDeepObject: true)

// Query: "id[role]=admin&id[name]=kean")"
```

## Encoding Options

There are two ways to change the encoding options: settings them directly on `URLQueryEncoder` instance, or passing options in each individual `encode` call. The reason it's designed this way is that in OpenAPI, each parameter can have different serialization options.

```swift
let encoder = URLQueryEncoder()
encoder.explode = false
encoder.isDeepObject = true
encoder.delimiter = "|"
encoder.dateEncodingStrategy = .millisecondsSince1970
```

You can use `URLQueryEncoder` to encode more that one parameter are a time:

```swift
let user = User(role: "admin", name: "kean")
let ids = [3, 4, 5]

let encoder = URLQueryEncoder()
encoder.encode(["ids": ids], explode: false)
encoder.encode(["ids2": ids], explode: true)
encoder.encode(["user": user], isDeepObject: true)
encoder.encode(["id": 2])

// Query: "ids=3,4,5&ids2=3&ids2=4&ids2=5&user[role]=admin&user[name]=kean&id=2"
```

## Accessing Results

You can access the encoding results at any time, and they come in different forms:

```swift
public final class Encoder {
    public var queryItems: [URLQueryItem]
    public var items: [(String, String?)]
    
    public var query: String?
    public var percentEncodedQuery: String?
}
```

## License

URLQueryEncoder is available under the MIT license. See the LICENSE file for more info.
