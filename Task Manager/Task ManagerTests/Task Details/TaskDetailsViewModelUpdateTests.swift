//
//  TaskDetailsViewModelUpdateTests.swift
//  Task ManagerTests
//
//  Created by Mahfuz on 28/6/24.
//

import XCTest
@testable import Task_Manager

final class TaskDetailsViewModelUpdateTests: XCTestCase {

    private var sut: TaskDetailsViewModel!
    private var service: TaskDBServiceMock!
    private var task: TaskModel!


    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = TaskDBServiceMock()
        task = TaskModel(id: "102030", title: "Test Title", details: "Test Details", dueDate: Date())
        sut = TaskDetailsViewModel(service: service, task: task)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        task = nil
        try super.tearDownWithError()
    }

    func test_TaskDetails_With_No_DB_Data() throws {
        service.mockObjectFile = nil
        
        XCTAssertEqual(self.sut.task != nil, true, "Should not be nil")
        XCTAssertEqual(self.service.tasks.count, 0, "DB should not have any item")

    }
    
    func test_TaskDetails_With_DB_Data() throws {
        service.mockObjectFile = "Tasks"
        
        XCTAssertEqual(self.sut.task != nil, true, "Should not be nil")
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
    
    func test_TaskDetails_Update_With_No_DB_Data() throws {
        service.mockObjectFile = nil
        
        sut.createOrUpdateTask(title: "Another Test Title", detail: "Another Test Details", dueDate: Date())
        
        XCTAssertEqual(self.service.tasks.count, 0, "DB should not have any item")
    }
    
    func test_TaskDetails_Update_With_DB_Data() throws {
        service.mockObjectFile = "Tasks"
        
        sut.createOrUpdateTask(title: "Test Title", detail: "Test Details", dueDate: Date())
        
        XCTAssertEqual(self.service.tasks.count, 3, "DB should have 3 items")
    }
    

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
