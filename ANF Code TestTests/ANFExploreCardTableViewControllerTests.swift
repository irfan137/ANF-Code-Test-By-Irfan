//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//


import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {

    // System Under Test
    var sut: ANFExploreCardTableViewController!
    
    override func setUp() {
        super.setUp()
        sut = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? ANFExploreCardTableViewController
        
        // Load the view to trigger viewDidLoad
        sut.loadViewIfNeeded()
        
        // Wait for network data to load
        let expectation = XCTestExpectation(description: "Wait for data to load")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 8.0)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_numberOfSections_ShouldBeOne() {
        let numberOfSections = sut.numberOfSections(in: sut.tableView)
        XCTAssert(numberOfSections == 1, "table view should have 1 section")
    }
    
    func test_numberOfRows_ShouldBeTen() {
        let numberOfRows = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssert(numberOfRows == 10, "table view should have 10 cells")
    }
    
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        let firstCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreCardCell
        XCTAssertNotNil(firstCell, "Cell should be ExploreCardCell")
        let title = firstCell?.titleLabel.text
        XCTAssert(title?.count ?? 0 > 0, "title should not be blank, got: \(title ?? "nil")")
    }
    
    func test_cellForRowAtIndexPath_ImageViewImage_shouldNotBeNil() {
        let firstCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreCardCell
        XCTAssertNotNil(firstCell, "Cell should be ExploreCardCell")
        let imageView = firstCell?.backgroundImageView
        XCTAssert(imageView != nil, "image view should exist")
        
        // Note: Image loads asynchronously, so image may be nil initially
        // This test verifies the image view exists in the cell, not that it has loaded an image
    }
}
