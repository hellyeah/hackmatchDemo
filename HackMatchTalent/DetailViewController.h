//
//  DetailViewController.h
//  HackMatchTalent
//
//  Created by David Fontenot on 3/31/14.
//  Copyright (c) 2014 Dave Fontenot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
