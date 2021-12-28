# URLQueryEncoder

A customizable Swift `Encoder` that encodes instances of data types as URL query items. Supports all OpenAPI [serialization options](https://swagger.io/docs/specification/serialization/).

## Examples

### Encoding Primitives

```swift
let encoder = URLQueryEncoder()
encoder.encode(id, forKey: "id")

print(encoder.queryItems)
// [URLQueryItem(name: "id", value: "5")]
```

### Encoding Arrays

```swift
let ids = [3, 4, 5]
let encoder = URLQueryEncoder()
encoder.encode(ids, forKey: "id")

// Query: "id=3&id=4&id=5"
```

With an `explode` option disabled:

```swift
let ids = [3, 4, 5]
let encoder = URLQueryEncoder()
encoder.encode(ids, forKey: "id", explode: false)

// Query: "id=3,4,5"
```

With an `explode` option disabled and a custom delimiter:

```swift
let ids = [3, 4, 5]
let encoder = URLQueryEncoder()
encoder.encode(ids, forKey: "id", explode: false, delimeter: "|")

// Query: "id=3|4|5"
```

### Encoding Objects

```swift
let user = User(role: "admin", name: "kean")

let encoder = URLQueryEncoder()
encoder.encode(user, forKey: "id")

// Query: "role=admin&name=kean"
```

With an `explode` option disabled:

```swift
let user = User(role: "admin", name: "kean")

let encoder = URLQueryEncoder()
encoder.encode(user, forKey: "id", explode: false)

// Query: "id=role,admin,name,kean"
```

As a "deep" object:

```swift
let user = User(role: "admin", name: "kean")

let encoder = URLQueryEncoder()
encoder.encode(user, forKey: "id", isDeepObject: true)

// Query: "id[role]=admin&id[name]=kean")"
```

> If you are encoding a request body using URL-form encoding, you can use a convenience `URLQueryEncoder.encode(_:)` method. 

## Encoding Options

There are two ways to change the encoding options. You can set them directly on `URLQueryEncoder` instance.

```swift
let encoder = URLQueryEncoder()
encoder.explode = false
encoder.isDeepObject = true
encoder.delimiter = "|"
encoder.dateEncodingStrategy = .millisecondsSince1970
```

Or pass options in each individual `encode` call. 

```swift
let user = User(role: "admin", name: "kean")
let ids = [3, 4, 5]

let encoder = URLQueryEncoder()
encoder.encode(ids, forKey: "ids", explode: false)
encoder.encode(ids, forKey: "ids2", explode: true)
encoder.encode(user, forKey: "user", isDeepObject: true)
encoder.encode(2, forKey: "id")

// Query: "ids=3,4,5&ids2=3&ids2=4&ids2=5&user[role]=admin&user[name]=kean&id=2"
```

The reason it's designed this way is that in OpenAPI each parameter can come with different serialization options.

## Accessing Results

You can access the encoding results at any time, and they come in different forms:

```swift
public final class URLQueryEncoder {
    // Encoded query items.
    public var queryItems: [URLQueryItem]
    // Encoded query items as name-value pairs.
    public var items: [(String, String?)]
    // The encoded query items as a URL query subcomponent.
    public var query: String?
    // The encoded query items as a URL query subcomponent with percent-encoded values.
    public var percentEncodedQuery: String?
}
```

## License

URLQueryEncoder is available under the MIT license. See the LICENSE file for more info.
