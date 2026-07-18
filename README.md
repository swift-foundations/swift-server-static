# Server Static

Generic static-resource and DocC archive route resolution for Swift servers.

The package is deliberately independent of filesystem and response-engine APIs. `Server.Static.Policy` converts a request path into a typed resource, redirect, or rejection that an engine adapter can serve. It percent-decodes paths, rejects traversal after decoding, resolves root and directory indexes, discovers the DocC documentation JSON resource, and classifies configured static-asset prefixes.

```swift
import Server_Static

let policy = Server.Static.Policy()
let outcome = policy.resolve(.init(path: "/documentation/"))
```

The public API is a policy surface only: it does not open files, produce responses, or depend on Vapor or FileIO.
