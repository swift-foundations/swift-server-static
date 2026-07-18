extension Server.Static {
    /// The complete decision an engine adapter needs to turn into a response.
    public enum Outcome: Equatable, Sendable {
        case resource(Resource)
        case redirect(String)
        case notFound
        case rejected(Reason)
    }
}
