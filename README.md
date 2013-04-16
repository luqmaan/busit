Bus it!
================


An iOS application for the HART bus. Started at the 2013 Hillsborough County Hackathon: http://hackhillsborough.com.


API Documentation
--

- https://github.com/CUTR-at-USF/onebusaway-application-modules/wiki/Tampa---Third-Party-App-Interfaces
- http://developer.onebusaway.org/modules/onebusaway-application-modules/current/api/where/index.html

API's Used:

Interaction with the API is handled by BusStopREST.m. All requests must be passed the parameter `key`. The JSON response snippets below are truncated (and inaccurate) for readability.


- `agencies` - http://onebusaway.forest.usf.edu/api/api/where/agencies-with-coverage.json

	```
	{
	  "currentTime": 1366135596274,
	  "text": "OK",
	  "data": {
	      "limitExceeded": false,
	      "references": {
	          "stops": [],
	          "situations": [],
	          "trips": [],
	          "routes": [],
	          "agencies": [{
	                  "id": "Hillsbo	                  rough Area Regional Transit",
	                  "privateService": false,
	                  "phone": "813-254-4278",
	                  "timezone": "America/New_York",
	                  "disclaimer": "",
	                  "name": "Hillsborough Area Regional Transit",
	                  "lang": "en",
	                  "url": "http://www.gohart.org"
	              }
	          ]
	      },
	      "list": [{
	              "lonSpan": 0.576357999999999,
	              "lon": -82.445851,
	              "agencyId": "Hillsborough Area Regional Transit",
	              "lat": 27.976910500000002,
	              "latSpan": 0.5424609999999994
	          }
	      ]
	  },
	  "code": 200,
	  "version": 2
	}
	```

- `agency` - http://onebusaway.forest.usf.edu/api/api/where/routes-for-agency/Hillsborough%20Area%20Regional%20Transit.json

	```
	 {
	     "currentTime": 1366136001242,
	     "text": "OK",
	     "data": {
	         "references": {
	             "stops": [],
	             "situations": [],
	             "trips": [],
	             "routes": [],
	             "agencies": []
	         },
	         "entry": {
	             "privateService": false,
	             "id": "Hillsborough Area Regional Transit",
	             "timezone": "America/New_York",
	             "phone": "813-254-4278",
	             "disclaimer": "",
	             "name": "Hillsborough Area Regional Transit",
	             "lang": "en",
	             "url": "http://www.gohart.org"
	         }
	     },
	     "code": 200,
	     "version": 2
	 }
	```

- `routesForAgency` - http://onebusaway.forest.usf.edu/api/api/where/routes-for-agency/Hillsborough%20Area%20Regional%20Transit.json

	``` 
	{
	 "currentTime": 1366135818383,
	 "text": "OK",
	 "data": {
	     "limitExceeded": false,
	     "references": {
	         "stops": [],
	         "situations": [],
	         "trips": [],
	         "routes": [],
	         "agencies": [{
	                 "id": "Hillsborough Area Regional Transit",
	                 "privateService": false,
	                 "phone": "813-254-4278",
	                 "timezone": "America/New_York",
	                 "disclaimer": "",
	                 "name": "Hillsborough Area Regional Transit",
	                 "lang": "en",
	                 "url": "http://www.gohart.org"
	             }
	         ]
	     },
	     "list": [{
	             "id": "Hillsborough Area Regional Transit_96",
	             "textColor": "FFFFFF",
	             "color": "3C2D90",
	             "description": "",
	             "longName": "In-Town Trolley Purple Line",
	             "shortName": "96",
	             "type": 3,
	             "agencyId": "Hillsborough Area Regional Transit",
	             "url": "http://www.gohart.org/routes/trolley/96.html"
	         }, {
	             "id": "Hillsborough Area Regional Transit_45",
	             "textColor": "FFFFFF",
	             "color": "09346D",
	             "description": "",
	             "longName": "Uatc - Rome - Westshore Plaza",
	             "shortName": "45",
	             "type": 3,
	             "agencyId": "Hillsborough Area Regional Transit",
	             "url": "http://www.gohart.org/routes/hart/45.html"
	         },
	     ]
	 },
	 "code": 200,
	 "version": 2
	}
	```

