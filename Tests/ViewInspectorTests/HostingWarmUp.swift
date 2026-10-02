import XCTest
import SwiftUI
@testable import ViewInspector

/// The first view hosted in a test process takes far longer to render (up to several
/// seconds on a CI simulator) while the UI frameworks load. Tests with tight timeouts
/// on hosted views call this from `class func setUp()` to absorb that cost up front.
@MainActor
@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
enum HostingWarmUp {

    private static var isDone = false

    static func perform(timeout: TimeInterval = 10) {
        guard !isDone else { return }
        isDone = true
        var didAppear = false
        ViewHosting.host(view: Text("Warm-up").onAppear { didAppear = true })
        defer { ViewHosting.expel() }
        let deadline = Date().addingTimeInterval(timeout)
        while !didAppear && Date() < deadline {
            RunLoop.main.run(until: Date().addingTimeInterval(0.01))
        }
    }
}
