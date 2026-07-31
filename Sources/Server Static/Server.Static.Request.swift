public import Server

extension Server.Static {
    /// An engine-neutral request path presented to the static policy.
    public struct Request: Equatable, Sendable {
        /// The request target's path component, including an optional leading slash.
        public let path: String

        public init(path: String) {
            self.path = path
        }
    }
}
