//
//  MyShader.m
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import "MyShader.h"

@interface MyShader (Private)
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
@end

@implementation MyShader

@synthesize name;
@synthesize program;
@synthesize propertyNames;
@synthesize uniformNames;
@synthesize uniformLocations;

- (id)initWithName:(NSString *)shaderName
{
    self = [super init];
    if(self){
        name = shaderName;
        propertyNames = [[NSMutableArray alloc] init];
        uniformNames = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithName:@""];
}

- (void)dealloc
{
    if(uniformLocations != NULL){
        free(uniformLocations);
    }
}

- (void)addPropertyNames:(NSString *)firstName, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list propNames;
    va_start(propNames, firstName);
    for(NSString *propName = firstName; propName != nil; propName = va_arg(propNames, NSString *)){
        [propertyNames addObject:propName];
    }
    va_end(propNames);
}

- (void)addUniformNames:(NSString *)firstName, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list uniNames;
    va_start(uniNames, firstName);
    for(NSString *uniName = firstName; uniName != nil; uniName = va_arg(uniNames, NSString *)){
        [uniformNames addObject:uniName];
    }
    va_end(uniNames);
}

- (BOOL)loadShaders
{
    GLuint vertexShader;
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    if([self compileShader:&vertexShader type:GL_VERTEX_SHADER file:vertexShaderPath] == NO){
        NSLog(@"Failed compiling vertex shader");
        return NO;
    }
    GLuint fragmentShader;
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    if([self compileShader:&fragmentShader type:GL_FRAGMENT_SHADER file:fragmentShaderPath] == NO){
        NSLog(@"Failed compiling fragment shader");
        return NO;
    }
    program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    for(int i = 0; i < (int)[propertyNames count]; i++){
        glBindAttribLocation(program, i, [[propertyNames objectAtIndex:i] UTF8String]);
    }
    if([self linkProgram:program] == NO){
        NSLog(@"Failed linking program");
        return NO;
    }
    if(uniformLocations != NULL){
        free(uniformLocations);
    }
    uniformLocations = (int *)calloc((int)[uniformNames count], sizeof(int));
    for(int i = 0; i < (int)[uniformNames count]; i++){
        uniformLocations[i] = glGetUniformLocation(program, [[uniformNames objectAtIndex:i] UTF8String]);
    }
    if(vertexShader){
        glDeleteShader(vertexShader);
    }
    if(fragmentShader){
        glDeleteShader(fragmentShader);
    }
    return YES;
}

@end

@implementation MyShader (Private)

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if(!source){
        NSLog(@"Failed loading shader file");
        return NO;
    }
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if(status == 0){
        NSLog(@"Compile status is zero");
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    glLinkProgram(prog);
    GLint status;
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if(status == 0){
        NSLog(@"Link status is zero");
        return NO;
    }
    return YES;
}

@end
