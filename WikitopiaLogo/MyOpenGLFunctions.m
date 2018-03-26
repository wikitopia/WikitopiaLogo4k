//
//  MyOpenGLFunctions.m
//  WikitopiaLogo
//
//  Created by YUICHIRO TAKEUCHI on 3/9/18.
//  Copyright © 2018 YUICHIRO TAKEUCHI. All rights reserved.
//

#import "MyOpenGLFunctions.h"

// 0   4   8  12
//
// 1   5   9  13
//
// 2   6  10  14
//
// 3   7  11  15


//Basic matrix calculations

void setToIdentityMatrix(GLfloat *mat)
{
    for(int i = 0; i < 16; i++){
        mat[i] = 0.0;
    }
    mat[0] = 1.0;
    mat[5] = 1.0;
    mat[10] = 1.0;
    mat[15] = 1.0;
}

void multiplyMatrices(GLfloat *mat1, GLfloat *mat2, GLfloat *outMat)
{
    //First column
    outMat[0] = (mat1[0] * mat2[0]) + (mat1[4] * mat2[1]) + (mat1[8] * mat2[2]) + (mat1[12] * mat2[3]);
    outMat[1] = (mat1[1] * mat2[0]) + (mat1[5] * mat2[1]) + (mat1[9] * mat2[2]) + (mat1[13] * mat2[3]);
    outMat[2] = (mat1[2] * mat2[0]) + (mat1[6] * mat2[1]) + (mat1[10] * mat2[2]) + (mat1[14] * mat2[3]);
    outMat[3] = (mat1[3] * mat2[0]) + (mat1[7] * mat2[1]) + (mat1[11] * mat2[2]) + (mat1[15] * mat2[3]);
    //Second column
    outMat[4] = (mat1[0] * mat2[4]) + (mat1[4] * mat2[5]) + (mat1[8] * mat2[6]) + (mat1[12] * mat2[7]);
    outMat[5] = (mat1[1] * mat2[4]) + (mat1[5] * mat2[5]) + (mat1[9] * mat2[6]) + (mat1[13] * mat2[7]);
    outMat[6] = (mat1[2] * mat2[4]) + (mat1[6] * mat2[5]) + (mat1[10] * mat2[6]) + (mat1[14] * mat2[7]);
    outMat[7] = (mat1[3] * mat2[4]) + (mat1[7] * mat2[5]) + (mat1[11] * mat2[6]) + (mat1[15] * mat2[7]);
    //Third column
    outMat[8] = (mat1[0] * mat2[8]) + (mat1[4] * mat2[9]) + (mat1[8] * mat2[10]) + (mat1[12] * mat2[11]);
    outMat[9] = (mat1[1] * mat2[8]) + (mat1[5] * mat2[9]) + (mat1[9] * mat2[10]) + (mat1[13] * mat2[11]);
    outMat[10] = (mat1[2] * mat2[8]) + (mat1[6] * mat2[9]) + (mat1[10] * mat2[10]) + (mat1[14] * mat2[11]);
    outMat[11] = (mat1[3] * mat2[8]) + (mat1[7] * mat2[9]) + (mat1[11] * mat2[10]) + (mat1[15] * mat2[11]);
    //Fourth column
    outMat[12] = (mat1[0] * mat2[12]) + (mat1[4] * mat2[13]) + (mat1[8] * mat2[14]) + (mat1[12] * mat2[15]);
    outMat[13] = (mat1[1] * mat2[12]) + (mat1[5] * mat2[13]) + (mat1[9] * mat2[14]) + (mat1[13] * mat2[15]);
    outMat[14] = (mat1[2] * mat2[12]) + (mat1[6] * mat2[13]) + (mat1[10] * mat2[14]) + (mat1[14] * mat2[15]);
    outMat[15] = (mat1[3] * mat2[12]) + (mat1[7] * mat2[13]) + (mat1[11] * mat2[14]) + (mat1[15] * mat2[15]);
}

void copyMatrix(GLfloat *fromMat, GLfloat *toMat)
{
    for(int i = 0; i < 16; i++){
        toMat[i] = fromMat[i];
    }
}

void scaleMatrix(GLfloat k, GLfloat *mat)
{
    GLfloat scale[16];
    setToIdentityMatrix(scale);
    scale[0] = k;
    scale[5] = k;
    scale[10] = k;
    scale[15] = 1.0;
    GLfloat newMat[16];
    multiplyMatrices(scale, mat, newMat);
    copyMatrix(newMat, mat);
}

