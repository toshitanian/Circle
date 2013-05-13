//
//  CMSongViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMSongViewController.h"
#import "CMSpiralLayout.h"
#import "CMSpiralCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CMPlayerViewController.h"

#import "CMAppDelegate.h"


//http://hiromem.blogspot.jp/2012/07/ipod-libraryavaudioplayer.html

@interface CMSongViewController ()

@end

@implementation CMSongViewController

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
    
    ////collection/////////
    _cv=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320 , 400) collectionViewLayout:[[CMSpiralLayout alloc] init]];
    
    _cv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    _cv.showsHorizontalScrollIndicator = NO;
    _cv.showsVerticalScrollIndicator = NO;
    _cv.bounces=NO;
    [_cv registerClass:[CMSpiralCell class] forCellWithReuseIdentifier:@"CMSpiralCell"];
    _cv.delegate=self;
    _cv.dataSource=self;
    [self.view addSubview:_cv];
    
    /////////////
    
    _albums = [NSMutableArray array];
    
    
    _query = [[MPMediaQuery alloc] init];
    /*
     [query addFilterPredicate: [MPMediaPropertyPredicate
     predicateWithValue: @"Moribund the Squirrel"
     forProperty: MPMediaItemPropertyArtist]];
     */
    //
    
    [_query setGroupingType: MPMediaGroupingAlbum];
    NSArray *albums = [_query collections];
    for (MPMediaItemCollection *album in albums) {
        
        MPMediaItem *representativeItem = [album representativeItem];
        NSString *artistName =
        [representativeItem valueForProperty: MPMediaItemPropertyArtist];
        NSString *albumName =
        [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        MPMediaItemArtwork *artwork= [representativeItem valueForProperty:  MPMediaItemPropertyArtwork];
        
        // NSLog (@"%@ by %@", albumName, artistName);
         NSArray *songs = [album items];
        

        
         for (MPMediaItem *song in songs) {
         NSString *songTitle =
         [song valueForProperty: MPMediaItemPropertyTitle];
             
         // NSLog (@"\t\t%@", songTitle);
             NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                                artistName,@"artist_name",
                                albumName,@"album_name",
                                artwork,@"artwork",
                                songTitle,@"song_name",
                                nil];
             
             [_albums addObject:dic];
         }
         
    }
    
    self.cellCount=[_albums count];
    self.cellCount=10;
    
    //self.player = [MPMusicPlayerController iPodMusicPlayer];
    
    self.player = [MPMusicPlayerController applicationMusicPlayer];
   // [self.player setQueueWithQuery:_query];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(updatePlayingMusicInfo:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:self.player];
    [self.player beginGeneratingPlaybackNotifications];
    
    //[self.player play];
    //self.isPlaying=True;
    _btn_play = [self getControllButton];
    _btn_play.center=CGPointMake(_controller.center.x,_controller.frame.size.height/2);
    [_btn_play addTarget:self
                  action:@selector(play_pushed:) forControlEvents:UIControlEventTouchUpInside];
    [_controller addSubview:_btn_play];
    
    _btn_next = [self getControllButton];
    _btn_next.center=CGPointMake(_controller.center.x+_btn_next.frame.size.width*3/2,_controller.frame.size.height/2);
    [_btn_next addTarget:self
                  action:@selector(next_pushed:) forControlEvents:UIControlEventTouchUpInside];
    [_controller addSubview:_btn_next];
    
    _btn_previous = [self getControllButton];
    _btn_previous.center=CGPointMake(_controller.center.x-_btn_previous.frame.size.width*3/2,_controller.frame.size.height/2);
    [_btn_previous addTarget:self
                      action:@selector(previous_pushed:) forControlEvents:UIControlEventTouchUpInside];
    [_controller addSubview:_btn_previous];
    
    [_slider addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
}

-(UIButton *) getControllButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    btn.backgroundColor=[UIColor redColor];
    btn.layer.cornerRadius = btn.frame.size.width/2;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    return btn;

}

#pragma mark - controller
-(void)play_pushed:(UIButton *)btn{
    if(_isPlaying){
        _isPlaying=NO;
        [_player pause];
    }else{
        _isPlaying=YES;
        [_player play];
    }
}

-(void)next_pushed:(UIButton *)btn{
    [_player skipToNextItem];

}

-(void)previous_pushed:(UIButton *)btn{
    [_player skipToPreviousItem];
    
}

-(void)slide:(UISlider*)slider{
    _player.volume=slider.value;
}
#pragma mark - player
-(void)updatePlayingMusicInfo:(id *)something
{
     _song_info.text=  [[_player nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle];
}

-(void)MPMusicPlayerControllerVolumeDidChangeNotification:(id *)something
{
   // _slider.value=_player.volume;
}

# pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CMSpiralCell *cell;
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"CMSpiralCell" forIndexPath:indexPath];
    cell.iv.image=nil;
    if(indexPath.section==0){
        cell.label.text=[[NSString alloc] initWithFormat:@"%d",indexPath.row];
        cell.label.textAlignment=  NSTextAlignmentCenter;;
        cell.label.font = [UIFont fontWithName:@"AppleGothic" size:100];
        //   UIImage *artworkImage =[[[_albums objectAtIndex:indexPath.row] objectForKey:@"artwork"] imageWithSize: cell.iv.bounds.size];
          // cell.iv.image=artworkImage;
        
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellCount=self.cellCount-1;

    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    ad.playerViewController.query=_query;
    ad.playerViewController.needReload=YES;
    [self presentViewController:ad.playerViewController animated:YES completion:nil];
    
    // NSLog(@"%d:%s",indexPath.row,[[_albums objectAtIndex:indexPath.row] objectForKey:@"song_name"]);
    /*
    [_cv performBatchUpdates:^{
     [_cv deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
     
     } completion:^(BOOL finished){
     CMArtistViewController *avc=[[CMArtistViewController alloc] initWithNibName:@"CMArtistViewController" bundle:nil];
     [self.navigationController pushViewController:avc animated:NO];
     }];
     */
    return YES;
}



#pragma mark - something
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)pop:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}


@end
