![](https://raw.githubusercontent.com/alinaveed9168/TheNewyorkTimes/master/NYTimes%20Screenshots/Banner.png)
![SwiftUI](https://img.shields.io/badge/Interface-SwfitUI-red)
![Architecture](https://img.shields.io/badge/Architecture-VIPER-green)

# TheNewyorkTimes

NY Times is an Minimal News 🗞 iOS application built to describe the use of **Combine** ,**VIPER** and **SwiftUI**.

## 📝 Table of Contents  
- [Requirements](#requirements)
- [Technical Background](#techbackground)
- [Project Structure](#projectstructure)
- [Contribute](#contribute)
- [License](#license)

<a name="requirements"/>

## ⚙️ Requirements
```
iOS 15+
Xcode 15 and Up
generate Api-key from https://developer.nytimes.com/
```
<a name="techbackground"/>

## 🛠 Technical Background
- NYTimes App was made using SwiftUI as the Core interface with Two Way Binding VIPER Architecture using Combine framework. 
- The User interface of this app mostly uses the inbuilt iOS components to keep the User experience close to the native feel.
- This project was built in the mindset of modularity and good coding patterns. Multiple design patterns like Dependency injection.

<a name="projectstructure"/>

## ⛓ Project Structure

## Project Structure

```text
NYTimes
├── ArticleList
│   ├── ArticleListContracts.swift
│   ├── ArticleListInteractor.swift
│   ├── ArticleListPresenter.swift
│   └── ArticleListRouter.swift
├── ArticleListModuleBuilder
│   └── ArticleListModuleBuilder.swift
├── EndPoint
│   ├── APIConstants.swift
│   ├── Endpoint.swift
│   └── NYTEndpoints.swift
├── Entities
│   ├── Article.swift
│   ├── Media.swift
│   ├── MediaMetadata.swift
│   └── MostViewedResponse.swift
├── Enum
│   └── APIError.swift
├── NetworkManager
│   ├── NetworkManager.swift
│   └── NYTArticlesRepository.swift
├── Support
│   ├── AppEnvironment.swift
│   └── SafariView.swift
├── Views
│   ├── ArticleListView.swift
│   ├── ArticleRowView.swift
│   ├── ArticleDetailView.swift
│   └── EmptyStateView.swift
├── Resources
│   └── Articles_stub.json
└── Supporting Files
    └── Info.plist

# Tests (separate targets)
NYTimesTests
├── APIErrorTests.swift
├── APIErrorURLSessionTests.swift
├── ArticleListInteractorTests.swift
└── ArticleListPresenterTests.swift

NYTimesTimesUITests
├── NYTimesTimesUITests.swift
└── NYTimesTimesUITestsLaunchTests.swift

## Architecture
    
This app uses VIPER architecture.

![VIPER](https://raw.githubusercontent.com/alinaveed9168/TheNewyorkTimes/master/NYTimes%20Screenshots/VIPER.png)


<a name="contribute"/>

## ✏️ Contribute

If you want to contribute to this library, you're always welcome!

### What you can do
You can contribute us by filing issues, bugs and PRs.

### Before you do
Before you open a issue or report a bug, please check if the issue or bug is related to Xcode or SwiftUI.

### Contributing guidelines:
- Open issue regarding proposed change.
- Repo owner will contact you there.
- If your proposed change is approved, Fork this repo and do changes.
- Open PR against latest `dev` branch. Add nice description in PR.
- You're done!

<a name="license"/>

## ⚖️ [License](https://github.com/alinaveed9168/TheNewyorkTimes/blob/master/LICENSE)

```
MIT License

Copyright (c) 2025 AliNaveed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
