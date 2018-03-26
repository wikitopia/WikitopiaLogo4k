//
//  ViewController.m
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import "ViewController.h"
#import "MyOpenGLView.h"

@implementation ViewController

@synthesize scrollView;
@synthesize glView;
@synthesize generateButton;
@synthesize progIndicator;
@synthesize messageField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    glView.delegate = self;
    [[scrollView contentView] scrollToPoint:NSMakePoint(710.0, 365.0)];
    [scrollView reflectScrolledClipView:[scrollView contentView]];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

- (IBAction)generateMovie:(id)sender
{
    [generateButton setEnabled:NO];
    [progIndicator startAnimation:self];
    [messageField setStringValue:@"Generating Movie..."];
    [glView generateMovie];
}

- (void)updateMessage;
{
    [progIndicator stopAnimation:self];
    [messageField setStringValue:@"Done"];
}

@end
