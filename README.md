# JHDataUtils
Fetch, digest, and archive data from a web service.

**JHDataUtils**

`JHDataUtils` does the bulk of the heavy lifting with an assist from `AFNetworking`. Instances can queue new download operations and can suspend, resume, or cancel any that are pending. `JHDataUtils` also takes advantage of `AFNetworking`'s reachability tools and posts notifications if the app's reachability status changes.

**JHDownloadOperation**

Subclassing `AFHTTPRequestOperation`, `JHDownloadOperation` declares a protocol delegates can use to interact with the operation when it finishes its task.

**JHDataContainer**

A thin wrapper with a name, timestamp, and payload, a `JHDataContainer` object can be passed to `JHCache` to be stored on disk.

**JHCache**

`JHCache` contains a number of class methods for storing and managing data on disk with minimal overhead.
