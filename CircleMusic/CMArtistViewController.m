//
//  CMArtistViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMArtistViewController.h"
#import "CMAppDelegate.h"

#import "CMSpiralLayout.h"
#import "CMSpiralCell.h"

@interface CMArtistViewController ()

@end

@implementation CMArtistViewController

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
    
    
    _query = [MPMediaQuery  artistsQuery];
    
    [_query addFilterPredicate: [MPMediaPropertyPredicate
                                predicateWithValue: @"Linkin Park"
                                forProperty: MPMediaItemPropertyArtist]];
   
    [_query setGroupingType: MPMediaGroupingAlbum];
    NSArray *albums = [_query collections];
    for (MPMediaItemCollection *album in albums) {

        MPMediaItem *representativeItem = [album representativeItem];
        NSString *artistName =
        [representativeItem valueForProperty: MPMediaItemPropertyArtist];
        NSString *albumName =
        [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        MPMediaItemArtwork *artwork= [representativeItem valueForProperty:  MPMediaItemPropertyArtwork];

        NSLog (@"%@ by %@", albumName, artistName);
       // NSArray *songs = [album items];
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                           artistName,@"artist_name",
                           albumName,@"album_name",
                           artwork,@"artwork",
                           nil];
        
        [_albums addObject:dic];
        /*
        for (MPMediaItem *song in songs) {
            NSString *songTitle =
            [song valueForProperty: MPMediaItemPropertyTitle];
           // NSLog (@"\t\t%@", songTitle);
        }
         */
    }
    
    self.cellCount=[albums count];
    //self.cellCount=10;

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
        cell.label.textAlignment= NSTextAlignmentCenter;
        cell.label.font = [UIFont fontWithName:@"AppleGothic" size:100];
        UIImage *artworkImage =[[[_albums objectAtIndex:indexPath.row] objectForKey:@"artwork"] imageWithSize: cell.iv.bounds.size];
            cell.iv.image=artworkImage;
    
    }
    
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellCount=self.cellCount-1;
    CMAppDelegate *ad=[[UIApplication sharedApplication] delegate];
    ad.playerViewController.query=_query;
    [self presentViewController:ad.playerViewController animated:YES completion:nil];
/*
    NSLog(@"%d",indexPath.row);
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
