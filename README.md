# Covid19AreaTracker
----

This app detects the current area in Bavaria where you are currently located and find the out the number of Covid-19 cases per 100k. According to the number, criticality of level is detected and then the guidelines for that level is shown. 

----

#### Prerequisite

This app need GeoFeatues module to detect whether the current location lies between given coordinates of a region . So, this module need to be install via CocoaPods.

To install the CocoaPod run following command on the terminal.
- cd  $PROJECT_DIR
- pod init
- open pod file in any text editor and add `pod "GeoFeatures`
- pod install

Open `Covid19AreaTracker.xcworkspace` to build and install the app.

#### Nomenclature

1. Guideline - This is the information which will be shown to the user. We have sementically three types of guidelines: Public gathering guidelines, Private gathering guidelines, and Mask guidelines.
2. Phase : This is object which will contains the list of guidelines and the color coding. Currenty we have 4 phases, but we can add as many as we want without changing the client. 
3. Area: This object will contains the coordinates in the form of JSON string, against which current location will be searched. Every Area has a unique ID, and number of covid-19 cases in that area.
4. Phase level: This is criticality level of any phase. This wiil be managed by the Phase Manager.
5. Phase Manager: This manager will give the list of all phases, current phases and current phase level. Depending upon the phase level, current phase will be set. This manager also keeps track the whether the phase has been changed or not from the previous state.
6. Phase Level Detector: This struct detect the phase level depending upon any strategy. Currently CaseStrategy has been used which tells the phase level depending upon the number of covid-19 cases.
7. AreaManager: This manager would be responsible for dowloading the geojson file which is further parsed to look for particular area and number of cases in that area. When the number of cases are found or any error occurer, it tells its delegate `CovidCasesMonitoringDelegate` about it. 
8. BackdroundFetchService: This is a download service which also runs in the backgroud. This service tells its delegate about whenever the download is complete with success or any error. This service also moved the downloaded content from temp location to the Documents folder with name Data.geojson.
9. GFRegionDetector: This detector is type of `IRegionDetector` which locates the given location in given coordinates. Thus detector used GeoFeature module to find out the locatoin, but we can change to any other startegy to depending upon the `RegionDetectorType`.
10. RegionDetectorFactory: Creates the detector object depending upon the `RegionDetectorType`.
11. GeoDataParser: This parser parsed the downloaded data into the list of `Area`. This list is iterated to find the current location in this list.
12. LocationService: This service is responsible for tracking user's current location. After every time interval which in 10 minute by default, a notification is thrown about the location. This service will continue to work in background. When it doesn't have the right permissions, then it will ask to open Settings to provide the required access.
13. LocalNotifService: This service is responsible request for local notification to be thrown when the phase is changed.
14. Alertable: Objects who adhere this protocol has the capability to throw the alrert if needed, they only need to be provide the default action and title for a single button alert. Otherwise, cancel title and action can be provided. 
15. Guidelines View Controller: This is the main view controller which show the current phase and the guidelines for that phase.
16. GuidelinesTableViewCell: This table cell is reponsible for showing guidelines for a phase.
17. GuidelinesIndicatorCollectionViewCell: This collection view cell is repsonsible for the current phase and its color. 

#### Working
On launch, permission for location and local notification would be prompted. Select the location access to `While using app`. If this permission would not be selected then app will be ask you  to set it from Settings by redirectiing to it. This wont be true for local notification as it considered option here. 

Once the app has right access, `LocationService` will start observing the location and will keep getting the location information from its location manager delegate, which is `self` in this case.  `LocationService`  also track the start date so that it can compare it with next location date, and when the time interval between these dates exceed 10 minute then a notification `LocationDidReceived` will be thrown about locaiton result.The `Result` could location on success or error on failure.

The area manager which is observer of `LocationDidReceived` will start fetching data from `geoData` url path using the `BackdroundFetchService`. This service will start downloading the data and informs its delegate which is `AreaManager` is this case about the completion of download with failure or success. `BackdroundFetchService` won't stop immidiate when there is no internet, instead it waits for the internet connection to resume downloading. When this service completes the download, then it moves the file to the permanent Documents folder. And on success, the path of downloaded file is passed to its delegate, `AreaManager`, otherwise error.

When `AreaManager` receives the file path, then the `GeoDataParser` parses the JSON data to find out Object ID, Cases and Coordinates. With these information an `Area` is created and added to the `Array of Area`. When the parsing is completed, then its completion handler is called, where list of Area is traversed and searched against the location which is set by the notification `LocationDidReceived`. The `IRegionDetector` detects whether the user's location is in the given area or not. When location found, then the `AreaManager` tells its delegate about the number of cases in recently found area, otherwise error. 

The delegate of  `AreaManager` which is `GuidelinesViewController` get informed by number of cases.  Depending upon the number of cases, `CaseStrategy` which is a `IPhaseLevelDetector` detects the criticality level. When level is known, then the phase level of `PhaseManager` is set. So does, the current phase of type `IPhase`. If the current phase is changed, then the `localNotifService` requests `UNUserNotificationCenter` to throw the notification. 

When the phase is detected then `GuidelinesViewController` reloads its `TableView` and `CollectionView` to show the latest data. Depending upon the phase the `TableViewCell` shows the `Guidelines`, and the `CollectionViewCell` shows the color for current phase. On error, an `Alert` is thrown with error description.

#### Localization
Localized strings are in Localizable.string. In order to support new language do following changes:
1. Select Project.
2. In editor window, select the project and select Info tab.
3. Under Localization, Add a new language.
4. Once added, new localization strings file will be created for the same lproj folder.


#### Extra feature
This app also support the dark mode.
