//
//  ImageGridTests.swift
//  ImageGridTests
//
//  Created by Michele Fadda on 05/06/2020.
//

import XCTest
@testable import ImageGrid

class ImageGridTests: XCTestCase {

    func testCollectionViewControllerIsInitial() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        XCTAssertTrue(storyboard.instantiateInitialViewController() is CollectionViewController)
    }
    
    func testCollectionViewControllerStoryBoardNameGridView() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView")
        XCTAssertTrue(storyboard.instantiateInitialViewController() is CollectionViewController)
    }

    func testCollectionViewControllerHasCollectionView() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        let cv = vc.collectionView
        XCTAssertNotNil(cv)
    }

    func testCollectionViewHasFlowLayout() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        XCTAssert(vc.collectionView.collectionViewLayout is UICollectionViewFlowLayout)
        
    }

    func testCollectionViewHasOneSection() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        let cv = vc.collectionView
        let sections = cv?.numberOfSections
        XCTAssert(sections == 1)
    }
    
    func testCollectionViewHasDatasource() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        let cv = vc.collectionView
        XCTAssertNotNil(cv?.dataSource)
    }

    func testCollectionViewHasDelegate() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        let cv = vc.collectionView
        XCTAssertNotNil(cv?.delegate)
    }

    func testCollectionViewBackgroundColorIsSystem() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        let cv = vc.collectionView
        let color = cv?.backgroundColor
        XCTAssert(color == UIColor.systemBackground)
    }
    
    func testCollectionViewNoMultipleSelection() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "GridView") as CollectionViewController
        let cv = vc.collectionView
        XCTAssert(cv?.allowsMultipleSelection == false)
    }

}