void translateMatrix(GLfloat dx, GLfloat dy, GLfloat dz, GLfloat *mat)
{
    GLfloat trans[16];
    setToIdentityMatrix(trans);
    trans[12] = dx;
    trans[13] = dy;
    trans[14] = dz;
    GLfloat newMat[16];
    multiplyMatrices(trans, mat, newMat);
    copyMatrix(newMat, mat);
}

void rotateMatrixAlongXAxis(GLfloat radAngle, GLfloat *mat)
{
    GLfloat sinVal = sinf(radAngle);
    GLfloat cosVal = cosf(radAngle);
    GLfloat rot[16];
    for(int i = 0; i < 16; i++){
        rot[i] = 0.0;
    }
    rot[0] = 1.0;
    rot[5] = cosVal;
    rot[6] = sinVal;
    rot[9] = -1.0 * sinVal;
    rot[10] = cosVal;
    rot[15] = 1.0;
    GLfloat newMat[16];
    multiplyMatrices(rot, mat, newMat);
    copyMatrix(newMat, mat);
}

void rotateMatrixAlongYAxis(GLfloat radAngle, GLfloat *mat)
{
    GLfloat sinVal = sinf(radAngle);
    GLfloat cosVal = cosf(radAngle);
    GLfloat rot[16];
    for(int i = 0; i < 16; i++){
        rot[i] = 0.0;
    }
    rot[0] = cosVal;
    rot[2] = -1.0 * sinVal;
    rot[5] = 1.0;
    rot[8] = sinVal;
    rot[10] = cosVal;
    rot[15] = 1.0;
    GLfloat newMat[16];
    multiplyMatrices(rot, mat, newMat);
    copyMatrix(newMat, mat);
}

void rotateMatrixAlongZAxis(GLfloat radAngle, GLfloat *mat)
{
    GLfloat sinVal = sinf(radAngle);
    GLfloat cosVal = cosf(radAngle);
    GLfloat rot[16];
    for(int i = 0; i < 16; i++){
        rot[i] = 0.0;
    }
    rot[0] = cosVal;
    rot[1] = sinVal;
    rot[4] = -1.0 * sinVal;
    rot[5] = cosVal;
    rot[10] = 1.0;
    rot[15] = 1.0;
    GLfloat newMat[16];
    multiplyMatrices(rot, mat, newMat);
    copyMatrix(newMat, mat);
}

