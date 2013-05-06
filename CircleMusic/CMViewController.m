//
//  CMViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMViewController.h"

@interface CMViewController ()

@end

@implementation CMViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.cellCount=5;
    [_cv reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    //level selector
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 80)];
    [flowLayout setMinimumLineSpacing:10.0f];
    [flowLayout setMinimumInteritemSpacing:10.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 10, 20, 10)];
    float cv_height=
    //self.view.frame.size.height
    [[UIScreen mainScreen] bounds].size.height;
    
    
    // _cv=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320 , cv_height) collectionViewLayout:flowLayout];
    _cv=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320 , cv_height) collectionViewLayout:[[CMCircleLayout alloc] init]];
    
    _cv.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    _cv.showsHorizontalScrollIndicator = NO;
    _cv.showsVerticalScrollIndicator = NO;
    _cv.bounces=NO;
    // UINib *nib = [UINib nibWithNibName:@"CMContentCell" bundle:nil];
    //[_cv registerNib:nib forCellWithReuseIdentifier:@"CMContentCell"];
    //  [_cv registerClass:[Cell class] forCellWithReuseIdentifier:@"CMContentCell"];
    [_cv registerClass:[CMContentCell class] forCellWithReuseIdentifier:@"CMContentCell"];
    _cv.delegate=self;
    _cv.dataSource=self;
    [self.view addSubview:_cv];
    
    
 
}

-(void)viewDidAppear:(BOOL)animated
{
    //各種Viewの読み込み
    if(_artistViewController==NULL){
        _artistViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:0];
    }
    
    if(_songViewController==NULL){
        _songViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:1];
        
    }
    
    if(_albumViewController==NULL){
        _albumViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:2];
    }
    
    if(_playlistViewController==NULL){
        _playlistViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:3];
        
    }
    
    if(_infoViewController==NULL){
        _infoViewController=[[CMInfoViewController alloc] initWithNibName:@"CMInfoViewController" bundle:nil];
        
    }
}


# pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CMContentCell *cell;
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"CMContentCell" forIndexPath:indexPath];
    cell.iv.image=nil;
    if(indexPath.section==0){
        if(indexPath.row == 0){
            cell.iv.image=[UIImage imageNamed:@"cell-artist.png"];
        }else if(indexPath.row ==1 ){
            cell.iv.image=[UIImage imageNamed:@"cell-song.png"];
        }else if(indexPath.row ==2 ){
            cell.iv.image=[UIImage imageNamed:@"cell-album.png"];
        }else if(indexPath.row ==3 ){
            cell.iv.image=[UIImage imageNamed:@"cell-playlist.png"];
        }else if(indexPath.row == 4){
            cell.iv.image=[UIImage imageNamed:@"cell-info.png"];
        }
    }
    
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellCount=self.cellCount-1;
    NSLog(@"%d",indexPath.row);
    [_cv performBatchUpdates:^{
        [_cv deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        
    } completion:^(BOOL finished){
        if(indexPath.row==0){
    
            [self.navigationController pushViewController:_artistViewController animated:NO];
            
            
        }else if(indexPath.row==1){
            [self.navigationController pushViewController:_songViewController animated:NO];
            
        }else if(indexPath.row==2){
    
            [self.navigationController pushViewController:_albumViewController animated:NO];
            
        }else if(indexPath.row==3){
            
            [self.navigationController pushViewController:_playlistViewController animated:NO];
            
        }else if(indexPath.row==4){
            
              [self.navigationController pushViewController:_infoViewController animated:NO];
        }
        
    }];
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MEMORYYYYYYYYYYY");
}

@end
