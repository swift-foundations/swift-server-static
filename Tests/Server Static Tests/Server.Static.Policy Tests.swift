import Testing

@testable import Server_Static

extension Server.Static.Policy {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension Server.Static.Policy.Test.Unit {
    @Test
    func `resolves root and trailing slash indexes`() {
        let policy = Server.Static.Policy()

        #expect(policy.resolve(.init(path: "/")) == .resource(.init(path: "index.html", kind: .index)))
        #expect(policy.resolve(.init(path: "/docs/")) == .resource(.init(path: "docs/index.html", kind: .index)))
    }

    @Test
    func `resolves documentation and tutorial indexes`() {
        let policy = Server.Static.Policy()

        #expect(policy.resolve(.init(path: "/documentation")) == .redirect("/documentation/"))
        #expect(policy.resolve(.init(path: "/documentation/")) == .resource(.init(path: "documentation/index.html", kind: .index)))
        #expect(policy.resolve(.init(path: "/tutorial/")) == .resource(.init(path: "tutorial/index.html", kind: .index)))
    }
}

extension Server.Static.Policy.Test.`Edge Case` {
    @Test
    func `decodes percent encoded paths`() {
        let policy = Server.Static.Policy()

        #expect(policy.resolve(.init(path: "/hello%20world.txt")) == .resource(.init(path: "hello world.txt")))
        #expect(policy.resolve(.init(path: "/data/documentation.json")) == .resource(.init(path: "data/documentation.json", kind: .documentationJSON)))
    }

    @Test
    func `rejects decoded traversal and malformed encoding`() {
        let policy = Server.Static.Policy()

        #expect(policy.resolve(.init(path: "/%2E%2E/private")) == .rejected(.traversal))
        #expect(policy.resolve(.init(path: "/public/%2E%2E/private")) == .rejected(.traversal))
        #expect(policy.resolve(.init(path: "/public%2F%2E%2E%2Fprivate")) == .rejected(.traversal))
        #expect(policy.resolve(.init(path: "/bad%2")) == .rejected(.invalidPercentEncoding))
        #expect(policy.resolve(.init(path: "/bad%FF")) == .rejected(.invalidUTF8))
    }

    @Test
    func `rejects decoded null bytes`() {
        let policy = Server.Static.Policy()

        #expect(policy.resolve(.init(path: "/private%00.txt")) == .rejected(.invalidPath))
    }
}

extension Server.Static.Policy.Test.Integration {
    @Test
    func `resolves static assets by configured prefix`() {
        let policy = Server.Static.Policy(
            profile: .init(
                archive: .init(
                    documentationJSON: "metadata/documentation.json",
                    assetPrefix: "static"
                )
            )
        )

        #expect(policy.resolve(.init(path: "/static/site.css")) == .resource(.init(path: "static/site.css", kind: .asset)))
        #expect(policy.resolve(.init(path: "/documentation.json")) == .resource(.init(path: "metadata/documentation.json", kind: .documentationJSON)))
        #expect(policy.resolve(.init(path: "/metadata/documentation.json")) == .resource(.init(path: "metadata/documentation.json", kind: .documentationJSON)))
    }
}
