# Makefile for Library Management System

CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -g
INCLUDES = -Iinclude
SRCDIR = src
OBJDIR = obj
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
TARGET = library_system

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@echo "🔗 Linking $(TARGET)..."
	$(CXX) $(OBJECTS) -o $@
	@echo "✅ C++ build successful!"

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR)
	@echo "🔨 Compiling $<..."
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "🧹 Cleaning C++ build files..."
	rm -rf $(OBJDIR) $(TARGET) library_data.txt

run: $(TARGET)
	@echo "🚀 Running C++ Library Management System..."
	./$(TARGET)

help:
	@echo "Available targets:"
	@echo "  all    - Build the C++ project"
	@echo "  clean  - Remove C++ build files"
	@echo "  run    - Build and run the C++ application"
	@echo "  help   - Show this help message"
