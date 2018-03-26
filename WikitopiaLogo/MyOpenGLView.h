//
//  MyOpenGLView.h
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyOpenGLView : NSOpenGLView

@property (assign) id delegate;

- (void)generateMovie;

@end
