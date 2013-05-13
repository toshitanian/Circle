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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setDelegate:self];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    [audioSession setActive:YES error:nil];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
    NSURL *file = [[NSURL alloc] initFileURLWithPath:soundPath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    player.delegate=self;
    [player prepareToPlay];
    
    // サウンドの再生。
    [player play];
    
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
