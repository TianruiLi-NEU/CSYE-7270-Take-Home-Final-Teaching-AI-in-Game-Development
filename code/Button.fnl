;; Button.fnl - Simple button widget
(local Button {})
(set Button.__index Button)
(set Button.__type "Button")

(fn Button.new [x y w h text callback]
  (local self
    {:x x :y y :w w :h h
     :text text
     :callback callback
     :hovered false})
  (setmetatable self Button)
  self)

(fn Button.isInside [self x y]
  (and (>= x self.x) (<= x (+ self.x self.w))
       (>= y self.y) (<= y (+ self.y self.h))))

(fn Button.update [self dt x y]
  (set self.hovered (self:isInside x y)))

(fn Button.mousepressed [self x y b]
  (when (and (= b 1) (self:isInside x y))
    (self.callback)
    true))

(fn Button.draw [self]
  (if self.hovered
      (love.graphics.setColor 0.4 0.7 1.0)
      (love.graphics.setColor 0.3 0.5 0.8))
  (love.graphics.rectangle :fill self.x self.y self.w self.h)
  
  (love.graphics.setColor 1 1 1)
  (love.graphics.rectangle :line self.x self.y self.w self.h)
  
  (local font (love.graphics.getFont))
  (local tw (font:getWidth self.text))
  (local th (font:getHeight))
  (love.graphics.print self.text
    (+ self.x (/ (- self.w tw) 2))
    (+ self.y (/ (- self.h th) 2))))

Button