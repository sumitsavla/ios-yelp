iOS App - Yelp Search
=========================

This is an iOS application for searching places based on keyword near San Francisco [Yelp Search API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: 25 hours spent in total

Completed user stories:

Search results page:
 * [x] Required: Table rows should be dynamic height according to the content height  
 * [x] Required: Custom cells should have the proper Auto Layout constraints
 * [x] Required: Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

Filter page:
 * [x] Required: The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
 * [x] Required: The filters table should be organized into sections as in the mock.
 * [x] Required: You can use the default UISwitch for on/off states. Optional: implement a custom switch
 * [x] Required: Radius filter should expand as in the real Yelp app
 * [x] Required: Categories should show a subset of the full list with a "See All" row to expand.
 * [x] Required: Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

Libraries used:
1. cocoapod
2. AFNetworking
3. MBProgressHUD

iOS features used:
1. Auto Layout
2. Resizable table view
3. Table view with sections
4. Protocol Delegate
5. Search Bar
6. Collapsible table view rows

Walkthrough of all the user stories:

![Video Walkthrough]()

GIF created with [LiceCap](http://www.cockos.com/licecap/).


