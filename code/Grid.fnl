;; Grid.fnl - Grid-based pathfinding visualization
(local Grid {})
(set Grid.__index Grid)
(set Grid.__type "Grid")

(fn Grid.new [cols rows cellSize]
  (local self
    {:cols cols
     :rows rows
     :cellSize cellSize
     :cells []
     :start nil
     :goal nil
     :path []
     :openSet []
     :closedSet []
     :mode :wall  ;; :wall, :start, :goal
     :animating false
     :animStep 0
     :animDelay 0.05
     :animTimer 0})
  
  ;; Initialize grid
  (for [y 1 rows]
    (for [x 1 cols]
      (local idx (+ (* (- y 1) cols) x))
      (tset self.cells idx
        {:x x :y y :walkable true
         :g 0 :h 0 :f 0 :parent nil})))
  
  (setmetatable self Grid)
  self)

(fn Grid.getCell [self x y]
  (if (and (>= x 1) (<= x self.cols)
           (>= y 1) (<= y self.rows))
    (. self.cells (+ (* (- y 1) self.cols) x))
    nil))

(fn Grid.heuristic [self a b]
  ;; Manhattan distance
  (+ (math.abs (- (. a :x) (. b :x)))
     (math.abs (- (. a :y) (. b :y)))))

(fn Grid.getNeighbors [self cell]
  (local neighbors [])
  (local dirs [[-1 0] [1 0] [0 -1] [0 1]])
  (each [_ dir (ipairs dirs)]
    (local nx (+ (. cell :x) (. dir 1)))
    (local ny (+ (. cell :y) (. dir 2)))
    (local neighbor (self:getCell nx ny))
    (when (and neighbor (. neighbor :walkable))
      (table.insert neighbors neighbor)))
  neighbors)

(fn Grid.reconstructPath [self]
  (set self.path [])
  (var current self.goal)
  (while current
    (table.insert self.path 1 current)
    (set current (. current :parent))))

(fn Grid.resetPathfinding [self]
  (set self.path [])
  (set self.openSet [])
  (set self.closedSet [])
  (set self.animating false)
  (set self.animStep 0)
  (each [_ cell (ipairs self.cells)]
    (tset cell :g 0)
    (tset cell :h 0)
    (tset cell :f 0)
    (tset cell :parent nil)))

(fn Grid.startPathfinding [self]
  (when (and self.start self.goal)
    (self:resetPathfinding)
    (tset self.start :g 0)
    (tset self.start :h (self:heuristic self.start self.goal))
    (tset self.start :f (. self.start :h))
    (table.insert self.openSet self.start)
    (set self.animating true)))

(fn Grid.stepPathfinding [self]
  (when (= (length self.openSet) 0)
    (set self.animating false)
    (lua "return"))
  
  ;; Find node with lowest f score
  (var lowestIdx 1)
  (var lowestF (. (. self.openSet 1) :f))
  (for [i 2 (length self.openSet)]
    (when (< (. (. self.openSet i) :f) lowestF)
      (set lowestIdx i)
      (set lowestF (. (. self.openSet i) :f))))
  
  (local current (table.remove self.openSet lowestIdx))
  (table.insert self.closedSet current)
  
  ;; Check if we reached goal
  (when (= current self.goal)
    (self:reconstructPath)
    (set self.animating false)
    (lua "return"))
  
  ;; Check neighbors
  (local neighbors (self:getNeighbors current))
  (each [_ neighbor (ipairs neighbors)]
    (var inClosed false)
    (each [_ c (ipairs self.closedSet)]
      (when (= c neighbor)
        (set inClosed true)))
    
    (when (not inClosed)
      (local tentativeG (+ (. current :g) 1))
      
      (var inOpen false)
      (each [_ o (ipairs self.openSet)]
        (when (= o neighbor)
          (set inOpen true)))
      
      (when (or (not inOpen) (< tentativeG (. neighbor :g)))
        (tset neighbor :parent current)
        (tset neighbor :g tentativeG)
        (tset neighbor :h (self:heuristic neighbor self.goal))
        (tset neighbor :f (+ (. neighbor :g) (. neighbor :h)))
        
        (when (not inOpen)
          (table.insert self.openSet neighbor))))))

(fn Grid.update [self dt x y]
  (when self.animating
    (set self.animTimer (+ self.animTimer dt))
    (when (>= self.animTimer self.animDelay)
      (set self.animTimer 0)
      (self:stepPathfinding))))

(fn Grid.mousepressed [self x y b]
  (local gx (math.floor (/ x self.cellSize)))
  (local gy (math.floor (/ y self.cellSize)))
  (local cell (self:getCell (+ gx 1) (+ gy 1)))
  
  (when cell
    (match self.mode
      :wall (do
              (tset cell :walkable (not (. cell :walkable)))
              (self:resetPathfinding))
      :start (do
               (set self.start cell)
               (self:resetPathfinding))
      :goal (do
              (set self.goal cell)
              (self:resetPathfinding))))
  true)

(fn Grid.draw [self]
  ;; Draw cells
  (each [_ cell (ipairs self.cells)]
    (local x (* (- (. cell :x) 1) self.cellSize))
    (local y (* (- (. cell :y) 1) self.cellSize))
    
    ;; Determine color
    (if (not (. cell :walkable))
        (love.graphics.setColor 0.2 0.2 0.2)
        (= cell self.start)
        (love.graphics.setColor 0.3 0.8 0.3)
        (= cell self.goal)
        (love.graphics.setColor 0.8 0.3 0.3)
        (do
          (var inPath false)
          (each [_ p (ipairs self.path)]
            (when (= p cell)
              (set inPath true)))
          
          (var inOpen false)
          (each [_ o (ipairs self.openSet)]
            (when (= o cell)
              (set inOpen true)))
          
          (var inClosed false)
          (each [_ c (ipairs self.closedSet)]
            (when (= c cell)
              (set inClosed true)))
          
          (if inPath
              (love.graphics.setColor 0.4 0.6 1.0)
              inOpen
              (love.graphics.setColor 0.6 0.9 0.6)
              inClosed
              (love.graphics.setColor 0.9 0.7 0.7)
              (love.graphics.setColor 0.95 0.95 0.95))))
    
    (love.graphics.rectangle :fill x y self.cellSize self.cellSize)
    (love.graphics.setColor 0.7 0.7 0.7)
    (love.graphics.rectangle :line x y self.cellSize self.cellSize)))

Grid