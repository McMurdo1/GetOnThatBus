//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Matthew Graham on 1/21/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailViewController.h"

@interface ViewController () <MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *busStopMapView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getBusStopLocationData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Hard code default location
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.908556, -87.649725);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    [busStopMapView setRegion:region animated:YES];
    
    
    
    //busStopMapView.showsUserLocation = YES;
    
}

-(void)getBusStopLocationData
{
    NSURL *busStopMapJSONURL = [NSURL URLWithString:@"http://dev.mobilemakers.co/lib/bus.json"];
    NSURLRequest *busStopMapURLRequest = [NSURLRequest requestWithURL:busStopMapJSONURL];
    
    [NSURLConnection sendAsynchronousRequest:busStopMapURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSArray *stops = [json objectForKey:@"row"];

        for (NSDictionary *stop in stops)
        {
            NSString *lat = [stop objectForKey:@"latitude"];
            NSString *lon = [stop objectForKey:@"longitude"];
            NSString *name = [stop objectForKey:@"cta_stop_name"];
            NSString *route = [stop objectForKey:@"routes"];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);

            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.title = name;
            annotation.subtitle = route;
            annotation.coordinate = coordinate;
            
            [busStopMapView addAnnotation:annotation];
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    MKAnnotationView *busStopAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"busStopAnnotation"];
    if (busStopAnnotationView == nil)
    {
        busStopAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"busStopAnnotation"];
    }
    else
    {
        busStopAnnotationView.annotation = annotation;
    }
    busStopAnnotationView.canShowCallout = YES;
    busStopAnnotationView.draggable = NO;
    busStopAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    return busStopAnnotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"The annotation was selected");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DetailViewController *detailVC = (DetailViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewControllerStoryboardID"];
    detailVC.name = view.annotation.title;
    
    
    //[detailVC setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:detailVC animated:YES completion:nil];
    
    
    
    
    
}

@end
