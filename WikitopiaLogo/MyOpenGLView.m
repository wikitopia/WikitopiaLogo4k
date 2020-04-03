//
//  MyOpenGLView.m
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import "MyOpenGLView.h"
#import "MyShader.h"
#import "MyOpenGLFunctions.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

const GLfloat vertices1[] = {0.0000, 1.0000, 0.3153, 0.0000, 0.2972, 1.0000, 0.6125, 0.0000};
const GLfloat vertices2[] = {0.0000, 0.0000, 0.2972, 0.0000, 0.3153, 1.0000, 0.6125, 1.0000};
const GLfloat vertices3[] = {
    0.0000, 0.0000, 0.1252, 0.0000, 0.0801, 0.2541,
    0.1252, 0.0000, 0.2054, 0.2541, 0.0801, 0.2541,
    0.0942, 0.2987, 0.2194, 0.2987, 0.1977, 0.6271,
    0.2194, 0.2987, 0.3230, 0.6271, 0.1977, 0.6271,
    0.2118, 0.6716, 0.3370, 0.6716, 0.3153, 1.0000,
    0.3370, 0.6716, 0.4405, 1.0000, 0.3153, 1.0000,
    0.1720, 0.0000, 0.2972, 0.0000, 0.1917, 0.0625,
    0.2972, 0.0000, 0.3153, 0.0625, 0.1917, 0.0625,
    0.2058, 0.1071, 0.3310, 0.1071, 0.3091, 0.4348,
    0.3310, 0.1071, 0.4344, 0.4348, 0.3091, 0.4348,
    0.3233, 0.4794, 0.4486, 0.4794, 0.4303, 0.8193,
    0.4486, 0.4794, 0.5556, 0.8193, 0.4303, 0.8193,
    0.4444, 0.8639, 0.5696, 0.8639, 0.4873, 1.0000,
    0.5696, 0.8639, 0.6125, 1.0000, 0.4873, 1.0000
};
const GLfloat vertices4[] = {
    0.0779, 1.0000, 0.1578, 0.7468, 0.1247, 1.0000,
    0.1578, 0.7468, 0.2045, 0.7468, 0.1247, 1.0000,
    0.1905, 0.6429, 0.2806, 0.3571, 0.2373, 0.6429,
    0.2806, 0.3571, 0.3274, 0.3571, 0.2373, 0.6429,
    0.3134, 0.2532, 0.3932, 0.0000, 0.3601, 0.2532,
    0.3932, 0.0000, 0.4400, 0.0000, 0.3601, 0.2532
};
const GLfloat colors[] = {
    1.000, 1.000, 1.000, 1.0,
    0.117, 0.486, 0.182, 1.0,
    0.197, 0.571, 0.641, 1.0,
    0.281, 0.281, 0.281, 1.0,
    0.650, 0.650, 0.650, 1.0,
    1.000, 1.000, 1.000, 1.0
};
const GLfloat textPositions[] = {-1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0};
const GLfloat textTexCoords[] = {0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0};

@implementation MyOpenGLView
{
    MyShader *solidShader;
    MyShader *textShader;
    int viewSize[2];
    GLfloat projMat[16];
    GLfloat positions[12]; //4 pieces x 3 dimensions
    GLfloat angles[12];
    GLfloat alpha;
    GLuint texture;
    int texWidth;
    int texHeight;
    NSTimer *animationTimer;
    int count;
    BOOL finishFlag;
    BOOL readFlag;
    NSMutableArray *imageArray;
}

@synthesize delegate;

