(local Camera {})
(set Camera.__index Camera)
(set Camera.__type "Camera")
(fn Camera.new []
  (local self {:x 0 :y 0 :scaleX 1 :scaleY 1 :rotation 0})
  (setmetatable self Camera)
  self)
(fn Camera.set [self]
  (love.graphics.push)
  (love.graphics.translate (- self.x) (- self.y))
  (love.graphics.rotate (- self.rotation))
  (love.graphics.scale self.scaleX self.scaleY))
(fn Camera.unset [self]
  (love.graphics.pop))
(fn Camera.move [self dx dy]
  (set self.x (+ self.x dx))
  (set self.y (+ self.y dy)))
(fn Camera.rotate [self dr]
  (set self.rotation (+ self.rotation dr)))
(fn Camera.scale [self sx sy]
  (set self.scaleX (* self.scaleX sx))
  (set self.scaleY (* self.scaleY (or sy sx))))
(fn Camera.toWorld [self sx sy]
  (local c (math.cos self.rotation))
  (local s (math.sin self.rotation))
  (local tx (+ sx self.x))
  (local ty (+ sy self.y))
  (local rx (- (* c tx) (* s ty)))
  (local ry (+ (* s tx) (* c ty)))
  (local wx (/ rx self.scaleX))
  (local wy (/ ry self.scaleY))
  (values wx wy))
(fn Camera.lookAt [self x y]
  (local W (love.graphics.getWidth))
  (local H (love.graphics.getHeight))
  (local c (math.cos self.rotation))
  (local s (math.sin self.rotation))
  (local sx (* self.scaleX x))
  (local sy (* self.scaleY y))
  (local rx (+ (* c sx) (* s sy)))
  (local ry (- (* c sy) (* s sx)))
  (set self.x (- rx (/ W 2)))
  (set self.y (- ry (/ H 2))))
Camera
