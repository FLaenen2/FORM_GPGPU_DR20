#include <GL/glut.h>
#include <stdlib.h>  
#include <time.h>

#define checkImageWidth 64
#define checkImageHeight 64
#define N 100

static GLubyte checkImage[checkImageHeight][checkImageWidth][4];
GLfloat myImage[checkImageHeight][checkImageWidth];
static GLfloat myImage2[checkImageHeight][checkImageWidth][3];
GLuint texture1;

void makemyImage(void)
{
   int i, j, c;
    
   for (i = 0; i < checkImageHeight; i++) {
      for (j = 0; j < checkImageWidth; j++) {
         myImage[i][j] = (float)i / checkImageHeight;
        // myImage[i][j][1] = 0;
         //myImage[i][j][1] = (float)j / checkImageWidth;
         //myImage[i][j][2] = 0;
        // myImage[i][j][3] = (GLubyte) 255;
      }
   }
}

void makeCheckImage(void)
{
   int i, j, c;
    
   for (i = 0; i < checkImageHeight; i++) {
      for (j = 0; j < checkImageWidth; j++) {
         c = ((((i&0x8)==0)^((j&0x8))==0))*255;
         checkImage[i][j][0] = (GLubyte) c;
         checkImage[i][j][1] = (GLubyte) c;
         checkImage[i][j][2] = (GLubyte) c;
         checkImage[i][j][3] = (GLubyte) 255;
      }
   }
}

void display(){

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_TEXTURE_2D);
   // glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
    glBindTexture(GL_TEXTURE_2D, texture1);
   // glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    //glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    glBegin(GL_QUADS);
   // glTexCoord2d(0,1);  glVertex3d(1,1,1);
   // glTexCoord2d(0,0);  glVertex3d(1,1,-1);
  //  glTexCoord2d(1,0);  glVertex3d(-1,1,-1);
 //   glTexCoord2d(1,1);  glVertex3d(-1,1,1);    
   glTexCoord2f(0.0, 0.0); glVertex2i(-1, -1);
   glTexCoord2i(0, 1); glVertex2i(-1, 1);
   glTexCoord2i(1, 1); glVertex2i(1, 1);
   glTexCoord2i(1, 0); glVertex2i(1, -1);

   //glTexCoord2f(0.0, 0.0); glVertex3f(1.0, -1.0, 0.0);
   //glTexCoord2f(0.0, 1.0); glVertex3f(1.0, 1.0, 0.0);
   //glTexCoord2f(1.0, 1.0); glVertex3f(2.41421, 1.0, -1.41421);
    glEnd();
    glutSwapBuffers();
    glDisable(GL_TEXTURE_2D);

}

void drawTex(){
 
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
   glutInitWindowSize(250, 250);
   glutInitWindowPosition(100, 100);
    glutCreateWindow("Test texture array");

    glClearColor (0.0, 0.0, 0.0, 0.0);
    
    glGenTextures(1, &texture1);
    glBindTexture(GL_TEXTURE_2D, texture1);

    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
   
   //glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, checkImageWidth, 
   //             checkImageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, 
    //            checkImage);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, checkImageWidth, 
                checkImageHeight, 0, GL_RED, GL_FLOAT, 
                myImage);
 
    glutDisplayFunc(display);
    glutMainLoop();
    
}


int main(int argc, char** argv){

    srand(time(NULL));
    makeCheckImage();
    makemyImage();
    glutInit(&argc, argv);
    drawTex();
    return 0;
}