- (void)awakeFromNib
{
    GLuint attr[] = {
        NSOpenGLPFANoRecovery, //Disable OpenGL's failure recovery mechanism
        NSOpenGLPFAAccelerated, //Only use hardware-accelerated renderers
        NSOpenGLPFADoubleBuffer, //Only use double-buffered pixel formats
        NSOpenGLPFAColorSize, 24, //Color buffer size
        NSOpenGLPFAAlphaSize, 8, //Alpha buffer size
        NSOpenGLPFADepthSize, 32, //Depth buffer size
        NSOpenGLPFASampleBuffers, 1, //Number of multisample buffers
        NSOpenGLPFASamples, 4, //Number of samples per multisample buffer
        0
    };
    NSOpenGLPixelFormat *format = [[NSOpenGLPixelFormat alloc] initWithAttributes:(NSOpenGLPixelFormatAttribute *)attr];
    if(format == nil){
        NSLog(@"Failed creating OpenGL pixel format");
    }
    imageArray = [[NSMutableArray alloc] init];
    [self setPixelFormat:format];
    [self setWantsBestResolutionOpenGLSurface:YES];
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    glEnable(GL_MULTISAMPLE); //Enabled by default, but good practice
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    
    //Setup shaders
    solidShader = [[MyShader alloc] initWithName:@"Solid"];
    [solidShader addPropertyNames:@"position", nil];
    [solidShader addUniformNames:@"matrix", @"color", @"alpha", nil];
    [solidShader loadShaders];
    textShader = [[MyShader alloc] initWithName:@"Text"];
    [textShader addPropertyNames:@"position", @"texCoord", nil];
    [textShader addUniformNames:@"sampler", @"alpha", nil];
    [textShader loadShaders];
    
    //Set view parameters
    NSRect backingRect = [self convertRectToBacking:self.bounds];
    viewSize[0] = (int)round(backingRect.size.width);
    viewSize[1] = (int)round(backingRect.size.height);
    setOrthographicProjectionMatrix(16.0, 9.0, 0.01, 100.0, projMat);
    
    //Texture
    NSImage *textImage = [NSImage imageNamed:@"tex3840"];
    texWidth = 3840;
    texHeight = 2160;
    NSBitmapImageRep *textImageRep = [[NSBitmapImageRep alloc] initWithData:[textImage TIFFRepresentation]];
    unsigned char *bitmapData = [textImageRep bitmapData];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, bitmapData);
    
    memset(positions, 0, 12 * sizeof(GLfloat));
    memset(angles, 0, 12 * sizeof(GLfloat));
    GLfloat offset = 0.275;
    positions[1] += offset;
    positions[4] += offset;
    positions[7] += offset;
    positions[10] += offset;
    alpha = 1.0;
}

- (void)generateMovie
{
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
}

