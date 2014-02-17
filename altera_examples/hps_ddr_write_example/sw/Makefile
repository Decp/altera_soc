CC = arm-linux-gnueabihf-gcc
CXX =  arm-linux-gnueabihf-g++

CPP_FILES += $(wildcard *.cpp)
OBJ_FILES := $(addprefix obj/,$(notdir $(CPP_FILES:.cpp=.o)))

CC_FLAGS += -I .
CC_FLAGS += -MMD
CC_FLAGS += -Wno-psabi
CC_FLAGS += -DMTL_USE_QT=0
CC_FLAGS += -DMTL_USE_STD

LD_FLAGS += -lpthread -lrt

all:	stamps obj write2hpsmem 

stamps:
	rm -f obj/main.o

write2hpsmem: $(OBJ_FILES)
	echo $(OBJ_FILES)
	$(CXX) $(LD_FLAGS) -o $@ $^

obj:
	mkdir -p obj


obj/main.o: main.cpp
	$(CXX) $(CC_FLAGS) -c -o $@ $<

obj/%.o: %.cpp
	$(CXX) $(CC_FLAGS) -c -o $@ $<

clean:
	rm -rf obj

-include $(OBJ_FILES:.o=.d)
