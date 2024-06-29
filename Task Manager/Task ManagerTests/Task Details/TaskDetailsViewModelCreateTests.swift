//
//  TaskDetailsViewModelCreateTests.swift
//  Task ManagerTests
//
//  Created by Mahfuz on 28/6/24.
//

import XCTest
@testable import Task_Manager

final class TaskDetailsViewModelCreateTests: XCTestCase {

    private var sut: TaskDetailsViewModel!
    private var service: TaskDBServiceMock!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = TaskDBServiceMock()
        sut = TaskDetailsViewModel(service: service, task: nil)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        try super.tearDownWithError()
    }

    func test_TaskDetails_With_No_DB_Data() throws {
        service.mockObjectFile = nil
        
        XCTAssertEqual(self.sut.task, nil, "Should be nil")
        XCTAssertEqual(self.service.tasks.count, 0, "DB should not have any item")

    }
    
    func test_TaskDetails_With_DB_Data() throws {
        service.mockObjectFile = "Tasks"
        
        XCTAssertEqual(self.sut.task, nil, "Should be nil")
        XCTAssertEqual(self.service.tasks.count, 3, "DB should have 3 items")
    }
    
    func test_TaskDetails_Delete_With_No_DB_Data() throws {
        service.mockObjectFile = nil
        
        sut.deleteTask()
        
        XCTAssertEqual(self.service.tasks.count, 0, "DB should not have any items")
    }
    
    func test_TaskDetails_Delete_With_DB_Data() throws {
        service.mockObjectFile = "Tasks"
        
        sut.deleteTask()
        
        XCTAssertEqual(self.service.tasks.count, 3, "DB should have 3 items")
    }
    
    func test_TaskDetails_Create_With_No_DB_Data() throws {
        service.mockObjectFile = nil
        
        sut.createOrUpdateTask(title: "Test Title", detail: "Test Details", dueDate: Date(), status: 0)
        
        XCTAssertEqual(self.service.tasks.count, 1, "DB should have 1 item")
    }
    
    func test_TaskDetails_Create_With_DB_Data() throws {
        service.mockObjectFile = "Tasks"
        
        sut.createOrUpdateTask(title: "Test Title", detail: "Test Details", dueDate: Date(), status: 0)
        
        XCTAssertEqual(self.service.tasks.count, 4, "DB should have 4 items")
    }
    

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
