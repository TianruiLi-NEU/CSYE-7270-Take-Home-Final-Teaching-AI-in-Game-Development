;; Start.fnl - Main application setup for pathfinding demo
(local UI (require :UI))
(local Grid (require :Grid))
(local Button (require :Button))

(local ui (UI.new))
(var grid nil)

(fn love.load []
  (love.window.setTitle "A* Pathfinding Demo")
  (love.window.setMode 800 650)
  
  (set grid (Grid.new 20 15 40))
  (ui:add grid)
  
  ;; Control buttons
  (local btnY 610)
  (ui:add (Button.new 10 btnY 120 35 "Draw Walls"
    (fn [] (set grid.mode :wall))))
  
  (ui:add (Button.new 140 btnY 120 35 "Set Start"
    (fn [] (set grid.mode :start))))
  
  (ui:add (Button.new 270 btnY 120 35 "Set Goal"
    (fn [] (set grid.mode :goal))))
  
  (ui:add (Button.new 400 btnY 120 35 "Find Path"
    (fn [] (grid:startPathfinding))))
  
  (ui:add (Button.new 530 btnY 120 35 "Clear Path"
    (fn [] (grid:resetPathfinding))))
  
  (ui:add (Button.new 660 btnY 120 35 "Clear All"
    (fn []
      (each [_ cell (ipairs grid.cells)]
        (set cell.walkable true))
      (set grid.start nil)
      (set grid.goal nil)
      (grid:resetPathfinding))))
  
  ;; Instructions
  (local instructions
    (.. "Instructions: 1) Draw Walls (click/drag)  "
        "2) Set Start (click)  "
        "3) Set Goal (click)  "
        "4) Find Path")))

(fn love.update [dt]
  (local (wx wy)
    (: (ui:currentCamera) :toWorld (love.mouse.getPosition)))
  (ui:update dt wx wy))

(fn love.mousepressed [x y b]
  (local (wx wy)
    (: (ui:currentCamera) :toWorld x y))
  (ui:mousepressed wx wy b))

(fn love.mousereleased [x y b]
  (local (wx wy)
    (: (ui:currentCamera) :toWorld x y))
  (ui:mousereleased wx wy b))

(fn love.draw []
  (ui:draw)
  
  ;; Draw instructions
  (love.graphics.setColor 0 0 0)
  (love.graphics.print 
    (.. "Mode: " (tostring (. grid :mode))
        " | Green=Start, Red=Goal, Dark=Wall, Blue=Path, Light Green=Open, Light Red=Closed")
    10 605))