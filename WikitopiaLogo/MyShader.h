//
//  MyShader.h
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface MyShader : NSObject

@property (nonatomic, retain) NSString *name;
@property (assign) int program;
@property (nonatomic, retain) NSMutableArray *propertyNames;
@property (nonatomic, retain) NSMutableArray *uniformNames;
@property (assign) int *uniformLocations;

- (id)initWithName:(NSString *)shaderName;
- (void)addPropertyNames:(NSString *)firstName, ... NS_REQUIRES_NIL_TERMINATION;
- (void)addUniformNames:(NSString *)firstName, ... NS_REQUIRES_NIL_TERMINATION;
- (BOOL)loadShaders;

@end
