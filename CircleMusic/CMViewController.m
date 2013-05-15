//
//  CMViewController.m
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import "CMViewController.h"
#define TIMER 0.05f
@interface CMViewController ()

@end

@implementation CMViewController


-(void)viewWillAppear:(BOOL)animated
{
    //  self.cellCount=5;
    // [_cv reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    /*
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
     */
    
    [NSThread detachNewThreadSelector:@selector(artistvcThread)
                             toTarget:self
                           withObject:nil];
    [NSThread detachNewThreadSelector:@selector(songvcThread)
                             toTarget:self
                           withObject:nil];
    [NSThread detachNewThreadSelector:@selector(albumvcThread)
                             toTarget:self
                           withObject:nil];
    [NSThread detachNewThreadSelector:@selector(playlistvcThread)
                             toTarget:self
                           withObject:nil];
    
    if(_infoViewController==NULL){
        _infoViewController=[[CMInfoViewController alloc] initWithNibName:@"CMInfoViewController" bundle:nil];
        
    }
    
    
    
#pragma mark Genre View
    _center=self.view.center;
    _radius=self.view.frame.size.width*0.33;
    float size=self.view.frame.size.width*0.35;
    _angle=M_PI/2.0;
    _interval_angle=2.0*M_PI/5.0;
    _views=[NSMutableArray array];
    
    
    CMPlayerButtonView *artist=[[CMPlayerButtonView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [artist makeCircle];
    artist.center=CGPointMake(_center.x+_radius*cos(_angle-0.0*_interval_angle),_center.y-_radius*sin(_angle-0.0*_interval_angle));
    artist.image=[UIImage imageNamed:@"cell-artist.png"];
    [self.view addSubview:artist];
    [_views addObject:artist];
    
    CMPlayerButtonView *song=[[CMPlayerButtonView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [song makeCircle];
    song.center=CGPointMake(_center.x+_radius*cos(_angle-1.0*_interval_angle),_center.y-_radius*sin(_angle-1.0*_interval_angle));
    song.image=[UIImage imageNamed:@"cell-song.png"];
    [self.view addSubview:song];
    [_views addObject:song];
    
    CMPlayerButtonView *album=[[CMPlayerButtonView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [album makeCircle];
    album.center=CGPointMake(_center.x+_radius*cos(_angle-2.0*_interval_angle),_center.y-_radius*sin(_angle-2.0*_interval_angle));
    album.image=[UIImage imageNamed:@"cell-album.png"];
    [self.view addSubview:album];
    [_views addObject:album];
    
    CMPlayerButtonView *list=[[CMPlayerButtonView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [list makeCircle];
    list.center=CGPointMake(_center.x+_radius*cos(_angle-3.0*_interval_angle),_center.y-_radius*sin(_angle-3.0*_interval_angle));
    list.image=[UIImage imageNamed:@"cell-playlist.png"];
    [self.view addSubview:list];
    [_views addObject:list];
    
    CMPlayerButtonView *info=[[CMPlayerButtonView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [info makeCircle];
    info.center=CGPointMake(_center.x+_radius*cos(_angle-4.0*_interval_angle),_center.y-_radius*sin(_angle-4.0*_interval_angle));
    info.image=[UIImage imageNamed:@"cell-info.png"];
    [self.view addSubview:info];
    [_views addObject:info];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panRecognizer.delegate=self;
    [self.view addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer* longpressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    longpressRecognizer.delegate=self;
    [self.view addGestureRecognizer:longpressRecognizer];
    
    _point_tap_began.x=-99;
    
}

#pragma mark gesture
-(void)updateCircle:(float)angle
{
    angle*=1.5;
    _angle+=angle;
    for (int i=0; i<[_views count]; i++) {
        CMPlayerButtonView *view=[_views objectAtIndex:i];
        view.center=CGPointMake(_center.x+_radius*cos(_angle-i*_interval_angle),_center.y-_radius*sin(_angle-i*_interval_angle));
    }
    
}
#pragma mark - scrolling

-(void)clock:(id)something
{
    if(_scroll_speed>0.005 || _scroll_speed<-0.005){
        [self updateCircle:_scroll_speed*1.2];
        _scroll_speed*=0.96;
        //NSLog(@"SPEED:%lf",_scroll_speed);
        
    }else{
        _scroll_speed=0.0;
        //  NSLog(@"scroll_end");
        [_tm invalidate];
        
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    if([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]){
        _scroll_speed=0.0;
        CGPoint point=[touch locationInView:self.view];
        if(_point_tap_began.x==-99){
            for(int i=0;i<[_views count];i++){
                CMPlayerButtonView *view=[_views objectAtIndex:i];
                if(CGRectContainsPoint(view.frame, point)){
                    void (^animations)(void) = ^{
                        
                        float scale_value=1.25;
                        
                        CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
                        [view setTransform:scale];
                        
                    };
                    
                    [UIView animateWithDuration:0.1 animations:animations completion:nil];
                    _on[i]=YES;
                    _point_tap_began=point;
                    
                }
                
            }
        }
        
        
        
        
    }
    
    return YES;
}

- (void)handlePanGesture:(UIGestureRecognizer *)sender
{
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    CGPoint point = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    CGPoint current_point=CGPointMake(_point_tap_began.x+point.x, _point_tap_began.y+point.y);
    if(sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        [self resetControlButtons];
    }else{
        float side=self.view.frame.size.width/3;
        float div2=self.view.frame.size.width/2;
        
        float angle=0;
        if(CGRectContainsPoint(CGRectMake(0, _center.y-div2, side, side), current_point)){
            NSLog(@"0-0");
            angle=sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2));
            if(velocity.x>0)  angle*=-1;
            if(velocity.x<0) angle*=1;
            
             [self updateCircle:angle]; 
            
        }else if(CGRectContainsPoint(CGRectMake(side, _center.y-div2, side, side), current_point)){
            NSLog(@"0-1");
            angle=sqrt(pow(velocity.x*0.0001,2));
            if(velocity.x>0)  angle*=-1;
            if(velocity.x<0) angle*=1;
             [self updateCircle:1*angle]; 
            
            
        }else if(CGRectContainsPoint(CGRectMake(side*2, _center.y-div2, side, side), current_point)){
            NSLog(@"0-2");
            angle=sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2));
            if(velocity.x>0) angle*=-1;
            if(velocity.x<0) angle*=1;
             [self updateCircle:1*angle]; 
        }else if(CGRectContainsPoint(CGRectMake(0, _center.y-div2+side, side, side), current_point)){
            NSLog(@"1-0");
            angle=sqrt(pow(velocity.y*0.0001,2));
            if(velocity.y>0) angle*=1;
            if(velocity.y<0) angle*=-1;
             [self updateCircle:1*angle]; 
        }else if(CGRectContainsPoint(CGRectMake(side*2, _center.y-div2+side, side, side), current_point)){
            NSLog(@"1-2");
            angle=sqrt(pow(velocity.y*0.0001,2));
            if(velocity.y>0) angle*=-1;
            if(velocity.y<0) angle*=1;
             [self updateCircle:1*angle]; 
        }else if(CGRectContainsPoint(CGRectMake(0, _center.y+div2-side, side, side), current_point)){
            NSLog(@"2-0");
            angle=sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2));
            if(velocity.x>0) angle*=1;
            if(velocity.x<0) angle*=-1;
             [self updateCircle:1*angle]; 
        }else if(CGRectContainsPoint(CGRectMake(side, _center.y+div2-side, side, side), current_point)){
            NSLog(@"2-1");
            angle=sqrt(pow(velocity.x*0.0001,2));
            if(velocity.x>0) angle*=1;
            if(velocity.x<0) angle*=-1;
             [self updateCircle:1*angle]; 
        }else if(CGRectContainsPoint(CGRectMake(side*2, _center.y+div2-side, side, side), current_point)){
            NSLog(@"2-2");
            angle=sqrt(pow(velocity.x*0.0001,2)+pow(MAX(velocity.y,0)*0.0001,2));
            if(velocity.x>0) angle*=1;
            if(velocity.x<0) angle*=-1;
             [self updateCircle:1*angle]; 
        }
        
        if (sender.state == UIGestureRecognizerStateEnded){
            _scroll_speed=angle;
            //  NSLog(@"Tag:%d",tag);
            _tm =
            [NSTimer scheduledTimerWithTimeInterval:TIMER target:self selector:@selector(clock:) userInfo:nil repeats:YES];
            
            [_tm fire];
            [self resetControlButtons];
        }
        
        
    }
}
- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
        CGPoint point=[tap locationInView:self.view];
        
        [self resetControlButtons];
        
        for(int i=0;i<[_views count];i++){
            CMPlayerButtonView *view=[_views objectAtIndex:i];
            if(CGRectContainsPoint(view.frame, point)){
                
                switch (i) {
                        
                    case 0:
                        [self.navigationController pushViewController:_artistViewController animated:NO];
                        break;
                    case 1:
                        [self.navigationController pushViewController:_songViewController animated:NO];
                        break;
                    case 2:
                        [self.navigationController pushViewController:_albumViewController animated:NO];
                        break;
                    case 3:
                        [self.navigationController pushViewController:_playlistViewController animated:NO];
                        break;
                    case 4:
                        [self.navigationController pushViewController:_infoViewController animated:NO];
                        break;
                        
                    default:
                        break;
                }
                
                
            }
        }
        
        
        
        
        
    }else if(sender.state==UIGestureRecognizerStateCancelled ||sender.state==UIGestureRecognizerStateFailed){
        [self resetControlButtons];
    }
}

-(void)resetControlButtons
{
    for(int i=0;i<[_views count];i++){
        _on[i]=NO;
        CMPlayerButtonView *view=[_views objectAtIndex:i];
        float scale_value=1.0;
        CGAffineTransform scale = CGAffineTransformMakeScale(scale_value, scale_value);
        [view setTransform:scale];
        _point_tap_began.x=-99;
    }
}


#pragma mark - load vc
- (void)artistvcThread {
    //各種Viewの読み込み
    if(_artistViewController==NULL){
        _artistViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:0];
        _artistViewController.delegate=self;
    }
    
}

- (void)songvcThread {
    
    if(_songViewController==NULL){
        _songViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:1];
        _songViewController.delegate=self;
        
    }
    
}
- (void)albumvcThread {
    if(_albumViewController==NULL){
        _albumViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:2];
        _albumViewController.delegate=self;
    }
}
- (void)playlistvcThread {
    
    if(_playlistViewController==NULL){
        _playlistViewController=[[CMAlbumViewController alloc] initWithNibName:@"CMAlbumViewController" bundle:nil withType:3];
        _playlistViewController.delegate=self;
        
    }
    
    
}

-(void)CMAlbumViewControllerDidChangeProgressOfLoad:(float)progress From:(CMAlbumViewController*)vc
{
    // NSLog(@"%lf",progress);
}

# pragma mark - collection view
/*
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
 
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MEMORYYYYYYYYYYY");
}

@end
