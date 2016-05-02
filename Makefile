CXX=g++
CXXFLAGS= -O3 -march=native -std=c++11
SWIG=swig
OPENMPFLAGS= -fopenmp -D PYDTW_ENABLE_OPENMP
OPENMPLINK= -lgomp

PYTHONINCLUDE= -I /usr/include/python2.7
BASEDIR=./pydtw/source
SOURCE=$(BASEDIR)/host.cpp \
       $(BASEDIR)/host.hpp \
       $(BASEDIR)/host.i

all: $(BASEDIR)/_host.so

$(BASEDIR)/_host.so: $(BASEDIR)/host.o $(BASEDIR)/host_wrap.o
	$(CXX) -shared $(BASEDIR)/host.o $(BASEDIR)/host_wrap.o -o $(BASEDIR)/_host.so $(OPENMPLINK)
	rm -f $(BASEDIR)/host_wrap.cxx
	rm -f $(BASEDIR)/*.o
	rm -f $(BASEDIR)/*.pyc
	rm -f pydtw/*.pyc

$(BASEDIR)/host.o: $(SOURCE)
	$(CXX) $(CXXFLAGS) -fPIC -c $(BASEDIR)/host.cpp -o $(BASEDIR)/host.o  $(OPENMPFLAGS)

$(BASEDIR)/host_wrap.o: $(BASEDIR)/host_wrap.cpp
	$(CXX) $(CXXFLAGS) -fPIC -c $(BASEDIR)/host_wrap.cxx $(PYTHONINCLUDE) -o $(BASEDIR)/host_wrap.o  $(OPENMPFLAGS)

$(BASEDIR)/host_wrap.cpp: $(SOURCE)
	$(SWIG) -python -c++ $(BASEDIR)/host.i

clean:
	rm -f $(BASEDIR)/host.py
	rm -f $(BASEDIR)/*.so
	rm -f $(BASEDIR)/*.pyc
	rm -f $(BASEDIR)/*~
