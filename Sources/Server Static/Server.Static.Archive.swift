extension Server.Static {
    /// The route layout of a static archive.
    public struct Archive: Equatable, Sendable {
        public let rootIndex: String
        public let documentationIndex: String
        public let tutorialIndex: String
        public let documentationJSON: String
        public let assetPrefix: String

        public init(
            rootIndex: String = "index.html",
            documentationIndex: String = "documentation/index.html",
            tutorialIndex: String = "tutorial/index.html",
            documentationJSON: String = "data/documentation.json",
            assetPrefix: String = "assets"
        ) {
            self.rootIndex = rootIndex
            self.documentationIndex = documentationIndex
            self.tutorialIndex = tutorialIndex
            self.documentationJSON = documentationJSON
            self.assetPrefix = assetPrefix
        }
    }
}
