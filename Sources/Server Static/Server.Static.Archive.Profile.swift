public import Server

extension Server.Static.Archive {
    /// Named archive layouts supported by the package.
    public struct Profile: Equatable, Sendable {
        public let archive: Server.Static.Archive

        public init(archive: Server.Static.Archive) {
            self.archive = archive
        }
    }
}

extension Server.Static.Archive.Profile {
    /// The standard static-hosting layout produced for a DocC archive.
    public static let docC = Self(archive: .init())
}