- `stopsForRoute` - http://onebusaway.forest.usf.edu/api/api/where/stops-for-route/%@.json 
	
	The Route ID is passed as an escaped file name: e.g. http://onebusaway.forest.usf.edu/api/api/where/routes-for-agency/Hillsborough%20Area%20Regional%20Transit_1.json

	```
	{
	    "currentTime": 1366136548539,
	    "text": "OK",
	    "data": {
	        "references": {
	            "stops": [{
	                    "id": "Hillsborough Area Regional Transit_3077",
	                    "lon": -82.432328,
	                    "direction": "W",
	                    "locationType": 0,
	                    "name": "131St Av @ 23Rd St",
	                    "wheelchairBoarding": "UNKNOWN",
	                    "routeIds": [
	                            "Hillsborough Area Regional Transit_1",
	                            "Hillsborough Area Regional Transit_9",
	                            "Hillsborough Area Regional Transit_12",
	                            "Hillsborough Area Regional Transit_45"
	                    ],
	                    "code": "3077",
	                    "lat": 28.065554
	                }, {
	                    "id": "Hillsborough Area Regional Transit_3267",
	                    "lon": -82.43491,
	                    "direction": "E",
	                    "locationType": 0,
	                    "name": "Bearss Av @ 22nd St",
	                    "wheelchairBoarding": "UNKNOWN",
	                    "routeIds": [
	                            "Hillsborough Area Regional Transit_1"
	                    ],
	                    "code": "3267",
	                    "lat": 28.080264
	                }],
	            "agencies": [{
	                "id": "Hillsborough Area Regional Transit",
	                "privateService": false,
	                "phone": "813-254-4278",
	                "timezone": "America/New_York",
	                "disclaimer": "",
	                "name": "Hillsborough Area Regional Transit",
	                "lang": "en",
	                "url": "http://www.gohart.org"
	            }},
	            "entry": {
	                "routeId": "Hillsborough Area Regional Transit_1",
	                "stopIds": [
	                        "Hillsborough Area Regional Transit_3077",
	                        "Hillsborough Area Regional Transit_3267",
	                        "Hillsborough Area Regional Transit_3443",
	                        "Hillsborough Area Regional Transit_3444",
	                        "Hillsborough Area Regional Transit_3457",
	                ],
	                "stopGroupings": [{
	                        "ordered": true,
	                        "stopGroups": [{
	                                "id": "0",
	                                "name": {
	                                    "names": [
	                                            "North to University Area TC"
	                                    ],
	                                    "name": "North to University Area TC",
	                                    "type": "destination"
	                                },
	                                "subGroups": [],
	                                "stopIds": [
	                                        "Hillsborough Area Regional Transit_6968",
	                                        "Hillsborough Area Regional Transit_4244",
	                                        "Hillsborough Area Regional Transit_4021",
	                                        "Hillsborough Area Regional Transit_551",
	                                        "Hillsborough Area Regional Transit_553",
	                                        "Hillsborough Area Regional Transit_554"
	                                ],
	                                "polylines": [{
	                                        "levels": "",
	                                        "length": 141,
	                                        "points": "czriDdfhvNcEDuABgB?a@?M?G?eCAwE?cFhCmDA{D?wDAG?sD?sD?yDA}DCcA?mB@kA@mAC]?mD@cB@aEAyCAwDAmA?e@?Y?wCA{@?uB@mA?}B?c@@aC?gECaD@a@AcBA}A?kC@eA?}C?u@?iA@G?I?{A?q@?S?aCAm@?cB?sA@y@?aC@_D?Q?_CAw@?yAAsC?kC@_E?eACgBA_A@yA@yC?s@?gBAwC@mB?oD@O?gD?]AM@kCBkDEyD@uD@aE?qD?S?iD@qD?aD@_D@aD@cD?qA?eB?oA?Q?kB@]?gA@cA?k@@mA@Y?iB?cJ?{DAwD?gD?eE?}B@cA?I?aD?yCCu@?iB@cD?uB?eD?gB?e@AaE@sJ@_@Mw@?q@AmCAsAAq@?gC?@gC@{CByCeE?@q@mD}@Aq@pDt@Ax@"
	                                    }, {
	                                        "levels": "",
	                                        "length": 177,
	                                        "points": "mlajDj|gvN?vCAzCCfCyDAiB?uA?aI?_@?]?M?G?o@?oC?gE?qKCkH@mC@}CC_@AiEBq@?kD?eA?iDESLS?aA?kH?oJAkFAmG?kFAeP@cD?C?uAAgEA_C?gIA}B?gDAkA@[?aC?i@?e@?}@?}@?s@?o@?g@?cHA[?kA?gA?}B?W?qFAkIDuB?I??QBsT?qB?m@@o@?S?W?k@?[?gB?s@?_@@cI?qA?O?MI?{A?i@?iC@_A?uB@y@?kA?oC@yA@Q?C?q@?O@q@?yA?[?k@?yA?k@?_A@sA?q@@g@?mB@mGByHHi@?AiF?K?K@kIAuG?_A?wC?gB?_B?oB?m@?O[_CIKc@e@_@sBb@kA^oANo@Js@Hu@B]H_BBkC@cC?wDAkGpBiKfEM^AdCCl@ApCEzAE`AAr@?l@?`A?j@?hD@vC?vB?P?|G@tDDbB?xC?J?tDAtD@T?|C?~D?AmE?kE?uAAqB?}E?iEkFz@T?d@@p@?h@??AFFDJ?TGHEDg@@"
	                                    }
	                                ]
	                            },
	                        }]
	                }
	            },
	            "code": 200,
	            "version": 2
	        }
	    }
	}
	```

