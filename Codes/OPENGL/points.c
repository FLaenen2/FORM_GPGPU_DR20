#include <GL/glut.h>
#include <stdlib.h>  
#include <time.h>
#include <string.h>
#define N 100

float *x, *y;

void gldrawPoints(){

   // glScalef(3., 3., 1.);
    glBegin(GL_POINTS);
    for (int i = 0; i < N; i++){
	glVertex2f((GLfloat) x[i], (GLfloat) y[i]);
    }
    glEnd();

}



void
output(int x, int y, char *str1)
{
  int len, i;

  glRasterPos2f(x, y);
  len = (int) strlen(str1);
  for (i = 0; i < len; i++) {
    glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, str1[i]);
  }
    //char *str2 = "Stroked";
    //glScalef(3., 3., 1.);
    //glutStrokeString(GLUT_STROKE_ROMAN, str2);
}

void display(){

    glColor3f(0.0f,0.0f,1.0f); //blue color
    glPointSize(10.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  gldrawPoints();
    //output(2, 2, "Hello");
  glutSwapBuffers();

}

void
reshape(int w, int h)
{
  //glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  //gluOrtho2D(0, w, h, 0);
  glMatrixMode(GL_MODELVIEW);
}

void drawPoints(float *x, float *y, int n){
 
     glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutCreateWindow("Test points array");
    glEnable(GL_POINT_SMOOTH);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMainLoop();
    
}


int main(int argc, char** argv){

    srand(time(NULL));
    x = malloc(N*sizeof(float));
    y = malloc(N*sizeof(float));
    for (int i = 0; i < N; i++){
	x[i] = (float)2.0*rand()/RAND_MAX-1;
	y[i] = (float)2.0*rand()/RAND_MAX-1;
    }
    glutInit(&argc, argv);
    drawPoints(x, y, N);
    return 0;
}
