//
//  MaMapViewController.h
//  MoreMusic
//
//  Created by Accthun He on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MaMapViewController : UIViewController<MKMapViewDelegate>
{
    MKMapView * _mapView;
}
@end
