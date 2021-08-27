import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SS58FactoryTests.allTests),
    ]
}
#endif
