//
//  Rock.m
//  CTTRocks
//
//  Created by Josef Hilbert on 11.02.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "Rock.h"

static NSMutableArray *rocks;
static NSArray *imagePaths;

@interface Rock ()

@end

@implementation Rock

+ (void)loadImages
{
    for (int i = 0; i < imagePaths.count; i++)
    {
        NSLog(@"%@", imagePaths[i]);
        
        NSString *searchStr= @"CTTRocks.app/";
        NSRange range = [imagePaths[i] rangeOfString:searchStr];
        
        NSString *rockNumber = [[imagePaths[i] substringFromIndex:range.location +14] substringToIndex:3];
        NSString *kindOfImage = [[imagePaths[i] substringFromIndex:range.location +13] substringToIndex:1];
        NSLog(@"%@", rockNumber);
        
        NSInteger indexOfImage = [rockNumber integerValue] - 1;
        if (indexOfImage > 0 && [kindOfImage isEqualToString:@"R"])
        {
            ((Rock*)rocks[indexOfImage]).image = [[UIImage alloc] initWithContentsOfFile:imagePaths[i]];
        }
        if (indexOfImage > 0 && [kindOfImage isEqualToString:@"B"])
        {
            ((Rock*)rocks[indexOfImage]).imageOfBuilding = [[UIImage alloc] initWithContentsOfFile:imagePaths[i]];
        }
        if (indexOfImage > 0 && [kindOfImage isEqualToString:@"S"])
        {
            ((Rock*)rocks[indexOfImage]).imageThumbnail = [[UIImage alloc] initWithContentsOfFile:imagePaths[i]];
        }
    }
}

+(NSMutableArray*)rocks
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        rocks = [NSMutableArray new];

        for (int i = 0; i < 150; i++)
        {
            Rock *rock = [Rock new];
            rock.title = [NSString stringWithFormat:@"Title for %i", i+1];
            rock.location = [NSString stringWithFormat:@"Location for %i", i+1];
            rock.country = [NSString stringWithFormat:@"Country for %i", i+1];
            rock.year = [NSString stringWithFormat:@"%i", arc4random_uniform(2014)];
            rock.text = @"Located within the Vatican, atop the traditional site of the tomb of St. Peter, this enormous cathedral was designed by Michelangelo and took 120 years to build (1506-1626). At 453 feet tall, its colossal dome is only nine feet shorter than the Tribune Tower.";
            [rocks addObject:rock];
        }
        imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:nil];
        [self loadImages];
        imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil];
        [self loadImages];
    });
    
    return rocks;

}
@end
