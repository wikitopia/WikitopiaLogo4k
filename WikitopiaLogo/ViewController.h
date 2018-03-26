//
//  ViewController.h
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MyOpenGLView;

@interface ViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSScrollView *scrollView;
@property (nonatomic, weak) IBOutlet MyOpenGLView *glView;
@property (nonatomic, weak) IBOutlet NSButton *generateButton;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *progIndicator;
@property (nonatomic, weak) IBOutlet NSTextField *messageField;

- (IBAction)generateMovie:(id)sender;
- (void)updateMessage;

@end