void inverseMatrix(GLfloat *mat)
{
    GLfloat det = 0.0;
    det += (mat[0]  * mat[5]  * mat[10] * mat[15]) + (mat[0]  * mat[9]  * mat[14] * mat[7])  + (mat[0]  * mat[13] * mat[6]  * mat[11]);
    det += (mat[4]  * mat[1]  * mat[14] * mat[11]) + (mat[4]  * mat[9]  * mat[2]  * mat[15]) + (mat[4]  * mat[13] * mat[10] * mat[3]);
    det += (mat[8]  * mat[1]  * mat[6]  * mat[15]) + (mat[8]  * mat[5]  * mat[14] * mat[3])  + (mat[8]  * mat[13] * mat[2]  * mat[7]);
    det += (mat[12] * mat[1]  * mat[10] * mat[7])  + (mat[12] * mat[5]  * mat[2]  * mat[11]) + (mat[12] * mat[9]  * mat[6]  * mat[3]);
    det -= (mat[0]  * mat[5]  * mat[14] * mat[11]) + (mat[0]  * mat[9]  * mat[6]  * mat[15]) + (mat[0]  * mat[13] * mat[10] * mat[7]);
    det -= (mat[4]  * mat[1]  * mat[10] * mat[15]) + (mat[4]  * mat[9]  * mat[14] * mat[3])  + (mat[4]  * mat[13] * mat[2]  * mat[11]);
    det -= (mat[8]  * mat[1]  * mat[14] * mat[7])  + (mat[8]  * mat[5]  * mat[2]  * mat[15]) + (mat[8]  * mat[13] * mat[6]  * mat[3]);
    det -= (mat[12] * mat[1]  * mat[6]  * mat[11]) + (mat[12] * mat[5]  * mat[10] * mat[3])  + (mat[12] * mat[9]  * mat[2]  * mat[7]);
    if(det != 0){
        GLfloat newMat[16];
        for(int i = 0; i < 16; i++){
            newMat[i] = 0.0;
        }
        newMat[0]  += (mat[5]  * mat[10] * mat[15]) + (mat[9]  * mat[14] * mat[7])  + (mat[13] * mat[6]  * mat[11]);
        newMat[0]  -= (mat[5]  * mat[14] * mat[11]) + (mat[9]  * mat[6]  * mat[15]) + (mat[13] * mat[10] * mat[7]);
        newMat[1]  += (mat[1]  * mat[14] * mat[11]) + (mat[9]  * mat[2]  * mat[15]) + (mat[13] * mat[10] * mat[3]);
        newMat[1]  -= (mat[1]  * mat[10] * mat[15]) + (mat[9]  * mat[14] * mat[3])  + (mat[13] * mat[2]  * mat[11]);
        newMat[2]  += (mat[1]  * mat[6]  * mat[15]) + (mat[5]  * mat[14] * mat[3])  + (mat[13] * mat[2]  * mat[7]);
        newMat[2]  -= (mat[1]  * mat[14] * mat[7])  + (mat[5]  * mat[2]  * mat[15]) + (mat[13] * mat[6]  * mat[3]);
        newMat[3]  += (mat[1]  * mat[10] * mat[7])  + (mat[5]  * mat[2]  * mat[11]) + (mat[9]  * mat[6]  * mat[3]);
        newMat[3]  -= (mat[1]  * mat[6]  * mat[11]) + (mat[5]  * mat[10] * mat[3])  + (mat[9]  * mat[2]  * mat[7]);
        newMat[4]  += (mat[4]  * mat[14] * mat[11]) + (mat[8]  * mat[6]  * mat[15]) + (mat[12] * mat[10] * mat[7]);
        newMat[4]  -= (mat[4]  * mat[10] * mat[15]) + (mat[8]  * mat[14] * mat[7])  + (mat[12] * mat[6]  * mat[11]);
        newMat[5]  += (mat[0]  * mat[10] * mat[15]) + (mat[8]  * mat[14] * mat[3])  + (mat[12] * mat[2]  * mat[11]);
        newMat[5]  -= (mat[0]  * mat[14] * mat[11]) + (mat[8]  * mat[2]  * mat[15]) + (mat[12] * mat[10] * mat[3]);
        newMat[6]  += (mat[0]  * mat[14] * mat[7])  + (mat[4]  * mat[2]  * mat[15]) + (mat[12] * mat[6]  * mat[3]);
        newMat[6]  -= (mat[0]  * mat[6]  * mat[15]) + (mat[4]  * mat[14] * mat[3])  + (mat[12] * mat[2]  * mat[7]);
        newMat[7]  += (mat[0]  * mat[6]  * mat[11]) + (mat[4]  * mat[10] * mat[3])  + (mat[8]  * mat[2]  * mat[7]);
        newMat[7]  -= (mat[0]  * mat[10] * mat[7])  + (mat[4]  * mat[2]  * mat[11]) + (mat[8]  * mat[6]  * mat[3]);
        newMat[8]  += (mat[4]  * mat[9]  * mat[15]) + (mat[8]  * mat[13] * mat[7])  + (mat[12] * mat[5]  * mat[11]);
        newMat[8]  -= (mat[4]  * mat[13] * mat[11]) + (mat[8]  * mat[5]  * mat[15]) + (mat[12] * mat[9]  * mat[7]);
        newMat[9]  += (mat[0]  * mat[13] * mat[11]) + (mat[8]  * mat[1]  * mat[15]) + (mat[12] * mat[9]  * mat[3]);
        newMat[9]  -= (mat[0]  * mat[9]  * mat[15]) + (mat[8]  * mat[13] * mat[3])  + (mat[12] * mat[1]  * mat[11]);
        newMat[10] += (mat[0]  * mat[5]  * mat[15]) + (mat[4]  * mat[13] * mat[3])  + (mat[12] * mat[1]  * mat[7]);
        newMat[10] -= (mat[0]  * mat[13] * mat[7])  + (mat[4]  * mat[1]  * mat[15]) + (mat[12] * mat[5]  * mat[3]);
        newMat[11] += (mat[0]  * mat[9]  * mat[7])  + (mat[4]  * mat[1]  * mat[11]) + (mat[8]  * mat[5]  * mat[3]);
        newMat[11] -= (mat[0]  * mat[5]  * mat[11]) + (mat[4]  * mat[9]  * mat[3])  + (mat[8]  * mat[1]  * mat[7]);
        newMat[12] += (mat[4]  * mat[13] * mat[10]) + (mat[8]  * mat[5]  * mat[14]) + (mat[12] * mat[9]  * mat[6]);
        newMat[12] -= (mat[4]  * mat[9]  * mat[14]) + (mat[8]  * mat[13] * mat[6])  + (mat[12] * mat[5]  * mat[10]);
        newMat[13] += (mat[0]  * mat[9]  * mat[14]) + (mat[8]  * mat[13] * mat[2])  + (mat[12] * mat[1]  * mat[10]);
        newMat[13] -= (mat[0]  * mat[13] * mat[10]) + (mat[8]  * mat[1]  * mat[14]) + (mat[12] * mat[9]  * mat[2]);
        newMat[14] += (mat[0]  * mat[13] * mat[6])  + (mat[4]  * mat[1]  * mat[14]) + (mat[12] * mat[5]  * mat[2]);
        newMat[14] -= (mat[0]  * mat[5]  * mat[14]) + (mat[4]  * mat[13] * mat[2])  + (mat[12] * mat[1]  * mat[6]);
        newMat[15] += (mat[0]  * mat[5]  * mat[10]) + (mat[4]  * mat[9]  * mat[2])  + (mat[8]  * mat[1]  * mat[6]);
        newMat[15] -= (mat[0]  * mat[9]  * mat[6])  + (mat[4]  * mat[1]  * mat[10]) + (mat[8]  * mat[5]  * mat[2]);
        copyMatrix(newMat, mat);
    }
}

