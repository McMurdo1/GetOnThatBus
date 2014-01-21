//
//  DetailViewController.m
//  GetOnThatBus
//
//  Created by Matthew Graham on 1/21/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    
    __weak IBOutlet UILabel *busStopName;
}

@end

@implementation DetailViewController

@synthesize name;


- (void)viewDidLoad
{
    [super viewDidLoad];
    busStopName.text = name;
    NSLog(@"New View Loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
