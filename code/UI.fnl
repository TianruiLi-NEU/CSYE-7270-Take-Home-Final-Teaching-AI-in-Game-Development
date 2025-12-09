(local Stack (require :Stack))
(local Camera (require :Camera))
(local UI {})
(set UI.__index UI)
(set UI.__type "UI")
(fn UI.new []
  (local self
    {:cameraStack (Stack.new)
     :stack (Stack.new)})
  (UI.push self)
  (setmetatable self UI)
  self)
(fn UI.push [self layer]
  (self.cameraStack:push (Camera.new))
  (self.stack:push (or layer [])))
(fn UI.pop [self]
  [(self.cameraStack:pop)
   (self.stack:pop)])
(fn UI.currentCamera [self]
  (self.cameraStack:peek))
(fn UI.currentLayer [self]
  (self.stack:peek))
(fn UI.add [self x]
  (table.insert (self:currentLayer) x))
(fn UI.add* [self ...]
  (local widgets [...])
  (local currentLayer (self:currentLayer))
  (each [_ widget (ipairs widgets)]
    (table.insert currentLayer widget)))
(fn UI.remove [self predicate]
  (local currentLayer (self:currentLayer))
  (var i 1)
  (while (<= i (length currentLayer))
    (local widget (. currentLayer i))
    (if (predicate widget)
        (table.remove currentLayer i)
        (set i (+ i 1)))))
(fn UI.draw [self]
  (local currentCamera (self:currentCamera))
  (local currentLayer (self:currentLayer))
  (currentCamera:set)
  (each [_ widget (ipairs currentLayer)]
    (when widget.draw
      (widget:draw)))
  (currentCamera:unset))
(fn UI.update [self dt x y]
  (local currentCamera (self:currentCamera))
  (local currentLayer (self:currentLayer))
  (each [_ widget (ipairs currentLayer)]
    (when widget.update
      (widget:update dt x y)))
  (when currentCamera.update
    (currentCamera:update dt x y)))
(fn UI.mousepressed [self x y b]
  (local currentCamera (self:currentCamera))
  (local currentLayer (self:currentLayer))
  (for [i (length currentLayer) 1 -1]
    (local widget (. currentLayer i))
    (when (and widget.mousepressed
               (widget:mousepressed x y b))
      (lua "goto done")))
  (lua "::done::")
  (when currentCamera.mousepressed
    (currentCamera:mousepressed x y b)))
(fn UI.mousereleased [self x y b]
  (local currentCamera (self:currentCamera))
  (local currentLayer (self:currentLayer))
  (each [_ widget (ipairs currentLayer)]
    (when widget.mousereleased
      (widget:mousereleased x y b)))
  (when currentCamera.mousereleased
    (currentCamera:mousereleased x y b)))
UI
