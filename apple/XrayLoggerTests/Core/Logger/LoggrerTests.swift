//
//  LoggrerTests.swift
//  xrayTests
//
//  Created by Anton Kononenko on 7/13/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

import XCTest
@testable import xray

class LoggrerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoggerCreation() throws {
        let testSubsystem = "com.logger/test"
        let testParentSubsystem = "com.logger"

        var logger = Logger(subsystem: testSubsystem,
                            parent: nil)

        XCTAssertTrue(logger.subsystem == testSubsystem)
        XCTAssertTrue(logger.children.count == 0)
        XCTAssertTrue(logger.context.count == 0)
        XCTAssertNotNil(logger.messageFormatter)
        XCTAssertNil(logger.parent)

        let parentLogger = Logger(subsystem: testParentSubsystem,
                                  parent: nil)
        logger = Logger(subsystem: testSubsystem,
                        parent: parentLogger)

        XCTAssertTrue(logger.subsystem == testSubsystem)
        XCTAssertNotNil(logger.parent)
        XCTAssertNil(logger.messageFormatter)
        XCTAssertTrue(parentLogger.children.count == 0)
    }

    func testCreateChildLogger() throws {
        let testSubsystem = "com.logger/test"
        let testParentSubsystem = "com.logger"

        let parentLogger = Logger(subsystem: testParentSubsystem,
                                  parent: nil)
        let logger = parentLogger.createChildLogger(subsystem: testSubsystem)
        XCTAssertNotNil(logger.parent)
        XCTAssertNotNil(parentLogger.messageFormatter)
        XCTAssertTrue(parentLogger.children.count == 1)
    }

    // test/logger
    func testChild() throws {
//        let rootLogger = Logger.getLogger(for: "")
//        var innerLogger = rootLogger?.child(for: "plugin/testPlugin/download/vod")
//
//        XCTAssertNotNil(innerLogger)
//        XCTAssertTrue(innerLogger?.children.count == 0)
//        XCTAssertNotNil(innerLogger?.parent)
//        XCTAssertTrue(innerLogger?.subsystem == "plugin/testPlugin/download/vod")
//        XCTAssertTrue(innerLogger?.parent?.subsystem == "plugin/testPlugin/download")
//        XCTAssertTrue(innerLogger?.parent?.parent?.subsystem == "plugin/testPlugin")
//        XCTAssertTrue(innerLogger?.parent?.parent?.parent?.subsystem == "plugin")
//        XCTAssertTrue(innerLogger?.parent?.parent?.parent?.parent?.subsystem == "")
//
//        innerLogger = rootLogger?.child(for: "plugin/testPlugin/download/vod")
//
//        XCTAssertNotNil(innerLogger)
//        XCTAssertTrue(innerLogger?.children.count == 0)
//        XCTAssertNotNil(innerLogger?.parent)
//        XCTAssertTrue(innerLogger?.subsystem == "plugin/testPlugin/download/vod")
//        XCTAssertTrue(innerLogger?.parent?.subsystem == "plugin/testPlugin/download")
//        XCTAssertTrue(innerLogger?.parent?.parent?.subsystem == "plugin/testPlugin")
//        XCTAssertTrue(innerLogger?.parent?.parent?.parent?.subsystem == "plugin")
//        XCTAssertTrue(innerLogger?.parent?.parent?.parent?.parent?.subsystem == "")
//
//        innerLogger = rootLogger?.child(for: "plugin/testPlugin/download/live")
//
//        XCTAssertNotNil(innerLogger)
//        XCTAssertTrue(innerLogger?.children.count == 0)
//        XCTAssertNotNil(innerLogger?.parent)
//        XCTAssertTrue(innerLogger?.subsystem == "plugin/testPlugin/download/live")
//        XCTAssertTrue(innerLogger?.parent?.subsystem == "plugin/testPlugin/download")
//        XCTAssertTrue(innerLogger?.parent?.parent?.subsystem == "plugin/testPlugin")
//        XCTAssertTrue(innerLogger?.parent?.parent?.parent?.subsystem == "plugin")
//        XCTAssertTrue(innerLogger?.parent?.parent?.parent?.parent?.subsystem == "")
//
//        innerLogger = rootLogger?.child(for: "oneLevel")
//        XCTAssertNotNil(innerLogger)
//        XCTAssertTrue(innerLogger?.children.count == 0)
//        XCTAssertNotNil(innerLogger?.parent)
//        XCTAssertTrue(innerLogger?.subsystem == "oneLevel")
//        XCTAssertTrue(innerLogger?.parent?.subsystem == "")
//
//        innerLogger = rootLogger?.child(for: "$a'#%a!-")
//        XCTAssertNotNil(innerLogger)
//        XCTAssertTrue(innerLogger?.children.count == 0)
//        XCTAssertTrue(innerLogger?.subsystem == "$a'#%a!-")
//        XCTAssertNotNil(innerLogger?.parent)
//
//        innerLogger = rootLogger?.child(for: "foo/$a'#%a!-")
//        XCTAssertNotNil(innerLogger)
//        XCTAssertTrue(innerLogger?.children.count == 0)
//        XCTAssertNotNil(innerLogger?.parent)
//        XCTAssertTrue(innerLogger?.subsystem == "foo/$a'#%a!-")
//        XCTAssertTrue(innerLogger?.parent?.subsystem == "foo")
//
        // TODO: Resolve such cases
        // Posible use regex: ^[^\/](?:[.\/](?![.\/\\\n])|[^<>:"|?*.\/\\\n])+[^\/]$
//        let foo = "/a/a".isSubsystemPathCorrupeted()
//        let foo = "/a/a/".isSubsystemPathCorrupeted()
//        let foo = "//a/a".isSubsystemPathCorrupeted()
//        let foo = "// /a".isSubsystemPathCorrupeted()
    }

    func testLoggerStuff() {
        XrayLogger.sharedInstance.addSink(identifier: "test",
                                          sink: Console(logType: .os_log))
        let rootLogger = Logger.getLogger(for: "com.test.anton")
        rootLogger?.logEvent(logLevel: .debug,
                             message: "TestMessage",
                             category: "category",
                             data: ["test": "Data"],
                             exception: nil, otherArgs: 1, 2, 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
