# ANF Code Test

iOS app that displays explore cards fetched from a remote JSON endpoint.

## What It Does

- Loads explore cards from a remote URL
- Displays images, titles, descriptions, and buttons
- Images load asynchronously with caching
- Handles errors gracefully

## Architecture

MVVM pattern:
- Model: `ExploreCard.swift` - data structures
- ViewModel: `ExploreCardViewModel.swift` - business logic
- View: `ANFExploreCardTableViewController.swift` + `ExploreCardCell.swift` - UI

## How to Run

1. Open `ANF Code Test.xcodeproj` in Xcode
2. Hit Cmd+R to build and run
3. App fetches data from: `https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css`

## Project Structure

```
Model/
  ExploreCard.swift

ViewModel/
  ExploreCardViewModel.swift
  NetworkService.swift

View/
  ANFExploreCardTableViewController.swift
  ExploreCardCell.swift
```

## Key Features

### NetworkService
- Handles API calls and image caching
- Uses async/await for networking
- Caches images with NSCache to avoid re-downloading

### ExploreCardCell
- Custom UITableViewCell with programmatic Auto Layout
- Handles cell reuse properly (images don't mix up)
- Shows loading spinner while images load
- Strips HTML from descriptions

### ExploreCardViewModel
- Manages state (loading, data, errors)
- Uses delegate pattern to notify view controller
- Dependency injection ready for testing

## Testing

Run tests with Cmd+U

Tests include:
- ViewController tests for table view
- ViewModel tests with mock network service
- Uses local JSON data (no network needed)

## Technologies

- Swift
- UIKit + Storyboard
- URLSession for networking
- XCTest for unit tests

## Things I Fixed

1. **Cell reuse issue**: Images appearing in wrong cells when scrolling
   - Added tracking of which card is displayed
   - Clear cell state in `prepareForReuse()`

2. **Auto Layout warnings**: Constraint conflicts
   - Set priority on initial height constraint
   - Deactivate old constraint before creating new one

3. **Async loading**: Refactored from completion handlers to async/await
   - Much cleaner code
   - Better error handling

4. **Memory management**: Used weak references to prevent retain cycles

## Requirements

- iOS 13.0+
- Xcode 14.0+

## Author

Irfan Mohammed
