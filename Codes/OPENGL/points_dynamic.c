#include <GL/glut.h>
#include <stdlib.h>  
#include <time.h>
#include <stdio.h>
//#include <openglut.h>
#define N 100
#include <unistd.h>

float *x, *y;

void gldrawPoints(){

    glBegin(GL_POINTS);
    for (int i = 0; i < N; i++){
	glVertex2f((GLfloat) x[i], (GLfloat) y[i]);
    }
    glEnd();

}


void display(){

    glColor3f(0.0f,0.0f,1.0f); //blue color
    glPointSize(8.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  gldrawPoints();
  glutSwapBuffers();

}

void displace(unsigned char key, int xp, int yp){
    printf("key %c pressed\n", key);
    if (key == 'c'){
	printf("key %c pressed, leaving\n", key);
	glutLeaveMainLoop();
    } 
    for (int i = 0; i < N; i++){
	x[i] = (float)2.*rand()/RAND_MAX-1;
	y[i] = (float)2.*rand()/RAND_MAX-1;
    }
    glutPostRedisplay();
}

void drawPoints(float *x, float *y, int n){
 
     glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutCreateWindow("Test points array");
    glutDisplayFunc(display);
    glutKeyboardFunc(displace);
	glutSpecialFunc(displace);
    printf("keyboard func set\n");
    //glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_CONTINUE_EXECUTION);
   // glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_CONTINUE_EXECUTION);    
    glutMainLoop();
   // glutMainLoopEvent(); // only once
   // printf("main lop returneed\n");
    //sleep(3);
   // printf("eciting\n");    // glEnable(GL_LIGHTING);
    
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
    printf("exit program\n");
    return 0;
}
