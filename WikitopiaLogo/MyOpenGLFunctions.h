//
//  MyOpenGLFunctions.h
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>

//Basic matrix calculations
void setToIdentityMatrix(GLfloat *mat);
void multiplyMatrices(GLfloat *mat1, GLfloat *mat2, GLfloat *outMat);
void copyMatrix(GLfloat *fromMat, GLfloat *toMat);
void scaleMatrix(GLfloat k, GLfloat *mat);
void translateMatrix(GLfloat dx, GLfloat dy, GLfloat dz, GLfloat *mat);
void rotateMatrixAlongXAxis(GLfloat radAngle, GLfloat *mat);
void rotateMatrixAlongYAxis(GLfloat radAngle, GLfloat *mat);
void rotateMatrixAlongZAxis(GLfloat radAngle, GLfloat *mat);
void inverseMatrix(GLfloat *mat);
void multiplyVectorByMatrix(GLfloat *vec, GLfloat *mat, GLfloat *outVec);
void multiplyMatrixByVector(GLfloat *mat, GLfloat *vec, GLfloat *outVec);

//Projection
void setFrustumProjectionMatrix(GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat nearVal, GLfloat farVal, GLfloat *mat);
void setPerspectiveProjectionMatrix(GLfloat yFov, GLfloat nearVal, GLfloat farVal, GLfloat aspectRatio, GLfloat *mat);
void setOrthographicProjectionMatrix(GLfloat width, GLfloat height, GLfloat nearVal, GLfloat farVal, GLfloat *mat);