- (void)fireTimer:(NSTimer *)timer
{
    double elapsedTime = (double)count / 60.0;
    if(finishFlag == YES){
        [animationTimer invalidate];
        if([imageArray count] > 0){
            int w = viewSize[0];
            int h = viewSize[1];
            NSError *error = nil;
            NSString *videoPath = [NSHomeDirectory() stringByAppendingString:@"/Desktop/movie4k.mov"];
            if([[NSFileManager defaultManager] fileExistsAtPath:videoPath] == YES){
                [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error];
            }
            AVAssetWriter *videoWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:videoPath] fileType:AVFileTypeQuickTimeMovie error:&error];
            NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                           AVVideoCodecH264, AVVideoCodecKey,
                                           [NSNumber numberWithInt:w], AVVideoWidthKey,
                                           [NSNumber numberWithInt:h], AVVideoHeightKey,
                                           nil];
            AVAssetWriterInput *videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
            AVAssetWriterInputPixelBufferAdaptor *videoInputAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoInput sourcePixelBufferAttributes:nil];
            videoInput.expectsMediaDataInRealTime = YES;
            [videoWriter addInput:videoInput];
            [videoWriter startWriting];
            [videoWriter startSessionAtSourceTime:kCMTimeZero];
            
            for(int i = 0; i < (int)[imageArray count]; i++){
                NSImage *image = [imageArray objectAtIndex:i];
                NSRect imageRect = NSMakeRect(0, 0, w, h);
                CGImageRef cgImage = [image CGImageForProposedRect:&imageRect context:NULL hints:nil];
                NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                         [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                         nil];
                CVPixelBufferRef pixelBuffer;
                CVPixelBufferCreate(NULL, w, h, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options, &pixelBuffer);
                CVPixelBufferLockBaseAddress(pixelBuffer, 0);
                void *pixelData = CVPixelBufferGetBaseAddress(pixelBuffer);
                CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef context = CGBitmapContextCreate(pixelData, w, h, 8, 4 * viewSize[0], rgbColorSpace, kCGImageAlphaNoneSkipFirst);
                CGAffineTransform flipVertical = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, CGImageGetHeight(cgImage));
                CGContextConcatCTM(context, flipVertical);
                CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
                CGColorSpaceRelease(rgbColorSpace);
                CGContextRelease(context);
                CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
                [videoInputAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:CMTimeMake(i, 60)];
                [NSThread sleepForTimeInterval:0.05];
            }
            for(int i = 0; i < (int)[imageArray count]; i++){
                NSImage *image = [imageArray lastObject];
                NSRect imageRect = NSMakeRect(0, 0, w, h);
                CGImageRef cgImage = [image CGImageForProposedRect:&imageRect context:NULL hints:nil];
                NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                         [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                         nil];
                CVPixelBufferRef pixelBuffer;
                CVPixelBufferCreate(NULL, w, h, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options, &pixelBuffer);
                CVPixelBufferLockBaseAddress(pixelBuffer, 0);
                void *pixelData = CVPixelBufferGetBaseAddress(pixelBuffer);
                CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef context = CGBitmapContextCreate(pixelData, w, h, 8, 4 * viewSize[0], rgbColorSpace, kCGImageAlphaNoneSkipFirst);
                CGAffineTransform flipVertical = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, CGImageGetHeight(cgImage));
                CGContextConcatCTM(context, flipVertical);
                CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
                CGColorSpaceRelease(rgbColorSpace);
                CGContextRelease(context);
                CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
                [videoInputAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:CMTimeMake(((int)[imageArray count] + i), 60)];
                [NSThread sleepForTimeInterval:0.05];
            }
            [videoInput markAsFinished];
            [videoWriter finishWritingWithCompletionHandler:^{}];
            if([delegate respondsToSelector:@selector(updateMessage)]){
                [delegate updateMessage];
            }
        }
    }
    else{
        double dt = 1.5 - elapsedTime;
        if(dt >= 0.0){
            GLfloat x = 150.0 * dt;
            positions[0] = 0.01 * x;
            positions[1] = 0.0 * x;
            positions[2] = 0.0 * x;
            positions[3] = 0.0035 * x;
            positions[4] = 0.0065 * x;
            positions[5] = 0.0 * x;
            positions[6] = -0.01 * x;
            positions[7] = 0.0 * x;
            positions[8] = 0.0 * x;
            positions[9] = -0.0035 * x;
            positions[10] = -0.0065 * x;
            positions[11] = 0.0 * x;
            GLfloat y = 50.0 * dt;
            angles[0] = 0.01 * y;
            angles[1] = 0.00 * y;
            angles[2] = 0.005 * y;
            angles[3] = 0.0025 * y;
            angles[4] = 0.0075 * y;
            angles[5] = 0.005 * y;
            angles[6] = -0.01 * y;
            angles[7] = 0.0 * y;
            angles[8] = 0.005 * y;
            angles[9] = -0.0025 * y;
            angles[10] = -0.0075 * y;
            angles[11] = 0.005 * y;
            alpha = 0.0;
        }
        else{
            memset(positions, 0, 12 * sizeof(GLfloat));
            memset(angles, 0, 12 * sizeof(GLfloat));
            alpha = dt / -0.5;
            if(dt < -0.5){
                finishFlag = YES;
            }
        }
        GLfloat offset = 0.275;
        positions[1] += offset;
        positions[4] += offset;
        positions[7] += offset;
        positions[10] += offset;
        count++;
        readFlag = YES;
    }
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    //Text
    glEnable(GL_TEXTURE_2D);
    glUseProgram(textShader.program);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(textShader.uniformLocations[0], 0);
    glUniform1f(textShader.uniformLocations[1], alpha);
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), textPositions);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), textTexCoords);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    
    GLfloat scale = 1.5;
    GLfloat z0 = -10.0;
    GLfloat y0 = -0.4;

    GLfloat whiteColor[] = {1.0, 1.0, 1.0, 1.0};
    GLfloat whiteOffset = 0.067427;

    //Bricks
    GLfloat mvMat1[16];
    setToIdentityMatrix(mvMat1);
    rotateMatrixAlongXAxis(angles[0], mvMat1);
    rotateMatrixAlongYAxis(angles[1], mvMat1);
    rotateMatrixAlongZAxis(angles[2], mvMat1);
    translateMatrix(0.9459 - 0.77922, y0, z0, mvMat1);
    translateMatrix(positions[0], positions[1], positions[2], mvMat1);
    scaleMatrix(scale, mvMat1);
    GLfloat mat1[16];
    multiplyMatrices(projMat, mvMat1, mat1);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, mat1);
    GLfloat color1[] = {colors[0], colors[1], colors[2], colors[3]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color1);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    GLfloat color1b[] = {colors[16], colors[17], colors[18], colors[19]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color1b);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices3);
    glDrawArrays(GL_TRIANGLES, 0, 42);
    glDisableVertexAttribArray(0);
    
    //White strip
    GLfloat whiteMvMat2[16];
    setToIdentityMatrix(whiteMvMat2);
    rotateMatrixAlongXAxis(angles[3], whiteMvMat2);
    rotateMatrixAlongYAxis(angles[4], whiteMvMat2);
    rotateMatrixAlongZAxis(angles[5], whiteMvMat2);
    translateMatrix(0.6306 - 0.77922 + whiteOffset, y0, z0, whiteMvMat2);
    translateMatrix(positions[3], positions[4], positions[5], whiteMvMat2);
    scaleMatrix(scale, whiteMvMat2);
    GLfloat whiteMat2[16];
    multiplyMatrices(projMat, whiteMvMat2, whiteMat2);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, whiteMat2);
    glUniform4fv(solidShader.uniformLocations[1], 1, whiteColor);
    glUniform1f(solidShader.uniformLocations[2], alpha);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //Water
    GLfloat mvMat3[16];
    setToIdentityMatrix(mvMat3);
    rotateMatrixAlongXAxis(angles[6], mvMat3);
    rotateMatrixAlongYAxis(angles[7], mvMat3);
    rotateMatrixAlongZAxis(angles[8], mvMat3);
    translateMatrix(0.6306 - 0.77922, y0, z0, mvMat3);
    translateMatrix(positions[6], positions[7], positions[8], mvMat3);
    scaleMatrix(scale, mvMat3);
    GLfloat mat3[16];
    multiplyMatrices(projMat, mvMat3, mat3);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, mat3);
    GLfloat color3[] = {colors[8], colors[9], colors[10], colors[11]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color3);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //White strip
    GLfloat whiteMvMat3[16];
    setToIdentityMatrix(whiteMvMat3);
    rotateMatrixAlongXAxis(angles[6], whiteMvMat3);
    rotateMatrixAlongYAxis(angles[7], whiteMvMat3);
    rotateMatrixAlongZAxis(angles[8], whiteMvMat3);
    translateMatrix(0.3153 - 0.77922 + whiteOffset, y0, z0, whiteMvMat3);
    translateMatrix(positions[6], positions[7], positions[8], whiteMvMat3);
    scaleMatrix(scale, whiteMvMat3);
    GLfloat whiteMat3[16];
    multiplyMatrices(projMat, whiteMvMat3, whiteMat3);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, whiteMat3);
    glUniform4fv(solidShader.uniformLocations[1], 1, whiteColor);
    glUniform1f(solidShader.uniformLocations[2], alpha);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //Greenery
    GLfloat mvMat2[16];
    setToIdentityMatrix(mvMat2);
    rotateMatrixAlongXAxis(angles[3], mvMat2);
    rotateMatrixAlongYAxis(angles[4], mvMat2);
    rotateMatrixAlongZAxis(angles[5], mvMat2);
    translateMatrix(0.3153 - 0.77922, y0, z0, mvMat2);
    translateMatrix(positions[3], positions[4], positions[5], mvMat2);
    scaleMatrix(scale, mvMat2);
    GLfloat mat2[16];
    multiplyMatrices(projMat, mvMat2, mat2);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, mat2);
    GLfloat color2[] = {colors[4], colors[5], colors[6], colors[7]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color2);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //White strip
    GLfloat whiteMvMat4[16];
    setToIdentityMatrix(whiteMvMat4);
    rotateMatrixAlongXAxis(angles[9], whiteMvMat4);
    rotateMatrixAlongYAxis(angles[10], whiteMvMat4);
    rotateMatrixAlongZAxis(angles[11], whiteMvMat4);
    translateMatrix(-0.77922 + whiteOffset, y0, z0, whiteMvMat4);
    translateMatrix(positions[9], positions[10], positions[11], whiteMvMat4);
    scaleMatrix(scale, whiteMvMat4);
    GLfloat whiteMat4[16];
    multiplyMatrices(projMat, whiteMvMat4, whiteMat4);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, whiteMat4);
    glUniform4fv(solidShader.uniformLocations[1], 1, whiteColor);
    glUniform1f(solidShader.uniformLocations[2], alpha);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //Asphalt
    GLfloat mvMat4[16];
    setToIdentityMatrix(mvMat4);
    rotateMatrixAlongXAxis(angles[9], mvMat4);
    rotateMatrixAlongYAxis(angles[10], mvMat4);
    rotateMatrixAlongZAxis(angles[11], mvMat4);
    translateMatrix(-0.77922, y0, z0, mvMat4);
    translateMatrix(positions[9], positions[10], positions[11], mvMat4);
    scaleMatrix(scale, mvMat4);
    GLfloat mat4[16];
    multiplyMatrices(projMat, mvMat4, mat4);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, mat4);
    GLfloat color4[] = {colors[12], colors[13], colors[14], colors[15]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color4);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    GLfloat color4b[] = {colors[20], colors[21], colors[22], colors[23]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color4b);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, (2 * sizeof(GLfloat)), vertices4);
    glDrawArrays(GL_TRIANGLES, 0, 18);
    glDisableVertexAttribArray(0);
   
    if(readFlag == YES){
        //Read pixels
        int w = viewSize[0];
        int h = viewSize[1];
        unsigned char *bitmapData1 = (unsigned char *)calloc(3 * w * h, sizeof(unsigned char));
        glReadPixels(0, 0, w, h, GL_RGB, GL_UNSIGNED_BYTE, bitmapData1);
        unsigned char *bitmapData2 = (unsigned char *)calloc(4 * w * h, sizeof(unsigned char));
        for(int i = 0; i < w; i++){
            for(int j = 0; j < h; j++){
                int index = (j * w) + i;
                bitmapData2[4 * index] = bitmapData1[3 * index];
                bitmapData2[(4 * index) + 1] = bitmapData1[(3 * index) + 1];
                bitmapData2[(4 * index) + 2] = bitmapData1[(3 * index) + 2];
                bitmapData2[(4 * index) + 3] = 255;
            }
        }
        NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&bitmapData2
                                                                             pixelsWide:w
                                                                             pixelsHigh:h
                                                                          bitsPerSample:8
                                                                        samplesPerPixel:4
                                                                               hasAlpha:YES
                                                                               isPlanar:NO
                                                                         colorSpaceName:NSCalibratedRGBColorSpace
                                                                            bytesPerRow:4 * w
                                                                           bitsPerPixel:32];
        NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
        [image addRepresentation:imageRep];
        [imageArray addObject:image];
        readFlag = NO;
    }
    
    [[self openGLContext] flushBuffer];
}

@end
