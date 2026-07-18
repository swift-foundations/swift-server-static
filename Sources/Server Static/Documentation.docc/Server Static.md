# ``Server/Static``

Resolve static-resource and DocC archive requests for a server engine.

## Archive profile

The default ``Server/Static/Archive/Profile/docC`` profile recognizes the root index, documentation and tutorial indexes, `data/documentation.json`, and the configured asset prefix. ``Server/Static/Policy`` returns a typed ``Server/Static/Outcome`` so a server engine can choose its own file reader and response type.

The policy does not access the filesystem or prescribe an HTTP framework.
