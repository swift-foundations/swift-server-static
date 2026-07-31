public import Server

extension Server.Static {
    /// Resolves static and DocC archive requests without performing I/O.
    public struct Policy: Equatable, Sendable {
        public let archive: Archive

        public init(profile: Archive.Profile = .docC) {
            self.archive = profile.archive
        }

        /// Resolves a request into a resource, redirect, or typed rejection.
        public func resolve(_ request: Request) -> Outcome {
            switch Self.path(from: request.path) {
            case .failure(let reason):
                return .rejected(reason)
            case .success(let path):
                return resolve(path: path)
            }
        }

        private func resolve(path: String) -> Outcome {
            guard !path.isEmpty else {
                return .resource(.init(path: archive.rootIndex, kind: .index))
            }

            if path == "documentation" || path == "tutorial" {
                return .redirect("/\(path)/")
            }

            if path == "documentation/" {
                return .resource(.init(path: archive.documentationIndex, kind: .index))
            }

            if path == "tutorial/" {
                return .resource(.init(path: archive.tutorialIndex, kind: .index))
            }

            if path == "documentation.json" || path == archive.documentationJSON {
                return .resource(.init(path: archive.documentationJSON, kind: .documentationJSON))
            }

            if path.hasPrefix("\(archive.assetPrefix)/") {
                return .resource(.init(path: path, kind: .asset))
            }

            if path.hasSuffix("/") {
                return .resource(.init(path: path + "index.html", kind: .index))
            }

            return .resource(.init(path: path))
        }

        private static func path(from requestPath: String) -> Result<String, Reason> {
            guard !requestPath.isEmpty else { return .success("") }

            let leadingSlashRemoved = requestPath.first == "/" ? String(requestPath.dropFirst()) : requestPath

            switch decode(leadingSlashRemoved) {
            case .failure(let reason):
                return .failure(reason)
            case .success(let decodedPath):
                return normalized(decodedPath)
            }
        }

        private static func normalized(_ path: String) -> Result<String, Reason> {
            let trailingSlash = path.last == "/"
            let components = path.split(separator: "/", omittingEmptySubsequences: true)
            var decoded: [String] = []
            decoded.reserveCapacity(components.count)

            for component in components {
                guard !component.contains("\0") else { return .failure(.invalidPath) }
                guard component != ".." else { return .failure(.traversal) }
                guard component != "." else { continue }
                decoded.append(String(component))
            }

            let path = decoded.joined(separator: "/")
            return .success(trailingSlash && !path.isEmpty ? path + "/" : path)
        }

        private static func decode(_ component: String) -> Result<String, Reason> {
            var bytes: [UInt8] = []
            bytes.reserveCapacity(component.utf8.count)
            let source = Array(component.utf8)
            var index = 0

            while index < source.count {
                guard source[index] == 37 else {
                    bytes.append(source[index])
                    index += 1
                    continue
                }

                guard index + 2 < source.count,
                    let high = hex(source[index + 1]),
                    let low = hex(source[index + 2])
                else {
                    return .failure(.invalidPercentEncoding)
                }
                bytes.append(high * 16 + low)
                index += 3
            }

            guard isUTF8(bytes) else {
                return .failure(.invalidUTF8)
            }
            return .success(String(decoding: bytes, as: UTF8.self))
        }

        private static func isUTF8(_ bytes: [UInt8]) -> Bool {
            var index = 0
            while index < bytes.count {
                let first = bytes[index]
                if first <= 0x7F {
                    index += 1
                } else if 0xC2...0xDF ~= first {
                    guard index + 1 < bytes.count, 0x80...0xBF ~= bytes[index + 1] else { return false }
                    index += 2
                } else if first == 0xE0 {
                    guard index + 2 < bytes.count, 0xA0...0xBF ~= bytes[index + 1], 0x80...0xBF ~= bytes[index + 2] else { return false }
                    index += 3
                } else if 0xE1...0xEC ~= first || 0xEE...0xEF ~= first {
                    guard index + 2 < bytes.count, 0x80...0xBF ~= bytes[index + 1], 0x80...0xBF ~= bytes[index + 2] else { return false }
                    index += 3
                } else if first == 0xED {
                    guard index + 2 < bytes.count, 0x80...0x9F ~= bytes[index + 1], 0x80...0xBF ~= bytes[index + 2] else { return false }
                    index += 3
                } else if first == 0xF0 {
                    guard index + 3 < bytes.count, 0x90...0xBF ~= bytes[index + 1], 0x80...0xBF ~= bytes[index + 2], 0x80...0xBF ~= bytes[index + 3] else { return false }
                    index += 4
                } else if 0xF1...0xF3 ~= first {
                    guard index + 3 < bytes.count, 0x80...0xBF ~= bytes[index + 1], 0x80...0xBF ~= bytes[index + 2], 0x80...0xBF ~= bytes[index + 3] else { return false }
                    index += 4
                } else if first == 0xF4 {
                    guard index + 3 < bytes.count, 0x80...0x8F ~= bytes[index + 1], 0x80...0xBF ~= bytes[index + 2], 0x80...0xBF ~= bytes[index + 3] else { return false }
                    index += 4
                } else {
                    return false
                }
            }
            return true
        }

        private static func hex(_ byte: UInt8) -> UInt8? {
            switch byte {
            case 48...57: return byte - 48
            case 65...70: return byte - 55
            case 97...102: return byte - 87
            default: return nil
            }
        }
    }
}
