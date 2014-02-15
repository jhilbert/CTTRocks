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
    
    UIColor *colorCT;
    UIColor *colorCTFacade;
}

@end

@implementation RocksScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rocks = [Rock rocks];
    
    colorCT = [UIColor colorWithRed:7.0/255.0 green:66.0/255.0 blue:133.0/255.0 alpha:1.0];
    colorCTFacade = [UIColor colorWithRed:205.0/255.0 green:186.0/255.0 blue:146.0/255.0 alpha:1.0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat width = 0.0;
    
    scrollView.contentSize = CGSizeMake(width, scrollView.frame.size.height);
    Rock *rock;
    
    UIFont *fontForTitle = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    UIFont *fontForLocation = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    for (int n = 0; n < _rocks.count; n++) {
        rock = _rocks[n];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:rock.image];
        [scrollView addSubview:imageView];
        
        imageView.frame = CGRectMake(width, 0, self.view.frame.size.width, screenHeight);
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        //    if (self.indexPathRow == n) {
        //        startingX = width;
        //    }
  
        UIView *upperOverlay = [[UIView alloc] init];
        [scrollView addSubview:upperOverlay];
        upperOverlay.frame = CGRectMake(width+10, 5, self.view.frame.size.width - 20, 42);
        upperOverlay.backgroundColor = colorCT;
        upperOverlay.alpha = 0.7;
        
        UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 21))];
        [title setText: rock.title];
        [title setFont:fontForTitle];
        title.textColor = colorCTFacade;
        title.textAlignment = NSTextAlignmentCenter;
        
        [upperOverlay addSubview:title];
        
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
        location.textColor = colorCTFacade;
        [upperOverlay addSubview:location];
        
        UILabel *year = [[UILabel alloc] initWithFrame:(CGRectMake(265, 22, 50, 21))];
        year.text = rock.year;
        [year setFont:fontForLocation];
        year.textColor = colorCTFacade;
        [upperOverlay addSubview:year];
 
        UIView *lowerOverlay = [[UIView alloc] init];
        lowerOverlay.tag = 001;
        [scrollView addSubview:lowerOverlay];
        lowerOverlay.frame = CGRectMake(width+10, 250, self.view.frame.size.width - 20, 410);
        lowerOverlay.backgroundColor = colorCT;
        lowerOverlay.alpha = 0.9;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        
        [lowerOverlay addGestureRecognizer:panGesture];
        
        NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:rock.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]}];
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textString];
        NSLayoutManager *textLayout = [[NSLayoutManager alloc] init];
        // Add layout manager to text storage object
        [textStorage addLayoutManager:textLayout];
        // Create a text container
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.view.bounds.size];
        // Add text container to text layout manager
        [textLayout addTextContainer:textContainer];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:(CGRectMake(5, 200, 290, 190)) textContainer:textContainer];
        [lowerOverlay addSubview:textView];
        textView.backgroundColor = colorCTFacade;
        textView.text = rock.text;
        textView.editable = NO;
        textView.selectable = NO;
        textView.alpha = 1.0;
        
        UIImageView *imageOfBuildingView = [[UIImageView alloc] initWithImage:rock.imageOfBuilding];
        [lowerOverlay addSubview:imageOfBuildingView];
        imageOfBuildingView.contentMode = UIViewContentModeScaleAspectFit;
        imageOfBuildingView.frame = CGRectMake(5, 5, 290, 190);
        imageOfBuildingView.clipsToBounds = YES;
        imageOfBuildingView.backgroundColor = colorCT;
        
        imageOfBuildingView.alpha = 1.0;
        imageOfBuildingView.tag = 100;
        
        
        width += imageView.frame.size.width;
    }
    scrollView.contentSize = CGSizeMake(width, scrollView.frame.size.height);
}

-(IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    CGPoint translate = [sender translationInView:self.view];
  
    CGPoint draggingPoint = [sender locationInView:self.view];
    UIView *hitView = [self.view hitTest:draggingPoint withEvent:nil];
    if (hitView.tag == 001)
        {
        
    hitView.center = CGPointMake(hitView.center.x + translate.x,
                                                 hitView.center.y + translate.y);
    [sender setTranslation:CGPointMake(0, 0) inView:hitView];
        }
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
