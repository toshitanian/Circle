//
//  CMInfoViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/7/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAppDelegate.h"


@interface CMInfoViewController ()

@end

@implementation CMInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.delegate CMInfoViewControllerDidFinishShowing:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
#pragma mark - something

-(IBAction)pop:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)showPlayer:(id)sender
{
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    ad.playerViewController.query=nil;
    [self presentViewController:ad.playerViewController animated:YES completion: nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
