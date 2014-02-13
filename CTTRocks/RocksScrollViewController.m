//
//  ViewController.m
//  CTTRocks
//
//  Created by Josef Hilbert on 11.02.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "RocksScrollViewController.h"
#import "Rock.h"

@interface RocksScrollViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, UITabBarDelegate>
{
    
    __weak IBOutlet UIScrollView *scrollView;
    
    NSArray *imagePaths;
    float startingX;
}

@end

@implementation RocksScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rocks = [Rock rocks];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat width = 0.0;
    
    scrollView.contentSize = CGSizeMake(width, scrollView.frame.size.height);
    Rock *rock;
    
    UIFont *fontForTitle = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    UIFont *fontForLocation = [UIFont fontWithName:@"HelveticaNeue" size:17];
    
    for (int n = 0; n < _rocks.count; n++) {
        rock = _rocks[n];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:rock.image];
        [scrollView addSubview:imageView];
        
        imageView.frame = CGRectMake(width, 0, self.view.frame.size.width, 200);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        //    if (self.indexPathRow == n) {
        //        startingX = width;
        //    }
        
        UIView *lowerPart = [[UIView alloc] init];
        lowerPart.tag = 001;
        [scrollView addSubview:lowerPart];
        lowerPart.frame = CGRectMake(width, 200, self.view.frame.size.width, screenHeight - 200);
        lowerPart.backgroundColor = [UIColor colorWithRed:255/255.0f green:208/255.0f blue:114/255.0f alpha:1.0];
        
        UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 21))];
        [title setText: rock.title];
        [title setFont:fontForTitle];
        title.textAlignment = NSTextAlignmentCenter;
        
        [lowerPart addSubview:title];
        
        //      location: combine country, state, location
        UILabel *location = [[UILabel alloc] initWithFrame:(CGRectMake(10, 22, 250, 21))];
        if ([rock.country isEqualToString:@"USA"])
        {
            location.text = [NSString stringWithFormat:@"%@ %@ %@",rock.country, rock.state, rock.location];
        }
        else
        {
            location.text = [NSString stringWithFormat:@"%@ %@",rock.country, rock.location];
        }
        [location setFont:fontForLocation];
        [lowerPart addSubview:location];
        
        UILabel *year = [[UILabel alloc] initWithFrame:(CGRectMake(270, 22, 50, 21))];
        year.text = rock.year;
        [year setFont:fontForLocation];
        [lowerPart addSubview:year];
        
        NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:rock.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15]}];
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textString];
        NSLayoutManager *textLayout = [[NSLayoutManager alloc] init];
        // Add layout manager to text storage object
        [textStorage addLayoutManager:textLayout];
        // Create a text container
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
        // Add text container to text layout manager
        [textLayout addTextContainer:textContainer];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:(CGRectMake(0, 42, self.view.frame.size.width, screenHeight - 200 - 42 - 64 - 48)) textContainer:textContainer];
        [lowerPart addSubview:textView];
        textView.backgroundColor = [UIColor colorWithRed:255/255.0f green:254/255.0f blue:216/255.0f alpha:1.0];
        textView.text = rock.text;
        textView.editable = NO;
        textView.selectable = NO;
        
        UIImageView *imageOfBuildingView = [[UIImageView alloc] initWithImage:rock.imageOfBuilding];
        [lowerPart addSubview:imageOfBuildingView];
        imageOfBuildingView.contentMode = UIViewContentModeScaleAspectFit;
        imageOfBuildingView.frame = CGRectMake(0, 42, self.view.frame.size.width, screenHeight - 200 - 42 - 64 - 48);
        imageOfBuildingView.clipsToBounds = YES;
        imageOfBuildingView.backgroundColor = [UIColor blackColor];
        
        imageOfBuildingView.alpha = 0;
        imageOfBuildingView.tag = 100;
        
        
        width += imageView.frame.size.width;
    }
    scrollView.contentSize = CGSizeMake(width, scrollView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    startingX = (int)self.selectedRock * (int)self.view.frame.size.width;
    [scrollView setContentOffset:CGPointMake(startingX, self.view.frame.size.height)];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset:CGPointMake(aScrollView.contentOffset.x, 0.0)];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    // UITabBarItem 'tag' value is used to identify the saved tab bar item
 
    if (item.tag == 1) {
        for (UIView *view in scrollView.subviews)
        {
            if (view.tag == 001)
            {
                for (UIView *imageView in view.subviews)
                {
                    if (imageView.tag == 100)
                    {
                        imageView.alpha = 0;
                    }
                }

            }
        }
    }

    if (item.tag == 2) {
        for (UIView *view in scrollView.subviews)
        {
            if (view.tag == 001)
            {
                for (UIView *imageView in view.subviews)
                {
                    if (imageView.tag == 100)
                    {
                        imageView.alpha = 1;
                    }
                }
                
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
