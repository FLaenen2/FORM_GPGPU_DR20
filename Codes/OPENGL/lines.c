#include <GL/glut.h>
#include <stdlib.h>  
#include <time.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
#define N 100
#define eps 0.05
float *x, *y;

void
reshape(int w, int h)
{
  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(0, w, h, 0);
  glMatrixMode(GL_MODELVIEW);
}

void
output(int x, int y, char *strin)
{

  int len, i;

  //glRasterPos2f(x, y);
  len = (int) strlen(strin);
   // glPushMatrix();
   // glTranslatef(x, y, 0);
    //float currentColor[4];
    //glGetFloatv(GL_CURRENT_COLOR, currentColor);
    glColor4f(1.0, 1.0, 0.0, 1.0);
    glRasterPos2i(x, y);
   // glTranslatef(x, y, 0);
 // for (i = 0; i < len; i++) {
 // for (char *p = strin;  *p; p++) {
  //  glutStrokeCharacterter(GLUT_BITMAP_TIMES_ROMAN_10, string);
    for (i = 0; i < len; i++) {
	glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, strin[i]);
    }
    //glutStrokeString(GLUT_STROKE_ROMAN, strin);
    //glutBitmapString(GLUT_BITMAP_TIMES_ROMAN_24, strin);
   // glColor3fv(currentColor);
  //}
    //glPopMatrix();
}

void gldrawLines(){

    glBegin(GL_LINE_STRIP);
    for (int i = 0; i < N; i++){
	glVertex2f((GLfloat) x[i], (GLfloat) y[i]);
    }
    glEnd();
    glColor4f(1.0f, 1.0f, 0.0f, 1.0f); // 
  //  glBegin(GL_LINES);
//	glVertex2f(-1+eps, -1+eps);
//	glVertex2f(-1+eps, 1-eps);
//	glVertex2f(-1+eps, -1+eps);
//	glVertex2f(1-eps, -1+eps);
  //  glEnd();

}

void drawBorders(int w, int h){
    
    glColor3f(1., 1., 1.);
    //printf("w %d h %d\n", w, h);
    glViewport(w/2, 0, w/2, h/2);
    glBegin(GL_LINE_STRIP);
    glVertex2f(-1, -1);
    glVertex2i(1, -1);
    glVertex2i(1, 1);
    glVertex2i(-1, 1);
    glVertex2i(-1, -1);
    glEnd();
//glutPostRedisplay();
//glMatrixMode(GL_PROJECTION);
//glLoadIdentity();
  //  gluOrtho2D(-1, 1, -1, 1);
}

void display(){

    glColor3f(1.0f, 0.0f, 1.0f); // blue color
    //glTranslatef(0., 0., 0.0);
    //glRotatef(43, 0, 0, 2);
    glPointSize(10.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glViewport(0, 0, 10, 10);
    int w = glutGet(GLUT_WINDOW_WIDTH);
    int h = glutGet(GLUT_WINDOW_HEIGHT);
    glViewport(0, 0, w, h);
glMatrixMode(GL_PROJECTION);
glLoadIdentity();
    gluOrtho2D(-1, 4, -1, 4);
//glLoadIdentity();
    gluOrtho2D(-1, 4, -1, 4);
   gldrawLines();
    drawBorders(w, h);
    //glViewport(0, 0, glutGet(GLUT_WINDOW_WIDTH)/2, glutGet(GLUT_WINDOW_HEIGHT)/2);
    //output(-1, 0, "TEST");
    glutSwapBuffers();

}

void selectData(int data){
    //printf("changed to %d\n", data);
    if (data == 1){
	for (int i = 0; i < N; i++){
	    y[i] = cos(2.*M_PI*x[i]) + eps;
	}
    }else if (data == 2){
	for (int i = 0; i < N; i++){
	    y[i] = sin(2.*M_PI*x[i]) + eps;
	}
    }
    glutPostRedisplay(); 

}

void drawLines(float *x, float *y, int n){
 
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(500, 500);
    glutInitWindowPosition(0, 0);
    glutReshapeFunc(reshape);
    glClearColor(1.0, 1.0, 0, 1.0);
    glutCreateWindow("Test points array");

    glutDisplayFunc(display);
    glutCreateMenu(selectData);
    glutAddMenuEntry("cos", 1);
    glutAddMenuEntry("sin", 2);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
    glutMainLoop();
    // glEnable(GL_LIGHTING);
    
}

int main(int argc, char** argv){

    srand(time(NULL));
    x = malloc(N*sizeof(float));
    y = malloc(N*sizeof(float));
    for (int i = 0; i < N; i++){
	x[i] = (float)i/N - 1 + eps;
	y[i] = sin(2.*M_PI*x[i]) + eps;
    }
    glutInit(&argc, argv);
    drawLines(x, y, N);
    return 0;
}
