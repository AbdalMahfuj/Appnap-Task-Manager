


# Task Management App


### IDE: XCode 15.1
### Language: Swift
### UI Framework: UIKit
### Architecture: MVVM
### Minimum OS: iOS 15.0
### Local Database: CoreData
### Remote Server: https://crudcrud.com/
### Unit Test Framewrok: Apple's XCTest Framework
### Third party libraries: 
* IQKeyboardManager for Keyboard Done, cancel button to hide keyboard
* NVActivityIndicatorView for Showing loader



# App's Overview:
* App contains only three screens.
* In first screen user sees list tasks s/he created.
* On tap of any task, user navigate to task details screen, where s/he can update or delete the task.
* From the first/home screen, user can navigate to new task screen. Where task will be created by user’s given information.
* The task contains 5 different info. Title, Description, Task Status, Created-Date, Updated-Date & Due-Date.
* Based on due date task list will be sorted and will show accordingly in list view.
* All the task created store onto local Db and let know the remote server about the local changes by sync mechanism.


# How Sync works:
* For storing data locally Core Data used. 
* Any changes made, store that in local DB.
* For syncing data, I used crudcrud.com. 
* After saving changes to local DB, changes also push to remote.
* For any changes made, app try to push the changes to the remote immediately. Retry happens after 5 seconds.
* App fetches all remote data and save to local DB. It happens only once in app's full life cycle.
