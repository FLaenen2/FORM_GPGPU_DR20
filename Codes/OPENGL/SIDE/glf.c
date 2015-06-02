#include <GL/glut.h>
#include <stdio.h>

extern int n;
extern float *x, *y;
GLint win;
void gldrawPoints(){

    glBegin(GL_POINTS);
    for (int i = 0; i < n; i++){
	glVertex2f((GLfloat) x[i], (GLfloat) y[i]);
    }
    glEnd();

}


void
output(int x, int y, char *string)
{
  int len, i;

    glColor3f(0.0, 1.0, 0.0);
  glRasterPos2f(x, y);
  len = (int) strlen(string);
  for (i = 0; i < len; i++) {
    glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, string[i]);
  }
}

void display(){

    glColor3f(1.0f, 0.0f, 0.0f); //blue color
    glPointSize(6.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    gldrawPoints();
    output(0, 24, "This is written in a GLUT bitmap font.");
    glutSwapBuffers();

}

void displace(unsigned char key, int xp, int yp){
    printf("key %c pressed\n", key);
    for (int i = 0; i < n; i++){
	x[i] = (float)2.*rand()/RAND_MAX-1;
	y[i] = (float)2.*rand()/RAND_MAX-1;
    }
    //glutPostRedisplay();
}


void drawPoints(int it){
    printf("n %d\n", n);
    int argc = 0;
    char **argv = NULL;
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    char str[50];
    sprintf(str, "Points it %d", it);
    win = glutCreateWindow(str);
    glutDisplayFunc(display);
    glEnable(GL_POINT_SMOOTH);
    //glutKeyboardFunc(displace);
    //printf("keyboard func set, press any key to leave\n");
    glutMainLoopEvent();
    glutDestroyWindow(win);


}
