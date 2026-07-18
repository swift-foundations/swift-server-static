extension Server.Static {
    /// A typed reason why a request must not be served.
    public enum Reason: Error, Equatable, Sendable {
        case invalidPercentEncoding
        case invalidUTF8
        case traversal
        case invalidPath
    }
}
