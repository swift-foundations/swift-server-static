extension Server.Static.Resource {
    /// The adapter-relevant class of a selected resource.
    public enum Kind: Equatable, Sendable {
        case file
        case documentationJSON
        case asset
        case index
    }
}
