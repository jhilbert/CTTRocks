//
//  MainCollectionViewController.m
//  CTT
//
//  Created by Josef Hilbert on 26.01.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "RocksScrollViewController.h"
#import "CTTCollectionViewCell.h"
#import "SpringFlowLayout.h"
#import "Rock.h"


static NSString const *kShowRock = @"showRock";

@interface MainCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

{
    NSArray *rocks;
    UIImage *imageForCell;

    IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
    
    NSIndexPath *selectedIP;
    
    UICollectionViewFlowLayout *springFlowLayout;
    
    BOOL landscape;
    
    UIFont *fontForTitle;
    UIFont *fontForLocation;
    UIFont *fontForNumber;
    
}

@end

@implementation MainCollectionViewController

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
    
    fontForTitle = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    fontForLocation = [UIFont fontWithName:@"HelveticaNeue" size:17];
    fontForNumber = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    springFlowLayout = [[SpringFlowLayout alloc] init];
    springFlowLayout.itemSize = CGSizeMake(300, 300);
    collectionViewFlowLayout = springFlowLayout;
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView.backgroundColor = [UIColor blackColor];
    
    landscape = NO;
    
    rocks = [Rock rocks];
   
    imageForCell = [UIImage imageNamed:@"640x150_rounded_opaque"];

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTTCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

 //   cell.imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
 //   cell.imageView.center = cell.center;

    Rock *rock = rocks[indexPath.row];
    cell.imageView.image = imageForCell;
//  cell.imageViewRockThumbnail.image = rock.imageThumbnail;
    cell.imageViewRockThumbnail.image = [UIImage imageNamed:@"S002"];
;

    cell.imageViewRockThumbnail.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageViewCountry.image = [UIImage imageNamed:@"Flag of United States"];
    cell.imageViewCountry.contentMode = UIViewContentModeScaleAspectFit;
    cell.labelTitle.text = rock.title;
    [cell.labelTitle setFont:fontForTitle];

    if ([rock.country isEqualToString:@"USA"])
    {
        cell.labelLocation.text = [NSString stringWithFormat:@"%@ %@ %@",rock.country, rock.state, rock.location];
    }
    else
    {
        cell.labelLocation.text = [NSString stringWithFormat:@"%@ %@",rock.country, rock.location];
    }
    [cell.labelLocation setFont:fontForLocation];

    cell.labelNumber.text = [NSString stringWithFormat:@"%03d", (int)indexPath.row + 1];
    [cell.labelNumber setFont:fontForNumber];
    
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return rocks.count;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView.collectionViewLayout invalidateLayout];

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [collectionView setCollectionViewLayout:springFlowLayout animated:YES];
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
     //   collectionViewFlowLayout = flowLayoutLandscape;
        [(UICollectionViewFlowLayout*)collectionView.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        landscape = YES;
    }
    else
    {
        [collectionView setCollectionViewLayout:springFlowLayout animated:YES];
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        
        [(UICollectionViewFlowLayout*)collectionView.collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        landscape = NO;
    }
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select %i", indexPath.row);
    CTTCollectionViewCell *cell = ((CTTCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]);
    cell.imageView.alpha = 1.0;
    selectedIP = indexPath;
    
    [self performSegueWithIdentifier:kShowRock sender:indexPath];

}

- (void)collectionView:(UICollectionView *)cv didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did deselect");
    CTTCollectionViewCell *cell = ((CTTCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]);
    cell.imageView.alpha = 1.0;
}



- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize retval;
    
    if (landscape)
        retval = CGSizeMake(640, 150);
    else
        retval = CGSizeMake(320, 75);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowRock])
    {
        NSIndexPath *itemSelected = [collectionView indexPathsForSelectedItems][0];
        RocksScrollViewController *vc = segue.destinationViewController;
        vc.selectedRock = selectedIP.row;
        NSLog(@"segue to %i", selectedIP.row);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end