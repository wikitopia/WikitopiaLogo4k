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

const GLfloat vertices1[] = {0.000, 1.0, 0.0, 0.306, 0.0, 0.0, 0.286, 1.0, 0.0, 0.594, 0.0, 0.0};
const GLfloat vertices2[] = {0.000, 0.0, 0.0, 0.306, 1.0, 0.0, 0.286, 0.0, 0.0, 0.594, 1.0, 0.0};
const GLfloat vertices3[] = {
    0.000, 1.000, 0.0, 0.028, 0.902, 0.0, 0.076, 1.000, 0.0,
    0.076, 1.000, 0.0, 0.028, 0.902, 0.0, 0.099, 0.923, 0.0,
    0.035, 0.879, 0.0, 0.089, 0.704, 0.0, 0.106, 0.901, 0.0,
    0.106, 0.901, 0.0, 0.089, 0.704, 0.0, 0.160, 0.725, 0.0,
    0.097, 0.681, 0.0, 0.151, 0.505, 0.0, 0.167, 0.702, 0.0,
    0.167, 0.702, 0.0, 0.151, 0.505, 0.0, 0.221, 0.527, 0.0,
    0.157, 0.483, 0.0, 0.209, 0.311, 0.0, 0.228, 0.504, 0.0,
    0.228, 0.504, 0.0, 0.209, 0.311, 0.0, 0.280, 0.332, 0.0,
    0.217, 0.287, 0.0, 0.270, 0.115, 0.0, 0.288, 0.309, 0.0,
    0.288, 0.309, 0.0, 0.270, 0.115, 0.0, 0.341, 0.136, 0.0,
    0.277, 0.092, 0.0, 0.306, 0.000, 0.0, 0.348, 0.113, 0.0,
    0.348, 0.113, 0.0, 0.306, 0.000, 0.0, 0.382, 0.000, 0.0,
    0.101, 1.000, 0.0, 0.152, 0.832, 0.0, 0.183, 1.000, 0.0,
    0.183, 1.000, 0.0, 0.152, 0.832, 0.0, 0.228, 0.855, 0.0,
    0.160, 0.809, 0.0, 0.213, 0.634, 0.0, 0.234, 0.832, 0.0,
    0.234, 0.832, 0.0, 0.213, 0.634, 0.0, 0.289, 0.656, 0.0,
    0.220, 0.611, 0.0, 0.274, 0.436, 0.0, 0.295, 0.633, 0.0,
    0.295, 0.633, 0.0, 0.274, 0.436, 0.0, 0.349, 0.460, 0.0,
    0.281, 0.413, 0.0, 0.333, 0.241, 0.0, 0.356, 0.436, 0.0,
    0.356, 0.436, 0.0, 0.333, 0.241, 0.0, 0.409, 0.263, 0.0,
    0.341, 0.217, 0.0, 0.393, 0.044, 0.0, 0.415, 0.240, 0.0,
    0.415, 0.240, 0.0, 0.393, 0.044, 0.0, 0.468, 0.066, 0.0,
    0.400, 0.021, 0.0, 0.407, 0.000, 0.0, 0.475, 0.043, 0.0,
    0.475, 0.043, 0.0, 0.407, 0.000, 0.0, 0.489, 0.000, 0.0,
    0.207, 1.000, 0.0, 0.220, 0.960, 0.0, 0.286, 1.000, 0.0,
    0.286, 1.000, 0.0, 0.220, 0.960, 0.0, 0.292, 0.982, 0.0,
    0.227, 0.937, 0.0, 0.280, 0.762, 0.0, 0.299, 0.959, 0.0,
    0.299, 0.959, 0.0, 0.280, 0.762, 0.0, 0.353, 0.785, 0.0,
    0.288, 0.738, 0.0, 0.341, 0.563, 0.0, 0.360, 0.762, 0.0,
    0.360, 0.762, 0.0, 0.341, 0.563, 0.0, 0.414, 0.586, 0.0,
    0.348, 0.540, 0.0, 0.400, 0.368, 0.0, 0.422, 0.563, 0.0,
    0.422, 0.563, 0.0, 0.400, 0.368, 0.0, 0.474, 0.392, 0.0,
    0.408, 0.345, 0.0, 0.461, 0.172, 0.0, 0.481, 0.368, 0.0,
    0.481, 0.368, 0.0, 0.461, 0.172, 0.0, 0.535, 0.195, 0.0,
    0.468, 0.148, 0.0, 0.514, 0.000, 0.0, 0.542, 0.172, 0.0,
    0.542, 0.172, 0.0, 0.514, 0.000, 0.0, 0.594, 0.000, 0.0
};
const GLfloat vertices4[] = {
    0.529333, 1.000, 0.0, 0.509333, 0.936, 0.0, 0.492333, 1.000, 0.0,
    0.492333, 1.000, 0.0, 0.509333, 0.936, 0.0, 0.476333, 0.947, 0.0,
    0.481333, 0.843, 0.0, 0.417333, 0.635, 0.0, 0.447333, 0.854, 0.0,
    0.447333, 0.854, 0.0, 0.417333, 0.635, 0.0, 0.384333, 0.646, 0.0,
    0.392333, 0.553, 0.0, 0.329333, 0.345, 0.0, 0.358333, 0.563, 0.0,
    0.358333, 0.563, 0.0, 0.329333, 0.345, 0.0, 0.295333, 0.355, 0.0,
    0.303333, 0.262, 0.0, 0.240333, 0.054, 0.0, 0.269333, 0.272, 0.0,
    0.269333, 0.272, 0.0, 0.240333, 0.054, 0.0, 0.206333, 0.064, 0.0
};
const GLfloat colors[] = {
    1.000, 1.000, 1.000, 1.0,
    0.231, 0.694, 0.286, 1.0,
    0.545, 0.839, 0.933, 1.0,
    0.310, 0.310, 0.310, 1.0,
    0.651, 0.647, 0.647, 1.0,
    0.950, 0.950, 0.950, 1.0
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
    glEnable(GL_MULTISAMPLE); //Enabled by default, but good practice
    glCullFace(GL_BACK);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
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
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGB, GL_UNSIGNED_BYTE, bitmapData);
    
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
    GLfloat y0 = -0.5;
    
    //Asphalt
    GLfloat mvMat4[16];
    setToIdentityMatrix(mvMat4);
    rotateMatrixAlongXAxis(angles[9], mvMat4);
    rotateMatrixAlongYAxis(angles[10], mvMat4);
    rotateMatrixAlongZAxis(angles[11], mvMat4);
    translateMatrix(0.919 - 0.75616667, y0, z0, mvMat4);
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    GLfloat color4b[] = {colors[20], colors[21], colors[22], colors[23]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color4b);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices4);
    glDrawArrays(GL_TRIANGLES, 0, 24);
    glDisableVertexAttribArray(0);
    
    //White strip
    GLfloat whiteMvMat4[16];
    setToIdentityMatrix(whiteMvMat4);
    rotateMatrixAlongXAxis(angles[9], whiteMvMat4);
    rotateMatrixAlongYAxis(angles[10], whiteMvMat4);
    rotateMatrixAlongZAxis(angles[11], whiteMvMat4);
    translateMatrix(0.612667 - 0.75616667 + 0.029, y0, z0, whiteMvMat4);
    translateMatrix(positions[9], positions[10], positions[11], whiteMvMat4);
    scaleMatrix(scale, whiteMvMat4);
    GLfloat whiteMat4[16];
    multiplyMatrices(projMat, whiteMvMat4, whiteMat4);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, whiteMat4);
    GLfloat whiteColor[] = {1.0, 1.0, 1.0, 1.0};
    glUniform4fv(solidShader.uniformLocations[1], 1, whiteColor);
    glUniform1f(solidShader.uniformLocations[2], alpha);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //Water
    GLfloat mvMat3[16];
    setToIdentityMatrix(mvMat3);
    rotateMatrixAlongXAxis(angles[6], mvMat3);
    rotateMatrixAlongYAxis(angles[7], mvMat3);
    rotateMatrixAlongZAxis(angles[8], mvMat3);
    translateMatrix(0.612667 - 0.75616667, y0, z0, mvMat3);
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //White strip
    GLfloat whiteMvMat3[16];
    setToIdentityMatrix(whiteMvMat3);
    rotateMatrixAlongXAxis(angles[6], whiteMvMat3);
    rotateMatrixAlongYAxis(angles[7], whiteMvMat3);
    rotateMatrixAlongZAxis(angles[8], whiteMvMat3);
    translateMatrix(0.306333 - 0.75616667 + 0.029, y0, z0, whiteMvMat3);
    translateMatrix(positions[6], positions[7], positions[8], whiteMvMat3);
    scaleMatrix(scale, whiteMvMat3);
    GLfloat whiteMat3[16];
    multiplyMatrices(projMat, whiteMvMat3, whiteMat3);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, whiteMat3);
    glUniform4fv(solidShader.uniformLocations[1], 1, whiteColor);
    glUniform1f(solidShader.uniformLocations[2], alpha);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //Greenery
    GLfloat mvMat2[16];
    setToIdentityMatrix(mvMat2);
    rotateMatrixAlongXAxis(angles[3], mvMat2);
    rotateMatrixAlongYAxis(angles[4], mvMat2);
    rotateMatrixAlongZAxis(angles[5], mvMat2);
    translateMatrix(0.306333 - 0.75616667, y0, z0, mvMat2);
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //White strip
    GLfloat whiteMvMat2[16];
    setToIdentityMatrix(whiteMvMat2);
    rotateMatrixAlongXAxis(angles[3], whiteMvMat2);
    rotateMatrixAlongYAxis(angles[4], whiteMvMat2);
    rotateMatrixAlongZAxis(angles[5], whiteMvMat2);
    translateMatrix(-0.75616667 + 0.029, y0, z0, whiteMvMat2);
    translateMatrix(positions[3], positions[4], positions[5], whiteMvMat2);
    scaleMatrix(scale, whiteMvMat2);
    GLfloat whiteMat2[16];
    multiplyMatrices(projMat, whiteMvMat2, whiteMat2);
    glUseProgram(solidShader.program);
    glUniformMatrix4fv(solidShader.uniformLocations[0], 1, false, whiteMat2);
    glUniform4fv(solidShader.uniformLocations[1], 1, whiteColor);
    glUniform1f(solidShader.uniformLocations[2], alpha);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    
    //Bricks
    GLfloat mvMat1[16];
    setToIdentityMatrix(mvMat1);
    rotateMatrixAlongXAxis(angles[0], mvMat1);
    rotateMatrixAlongYAxis(angles[1], mvMat1);
    rotateMatrixAlongZAxis(angles[2], mvMat1);
    translateMatrix(-0.75616667, y0, z0, mvMat1);
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices1);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(0);
    GLfloat color1b[] = {colors[16], colors[17], colors[18], colors[19]};
    glUniform4fv(solidShader.uniformLocations[1], 1, color1b);
    glUniform1f(solidShader.uniformLocations[2], 1.0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, (3 * sizeof(GLfloat)), vertices3);
    glDrawArrays(GL_TRIANGLES, 0, 108);
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