void multiplyVectorByMatrix(GLfloat *vec, GLfloat *mat, GLfloat *outVec)
{
    for(int i = 0; i < 4; i++){
        outVec[i] = 0.0;
        for(int j = 0; j < 4; j++){
            outVec[i] += vec[j] * mat[(4 * i) + j];
        }
    }
}

void multiplyMatrixByVector(GLfloat *mat, GLfloat *vec, GLfloat *outVec)
{
    for(int i = 0; i < 4; i++){
        outVec[i] = 0.0;
        for(int j = 0; j < 4; j++){
            outVec[i] += vec[j] * mat[(4 * j) + i];
        }
    }
}


//Projection

void setFrustumProjectionMatrix(GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat nearVal, GLfloat farVal, GLfloat *mat)
{
    for(int i = 0; i < 16; i++){
        mat[i] = 0.0;
    }
    mat[0] = (2.0 * nearVal) / (right - left);
    mat[5] = (2.0 * nearVal) / (top - bottom);
    mat[8] = (right + left) / (right - left);
    mat[9] = (top + bottom) / (top - bottom);
    mat[10] = -1.0 * (farVal + nearVal) / (farVal - nearVal);
    mat[11] = -1.0;
    mat[14] = -2.0 * farVal * nearVal / (farVal - nearVal);
}

void setPerspectiveProjectionMatrix(GLfloat yFov, GLfloat nearVal, GLfloat farVal, GLfloat aspectRatio, GLfloat *mat)
{
    GLfloat top = nearVal * tanf(yFov / 2.0);
    GLfloat right = top * aspectRatio;
    GLfloat bottom = -1.0 * top;
    GLfloat left = -1.0 * right;
    setFrustumProjectionMatrix(left, right, bottom, top, nearVal, farVal, mat);
}

void setOrthographicProjectionMatrix(GLfloat width, GLfloat height, GLfloat nearVal, GLfloat farVal, GLfloat *mat)
{
    for(int i = 0; i < 16; i++){
        mat[i] = 0.0;
    }
    GLfloat top = 0.5 * height;
    GLfloat bottom = -0.5 * height;
    GLfloat left = -0.5 * width;
    GLfloat right = 0.5 * width;
    mat[0] = 2.0 / (right - left);
    mat[5] = 2.0 / (top - bottom);
    mat[10] = -2.0 / (farVal - nearVal);
    mat[14] = -1.0 * (farVal + nearVal) / (farVal - nearVal);
    mat[15] = 1.0;
}
