

Models
==

    Route
        metadata
        mutablearray of BMVehicles with the same routeId

    BMVehicle
        metadata
        position

    mapOptions
        NSMutableArray visibleRoutes
            NSDictionary {
                routeId
                shortName
                longName
            }


MapViewController
==

    NSString* agencyId
    NSDictionary* vehiclesForAgency
    NSArray* routes
    NSMutableArray* mapOptions

    init
        set the agencyId
        set up the map
        fetchVehicleData
        sets up routes array
        for each route enabled
            showRoute

    fetchVehicleData
        ask the API for the vehicles-for-agency
        update the vehiclesForAgency var
        if routes is empty
            use the routes list in data/references/routes
        if a vehicle does not have trip data, discard it
        instantiate a vehicle object and add it to the Routes
        call updateMapViewAnnotations

    updateMapViewAnnotations
        for each route in mapOptions.visibleRoutes
            call showRoute

    showRoute(routeId)
        for each 

    hideRoute(routeId)

    annotationView
        present each vehicle as a circle with the route number + direction id
        is there a way to translate the direction id to be meaningful? (NS instead of 1 0)

    presentingSegue
        if segue.id == "mapOptionsView"
            segue.destinationViewController.delegate = self


    mapOptionsViewControllerDidFinish:(MapOptionsViewController *)mapOptionsViewContoller
        self.mapOptions = mapOptionsViewController


MapOptionsViewController
==

- concept: http://stackoverflow.com/q/8706281/854025
- implementation: http://stackoverflow.com/a/12975002/854025
- overview: http://stackoverflow.com/a/12660523/854025
- with segue: http://stackoverflow.com/questions/8533730/segue-delegate-and-protocol

_

    NSMutableArray* mapOptions

    
    initWithRoutes:(NSDictionary *)routeData
        for now: just enable routes 5 and 6
        ideal: presents a grid of the routes for the user to drag and enable/disable


    drag to enable

