import Foundation

extension TimeInterval {

    /// A timeout for waiting on expectations fulfilled by hosted views, multiplied by
    /// the `VIEWINSPECTOR_TEST_TIMEOUT_SCALE` environment variable (default `1`).
    ///
    /// Slow CI machines can set the variable to give hosted views more time to render
    /// without changing how the tests behave locally. When running through `xcodebuild`,
    /// pass it as `TEST_RUNNER_VIEWINSPECTOR_TEST_TIMEOUT_SCALE` so it reaches the test process.
    ///
    /// Don't use it for inverted expectations: their timeout is the observation window.
    static func scaled(_ seconds: TimeInterval) -> TimeInterval {
        return seconds * timeoutScale
    }

    private static let timeoutScale: TimeInterval = {
        let value = ProcessInfo.processInfo.environment["VIEWINSPECTOR_TEST_TIMEOUT_SCALE"]
        return max(1, value.flatMap { TimeInterval($0) } ?? 1)
    }()
}
