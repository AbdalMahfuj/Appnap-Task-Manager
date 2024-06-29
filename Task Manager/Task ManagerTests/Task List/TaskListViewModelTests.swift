//
//  TaskListViewModelTests.swift
//  Task ManagerTests
//
//  Created by Mahfuz on 28/6/24.
//

import XCTest
@testable import Task_Manager

final class TaskListViewModelTests: XCTestCase {

    private var sut: TaskListViewModel!
    private var service: TaskDBServiceMock!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = TaskDBServiceMock()
        sut = TaskListViewModel(service: service)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        try super.tearDownWithError()
    }

    func test_TaskList_With_NoData() throws {
        service.mockObjectFile = nil
        sut.fetchTasks()
        
        XCTAssertEqual(self.sut.items.count, 0, "Should not have any task")
        XCTAssertEqual(self.sut.items.count, self.service.tasks.count, "DB & Model should have same number of items")

    }
    
    func test_TaskList_With_AllData() throws {
        service.mockObjectFile = "Tasks"
        sut.fetchTasks()
        
        XCTAssertEqual(self.sut.items.count, 3, "Should get exact 3 tasks")
        XCTAssertEqual(self.sut.items.count, self.service.tasks.count, "DB & Model should have same number of items")
    }
    
    func test_TaskList_With_First_Item_Delete() throws {
        service.mockObjectFile = "Tasks"
        sut.fetchTasks()
        sut.deleteTask(index: 0)
        
        XCTAssertEqual(self.sut.items.count, 2, "Should get exact 3 tasks")
        XCTAssertEqual(self.sut.items.count+1, self.service.tasks.count, "DB should have greater number of items")
    }
    
    func test_TaskList_With_InValid_Item_Delete() throws {
        service.mockObjectFile = "Tasks"
        sut.fetchTasks()
        sut.deleteTask(index: 5)
        
        XCTAssertEqual(self.sut.items.count, 3, "Should get exact 3 tasks")
        XCTAssertEqual(self.sut.items.count, self.service.tasks.count, "DB & Model should have same number of items")
    }
    
    func test_TaskList_With_First_Two_Items_Delete() throws {
        service.mockObjectFile = "Tasks"
        sut.fetchTasks()
        sut.deleteTask(index: 0)
        sut.deleteTask(index: 0)

        XCTAssertEqual(self.service.tasks[0].id, "102030", "This task with this ID should be exist")
        XCTAssertEqual(self.service.tasks.count, 3, "Should get exact 3 tasks")
        XCTAssertEqual(self.sut.items.count+2, self.service.tasks.count, "DB should have greater number of items")
    }
    
    func test_TaskList_With_All_Items_Delete() throws {
        service.mockObjectFile = "Tasks"
        sut.fetchTasks()
        sut.deleteTask(index: 0)
        sut.deleteTask(index: 0)
        sut.deleteTask(index: 0)

        XCTAssertEqual(self.sut.items.count, 0, "Should not have any task")
        XCTAssertEqual(self.sut.items.count+3, self.service.tasks.count, "DB should have greater number of items")
    }
    

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
