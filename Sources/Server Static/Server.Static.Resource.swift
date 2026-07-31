public import Server

extension Server.Static {
    /// A resource path selected for an engine adapter to read and serve.
    public struct Resource: Equatable, Sendable {
        public let path: String
        public let kind: Kind

        public init(path: String, kind: Kind = .file) {
            self.path = path
            self.kind = kind
        }
    }
}
