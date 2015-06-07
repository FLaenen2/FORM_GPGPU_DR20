#include <GL/glut.h>
#include <GL/freeglut.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int n;
float *x, *y;
GLint win;
static int set = 0;

void gldrawLines(){

    glBegin(GL_LINE_STRIP);
    for (int i = 0; i < n; i++){
	glVertex2f((GLfloat) x[i], (GLfloat) y[i]);
    }
    glEnd();

}


void display(){

    glColor3f(1.0f, 0.0f, 0.0f); 
    glPointSize(6.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    gldrawLines();
    glutSwapBuffers();

}

void keyboard(unsigned char key, int xp, int yp){
    printf("key %c pressed\n", key);
	switch (key){
		case 'c' : glutLeaveMainLoop();
			break;
		case 'e' : printf("Exiting program...\n") ; exit(1);
	}

  /* // Example to update data
    for (int i = 0; i < n; i++){
	x[i] = (float)2.*rand()/RAND_MAX-1;
	y[i] = (float)2.*rand()/RAND_MAX-1;
    
    glutPostRedisplay();*/
}


void drawLines2D(float *u_x, float *u_y, int u_n, char *title, int block){
	
    n = u_n; 
    x = u_x;
    y = u_y;
    int argc2 = 0;
    if (!set){
	printf("Initializing glut\n");
	glutInit(&argc2, NULL);
	set = 1;
    }
	glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	glEnable(GL_POINT_SMOOTH);
	win = glutCreateWindow(title);
	printf("win %d\n", win);
	glutSetWindow(win);
	glutDisplayFunc(display);
    	glutKeyboardFunc(keyboard);
	if (block){
    		printf("Entering bloking loop. Press 'c' key to resume, 'e' to exit pogram\n");
		glutMainLoop();
		set = 0;
	}else{
    		glutMainLoopEvent();
    		glutDestroyWindow(win);
	}

}
