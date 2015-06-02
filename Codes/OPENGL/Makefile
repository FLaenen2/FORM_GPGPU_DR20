APPS = points_dynamic checkerboard texture subwin stenciltst spots simple molehill points lines bitfont cube blender highlight

all : ${APPS}

%: %.c
	clang -I/usr/local/include -I/opt/local/include -L/opt/local/lib -lGL -lGLU -lglut -o $@ $<

clean:
	rm ${APPS}
