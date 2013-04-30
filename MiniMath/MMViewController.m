//
//  MMViewController.m
//  MiniMath
//
//  Created by Todd Ditchendorf on 4/29/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "MMViewController.h"
#import "MiniMathParser.h"
#import <ParseKit/ParseKit.h>

@implementation MMViewController

- (void)viewDidLoad {
    _inputField.text = @"(2+2)*3";
}

- (IBAction)calc:(id)sender {
    NSString *input = _inputField.text;
    
    MiniMathParser *parser = [[MiniMathParser alloc] init];
    
    NSError *err = nil;
    PKAssembly *result = [parser parseString:input assembler:nil error:&err];

    if (!result) {
        if (err) NSLog(@"%@", err);
        _outputField.text = @"";
        return;
    }

    // print the entire assembly in the result output field
    _outputField.text = [result description];
    
    // the numerical result is stored on the top of the assembly's stack
    NSNumber *n = [result pop];
    NSLog(@"The numerical result is: %@", n);
}

@end
