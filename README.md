# CSYE-7270-Take-Home-Final-Teaching-AI-in-Game-Development
Topic: Navigation & Pathfinding Systems

Author: Tianrui Li

🧭 Overview

This repository contains my take-home final for CSYE 7270, focusing on the topic:

🎯 Navigation & Pathfinding Systems

The goal of this project is to explain, demonstrate, and guide learners through the fundamentals and practical implementations of game AI navigation — with an emphasis on A* pathfinding.

The project follows a structured instructional model:

 Introduce core concepts, motivation, and real game examples

 Demonstrate an interactive A* visualization tool implemented in Fennel/Lua

 Provide guided exercises, debugging tips, and challenges for learners

This repository includes all teaching materials, visualization source code, documentation, and slides used for the final video assignment.

🚀 Project Features

✔️ Interactive A* pathfinding visualization

✔️ Real-time UI for walls, start/goal selection, and search control

✔️ Color-coded display of Open Set, Closed Set, and final Path

✔️ Modular architecture (Grid, UI, Buttons, Camera, Stack layers)

✔️ Fully written in Fennel (Lisp-like language compiling to Lua)

✔️ Runs on the LÖVE2D game framework

✔️ Accompanied by teaching documents and exercises

🗂️ Repository Structure
.
├── main.lua                 # LÖVE2D entry point & Fennel loader
├── fennel.lua               # Fennel language runtime for Lua
├── Start.fnl                # Application bootstrap: UI, Grid setup
├── Grid.fnl                 # Core A* algorithm & visualization logic
├── UI.fnl                   # Layer management, drawing, and event routing
├── Button.fnl               # Simple UI widget system
├── Camera.fnl               # Camera transforms for grid rendering
├── Stack.fnl                # Stack-based UI layer manager
│
├── slides.pdf               # Slide deck used in video
├── report.pdf               # Full pedagogical and algorithmic analysis
├── notes.pdf                # Teaching and design notes
├── references.pdf           # Reference list for concepts and materials
└── exercises.pdf            # Guided exercise & debugging practice materials

▶️ Running the Visualization
Prerequisites

Install LÖVE2D (https://love2d.org
)

No additional dependencies required; Fennel is included in the repo

To Run:
love .


or, on macOS:

open -n -a love .


The visualization will launch with:

draw/remove walls

set Start / Goal

UI buttons to Start /  Reset


🔍 How It Works
A* Algorithm

This project demonstrates an educational version of A*, using:

g(n): cost from start

h(n): Manhattan heuristic

f(n) = g(n) + h(n)


📄 Documentation

These documents support the teaching content:

slides.pdf 

report.pdf

notes.pdf — Script and lecture planning notes

references.pdf

exercises.pdf — Student practice problems and debugging tasks

📚 References & Acknowledgments

Algorithms, concepts, and teaching structure are adapted from:

Course materials from CSYE 7270

Industry game AI practices (navigation meshes, hierarchical planning)

Fennel and LÖVE2D documentation

Author: Tianrui Li
