CXX = clang++
CXXFLAGS = -g -O2 -Wall --std=c++14

LIBRARY_SRC = libs
PA_STATIC_LIB = $(LIBRARY_SRC)/portaudio/lib/.libs/libportaudio.a
PA_INCLUDE_DIR = $(LIBRARY_SRC)/portaudio/include
AQ_STATIC_LIB = $(LIBRARY_SRC)/aquila/build/libAquila.a $(LIBRARY_SRC)/aquila/build/lib/libOoura_fft.a
AQ_INCLUDE_DIR = $(LIBRARY_SRC)/aquila

SHELL = /bin/sh
LIBTOOL = $(SHELL) $(LIBRARY_SRC)/portaudio/libtool
LIBS = -framework CoreAudio -framework AudioToolbox -framework AudioUnit -framework Carbon

SOUND_OBJS = \
	receiver/write_wav.o \
	receiver/paex_record.o 

INCLUDES = -I$(PA_INCLUDE_DIR) -I$(AQ_INCLUDE_DIR)
STATIC_LIBS = $(PA_STATIC_LIB) $(AQ_STATIC_LIB)



all: send_scp recv

send_scp: send_scp.cpp sound_drop.h protocol.h
	$(CXX) $(CXXFLAGS) $< $(PA_STATIC_LIB) -I$(PA_INCLUDE_DIR) $(LIBS) -o $@

transfer: transfer.cpp
	$(CXX) $(CXXFLAGS) $< $(STATIC_LIBS) $(INCLUDES) $(FLAGS) -o $@

recv: receiver/FFTreader.cpp receiver/paex_record.cpp receiver/write_wav.cpp
	$(CXX) -o $@ $(CXXFLAGS) receiver/FFTreader.cpp receiver/paex_record.cpp receiver/write_wav.cpp $(STATIC_LIBS) $(INCLUDES) $(LIBS)

# %.o: %.cpp
# 	$(CXX) $(CFLAGS) -c $< $(PA_STATIC_LIB) $(INCLUDES) -o $@

# %.o: %.c
# 	$(CXX) $(CFLAGS) -c $< $(STATIC_LIBS) -I$(INCLUDES) -o $@
clean:
	rm -rf send_scp test transfer *.dSYM receiver/*.o recv
