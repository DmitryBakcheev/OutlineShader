# OutlineShader

Description:
This metal outline shader is designed to create a basic outline effect around 3D objects. 
The shader works by rendering the object's mesh twice, once with the regular material and once with an outline material.
It can be used in toon style shading or highlighting important objects on screen. 

To keep things simple i used SCNProgram in this project, so you can easily add this effect to your SCNNode.
There are many different ways to create outline effect, this one is great for very simple objects.


Outline effect on the SCNBox.

![cube](https://github.com/DmitryBakcheev/OutlineShader/assets/95116816/2a0f1270-4883-4cfc-a514-6c04d30cc064)


Outline effect in black and red colors on the ship.

![blackOutline](https://github.com/DmitryBakcheev/OutlineShader/assets/95116816/4501fbbd-cf3a-4f07-96b3-e1f39702a8e4)

![redOutline](https://github.com/DmitryBakcheev/OutlineShader/assets/95116816/119a5215-8870-4dab-afab-56b991e7853c)