- `scheduleForStop` - http://onebusaway.forest.usf.edu/api/api/where/schedule-for-stop/%@.json

	Stop ID is passed as the file name. Example for Hillsborough Area Regional Transit_3077 - http://onebusaway.forest.usf.edu/api/api/where/schedule-for-stop/Hillsborough%20Area%20Regional%20Transit_3077.json
	
	```
	{
	"currentTime": 1366137588336,
	"text": "OK",
	"data": {
	"references": {
	   "stops": [{
	           "id": "Hillsborough Area Regional Transit_3077",
	           "lon": -82.432328,
	           "direction": "W",
	           "locationType": 0,
	           "name": "131St Av @ 23Rd St",
	           "wheelchairBoarding": "UNKNOWN",
	           "routeIds": [
	                   "Hillsborough Area Regional Transit_1",
	                   "Hillsborough Area Regional Transit_9",
	                   "Hillsborough Area Regional Transit_12",
	                   "Hillsborough Area Regional Transit_45"
	           ],
	           "code": "3077",
	           "lat": 28.065554
	       }
	   ],
	   "situations": [],
	   "trips": [],
	   "routes": [{
	           "id": "Hillsborough Area Regional Transit_1",
	           "textColor": "FFFFFF",
	           "color": "09346D",
	           "description": "",
	           "longName": "Florida Avenue",
	           "shortName": "1",
	           "type": 3,
	           "agencyId": "Hillsborough Area Regional Transit",
	           "url": "http://www.gohart.org/routes/hart/01.html"
	       }, {
	           "id": "Hillsborough Area Regional Transit_9",
	           "textColor": "FFFFFF",
	           "color": "09346D",
	           "description": "",
	           "longName": "15th Street",
	           "shortName": "9",
	           "type": 3,
	           "agencyId": "Hillsborough Area Regional Transit",
	           "url": "http://www.gohart.org/routes/hart/09.html"
	       },
	   ],
	   "agencies": [{
	           "id": "Hillsborough Area Regional Transit",
	           "privateService": false,
	           "phone": "813-254-4278",
	           "timezone": "America/New_York",
	           "disclaimer": "",
	           "name": "Hillsborough Area Regional Transit",
	           "lang": "en",
	           "url": "http://www.gohart.org"
	       }
	   ]
	},
	"entry": {
	   "stopId": "Hillsborough Area Regional Transit_3077",
	   "stopRouteSchedules": [{
	           "stopRouteDirectionSchedules": [{
	                   "scheduleStopTimes": [{
	                           "departureEnabled": true,
	                           "stopHeadsign": "",
	                           "arrivalTime": 1366100158000,
	                           "serviceId": "Hillsborough Area Regional Transit_We",
	                           "tripId": "Hillsborough Area Regional Transit_901271",
	                           "departureTime": 1366100158000,
	                           "arrivalEnabled": true
	                       }, {
	                           "departureEnabled": true,
	                           "stopHeadsign": "",
	                           "arrivalTime": 1366101358000,
	                           "serviceId": "Hillsborough Area Regional Transit_We",
	                           "tripId": "Hillsborough Area Regional Transit_901272",
	                           "departureTime": 1366101358000,
	                           "arrivalEnabled": true
	                       },
	                   ],
	                   "tripHeadsign": "South to Downtown/MTC",
	                   "scheduleFrequencies": []
	               }
	           ],
	           "routeId": "Hillsborough Area Regional Transit_1"
	       }
      "code": 200,
      "version": 2
	  }
	}
	```

Real-Time Vehicle Positions
--

https://github.com/CUTR-at-USF/onebusaway-application-modules/wiki/Tampa---Third-Party-App-Interfaces#gtfs-realtime-feed

- Trip Updates Feed http://onebusaway.forest.usf.edu:8088/trip-updates?debug
- Vehicle Positions Feed http://onebusaway.forest.usf.edu:8088/vehicle-positions?debug

![](https://github.com/CUTR-at-USF/HART-GTFS-realtimeGenerator/wiki/HART_OrbCAD_GTFS-realtime_architecture.png)


