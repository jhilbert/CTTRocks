//
//  ViewController.h
//  CTTRocks
//
//  Created by Josef Hilbert on 11.02.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RocksScrollViewController : UIViewController

@property (strong, nonatomic) NSArray *rocks;
@property NSInteger *selectedRock;
@property NSInteger *rocksFiltered;

@end
