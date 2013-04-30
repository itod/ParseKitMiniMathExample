//
//  MMViewController.h
//  MiniMath
//
//  Created by Todd Ditchendorf on 4/29/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMViewController : UIViewController

- (IBAction)calc:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *inputField;
@property (nonatomic, strong) IBOutlet UITextField *outputField;
@end
