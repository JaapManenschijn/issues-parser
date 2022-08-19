[![iOS starter workflow](https://github.com/JaapManenschijn/issues-parser/actions/workflows/ios.yml/badge.svg)](https://github.com/JaapManenschijn/issues-parser/actions/workflows/ios.yml)

This repository contains all code for the technical assessment.  
Let's take a quick tour of the project.

## Modules
The workspace contains multiple modules that work together. 

### RaboIssueParser module
The app module. It's fairly empty as it simply makes use of the **IssuesUI** module.
All it does is define the app and load the Main View of the IssuesUI module.

### IssuesUI module
As indicated by the name, this is the UI module for the project. It contains all UI revolving around selecting a file and showing the contents of the file.  
There's a few views in there:  
- FileSelectionView - Offers the user the option to select one or multiple files
- FileListView - After getting the contents of the selected files, provides a list with the read results
- FileContentView - After selecting one of the selected files, this view is shown to the user and contains a paginating list with all the issues found in the file

The main views in this module adhere to the MVVM pattern and have a corresponding ViewModel.  
The ViewModels are mainly used for some business logic and providing the dynamic content to show in the view.  

The module also includes Unit tests for some ViewModels.

### CSVParser module
This module contains the logic for parsing the file data.  
To use it, simply instantiate a CSVParser:
`CSVParser(data:)` and request the users with `getUsers(limit:, offset:)`.

Internally, the `CSVParser` will choose which parser to use based on your iOS version:  
`IOS15Parser` for iOS15+ and `PreIOS15Parser` for iOS versions below 15.  
Reason for the difference is that on iOS15, Apple added out of the box support for parsing CSV files and it felt a little bit like cheating to only use that.

This module contains unit tests for the `CSVParser`.

### FileReader module
This module contains the logic for selecting files and retrieving the `Data` of the selected files. This is all exposed by offering the `FileReaderButton` view that can be used in SwiftUI views.  

The `FileReaderButton` view handles showing / hiding the `UIDocumentPicker` and passes the result to it's own ViewModel.  

The `FileReaderButtonViewModel` is responsible for reading the `Data` of the selected files. The module also includes the necessary unit tests for the ViewModel.

### Common module
The Common module contains some basic code that can be used throughout the other modules. It also contains the localized strings for the whole project and a way for other modules to properly get the localized text.

In addition to localization, it also provides some color information to be used by the other modules.

## Tests
As mentioned above, some of the modules contain unit tests. All unit tests are configured to be ran whenever the tests of the app module are being ran.

In addition to this, a Github Action has been set up to run the tests automatically whenever a PR is opened & whenever a commit has been done to the `main` branch.  
This action runs the test on an iOS 15.2 and an iOS 14.4 simulator to ensure both versions of the CSVParser are tested.




