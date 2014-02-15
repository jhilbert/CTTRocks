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

@interface MainCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITextFieldDelegate>

{
    NSArray *rocks;
    UIImage *imageForCell;
    
    __weak IBOutlet UITextField *searchTextField;
    
    IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
    
    NSIndexPath *selectedIP;
    
    UICollectionViewFlowLayout *springFlowLayout;
    
    BOOL landscape;
    
    UIFont *fontForTitle;
    UIFont *fontForLocation;
    UIFont *fontForNumber;
    UIColor *colorCT;
    UIColor *colorCTFacade;

}

@end

@implementation MainCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fontForTitle = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    fontForLocation = [UIFont fontWithName:@"HelveticaNeue" size:14];
    fontForNumber = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    colorCT = [UIColor colorWithRed:7.0/255.0 green:66.0/255.0 blue:133.0/255.0 alpha:1.0];
    colorCTFacade = [UIColor colorWithRed:205.0/255.0 green:186.0/255.0 blue:146.0/255.0 alpha:1.0];
    
    springFlowLayout = [[SpringFlowLayout alloc] init];
    springFlowLayout.itemSize = CGSizeMake(320, 75);
    springFlowLayout.headerReferenceSize = CGSizeMake(collectionView.frame.size.width, 100);
    
 //   collectionViewFlowLayout = springFlowLayout;
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = colorCT;
    
    landscape = NO;
    
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.clearsOnBeginEditing = YES;
    searchTextField.placeholder = @"Search for ...";
    
    rocks = [Rock rocks];
    
    imageForCell = [UIImage imageNamed:@"640x150_rounded_opaque"];
    self.navigationController.toolbar.barTintColor = colorCT;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
    
- (IBAction)searchTextFieldDidEndOnExit:(id)sender {
    if ([searchTextField.text isEqualToString:@""])
    {
        rocks = [Rock rocks];
    }
    else
    {
        rocks = [Rock rocksFiltered:searchTextField.text];
    }
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [collectionView reloadData];
    } completion:nil];
    [searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

// delete code if we decide that we need NO searchBar in CollectionViewHeader!

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if ([searchText isEqualToString:@""])
//    {
//        rocks = [Rock rocks];
//    }
//    else
//    {
//        rocks = [Rock rocksFiltered:searchText];
//    }
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//    } completion:nil];
//}
//
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];
//}
//
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [searchBar setText:@""];
//    [searchBar setShowsCancelButton:NO animated:YES];
//    [searchBar resignFirstResponder];
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTTCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundColor = colorCT;
    
    //   cell.imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    //   cell.imageView.center = cell.center;
    
    Rock *rock = rocks[indexPath.row];
//    cell.imageView.image = imageForCell;
    //  cell.imageViewRockThumbnail.image = rock.imageThumbnail;
    cell.imageViewRockThumbnail.image = [UIImage imageNamed:@"S003"];
    
    cell.imageViewRockThumbnail.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageViewCountry.image = [UIImage imageNamed:@"Flag of United States"];
    cell.imageViewCountry.contentMode = UIViewContentModeScaleAspectFit;
    cell.labelTitle.text = rock.title;
    cell.labelTitle.textColor = colorCTFacade;
    [cell.labelTitle setFont:fontForTitle];
    
    if ([rock.country isEqualToString:@"USA"])
    {
        cell.labelLocation.text = [NSString stringWithFormat:@"%@ %@ %@",rock.country, rock.state, rock.location];
    }
    else
    {
        cell.labelLocation.text = [NSString stringWithFormat:@"%@ %@",rock.country, rock.location];
    }
    cell.labelLocation.textColor = colorCTFacade;
    [cell.labelLocation setFont:fontForLocation];
    
    cell.labelNumber.text = [NSString stringWithFormat:@"%03d", (int)indexPath.row + 1];
    cell.labelNumber.textColor = colorCTFacade;
    [cell.labelNumber setFont:fontForNumber];
    
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView.collectionViewLayout invalidateLayout];
    return rocks.count;
}

- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 75);
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        }
        return reusableview;
    }
    return nil;
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

@end
