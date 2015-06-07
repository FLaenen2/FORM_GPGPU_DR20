#include <GL/glut.h>
#include <GL/freeglut.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

extern int n;
float *x, *y;
GLint win;
static int set = 0;
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

    glColor3f(1.0f, 0.0f, 0.0f); 
    glPointSize(6.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    gldrawPoints();
    output(0, 24, "This is written in a GLUT bitmap font.");
    glutSwapBuffers();

}

void displace(unsigned char key, int xp, int yp){
    printf("key %c pressed\n", key);
	switch (key){
		case 'c' : glutLeaveMainLoop();
			break;
		case 'e' : printf("Exiting program...\n") ; exit(1);
	}
    for (int i = 0; i < n; i++){
	x[i] = (float)2.*rand()/RAND_MAX-1;
	y[i] = (float)2.*rand()/RAND_MAX-1;
    }
    glutPostRedisplay();
}


void drawPoints2D(float *u_x, float *u_y, char *title, int block){
	
	x = u_x;
	y = u_y;

    if (!set){
	printf("Initializing glut\n");
	glutInit(0, NULL);
	
	set = 1;
    }
	glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    //printf("n %d\n", n);
    glEnable(GL_POINT_SMOOTH);
    win = glutCreateWindow(title);
	printf("win %d\n", win);
	glutSetWindow(win);
	glutDisplayFunc(display);
    	glutKeyboardFunc(displace);
	if (block){
    		printf("Entering bloking loop. Press 'c' key to resume, 'e' to exit pogram\n");
		glutMainLoop();
		set = 0;
	}else{
    		glutMainLoopEvent();
    		glutDestroyWindow(win);
	}

}
