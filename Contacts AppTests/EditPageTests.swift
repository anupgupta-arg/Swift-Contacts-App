//
//  EditPageTests.swift
//  Contacts AppTests
//
//  Created by Anup Gupta on 02/09/19.
//  Copyright © 2019 geekguns. All rights reserved.
//

import XCTest
@testable import Contacts_App

class EditPageTests: XCTestCase {

    var editContactDeatils : EditContactDeatilsVC!
    
    
    override func setUp() {
         super.setUp()
//        editContactDeatils.firstNameTextField.text = "Anup";
//        editContactDeatils.lastNameTextField.text = "Gupta";
//        editContactDeatils.mobileNumberTextField.text = "6787878yuu";
//        editContactDeatils.emailTextField.text = "anup@gmail.com";
        
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        //editContactDeatils = nil;
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAllTextField()  {
        
       // XCTAssertTrue()
        
    }
    
    
    
    func test_title_is_Podcaster() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "EditContactDeatilsVCID") as! EditContactDeatilsVC
        let _ = editScreen.view
        XCTAssertEqual("", editScreen.firstNameTextField.text)
        XCTAssertEqual("", editScreen.lastNameTextField.text)
        XCTAssertEqual("", editScreen.mobileNumberTextField.text)
        XCTAssertEqual("", editScreen.emailTextField.text)
    }

}
