# 场景的描述和渲染

## 表示一个立方体

如何表示和操作立方体，目标是找到一种更通用的方法。就是使用三角形表示。如立方体可以用12个三角形表示，每面从对角线将面分为两个三角形。

实现效果

![scene stepup demo1](../.gitbook/assets/fvhdif_2323_cd290d9203.png)

源码

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scene setup demo 1</title>
</head>

<div class="centered">
    <canvas id="canvas" width=600 height=600 style="border: 1px grey solid"></canvas>
</div>
<script>
    "use strict";

    // ======================================================================
    //  Low-level canvas access.
    // ======================================================================

    let canvas = document.getElementById("canvas");
    let canvas_context = canvas.getContext("2d");
    let canvas_buffer = canvas_context.getImageData(0, 0, canvas.width, canvas.height);

    // A color.
    function Color(r, g, b) {
        return {
            r, g, b,
            mul: function (n) { return new Color(this.r * n, this.g * n, this.b * n); },
        };
    }

    // The PutPixel() function.
    function PutPixel(x, y, color) {
        x = canvas.width / 2 + (x | 0);
        y = canvas.height / 2 - (y | 0) - 1;

        if (x < 0 || x >= canvas.width || y < 0 || y >= canvas.height) {
            return;
        }

        let offset = 4 * (x + canvas_buffer.width * y);
        canvas_buffer.data[offset++] = color.r;
        canvas_buffer.data[offset++] = color.g;
        canvas_buffer.data[offset++] = color.b;
        canvas_buffer.data[offset++] = 255; // Alpha = 255 (full opacity)
    }


    // Displays the contents of the offscreen buffer into the canvas.
    function UpdateCanvas() {
        canvas_context.putImageData(canvas_buffer, 0, 0);
    }


    // ======================================================================
    //  Data model.
    // ======================================================================

    // A Point.
    function Pt(x, y, h) {
        return { x, y, h };
    }


    // A 3D vertex.
    function Vertex(x, y, z) {
        return { x, y, z };
    }


    // A Triangle.
    function Triangle(v0, v1, v2, color) {
        return { v0, v1, v2, color };
    }


    // ======================================================================
    //  Rasterization code.
    // ======================================================================

    // Scene setup.
    let viewport_size = 1;
    let projection_plane_z = 1;


    function Interpolate(i0, d0, i1, d1) {
        if (i0 == i1) {
            return [d0];
        }

        let values = [];
        let a = (d1 - d0) / (i1 - i0);
        let d = d0;
        for (let i = i0; i <= i1; i++) {
            values.push(d);
            d += a;
        }

        return values;
    }


    function DrawLine(p0, p1, color) {
        let dx = p1.x - p0.x, dy = p1.y - p0.y;

        if (Math.abs(dx) > Math.abs(dy)) {
            // The line is horizontal-ish. Make sure it's left to right.
            if (dx < 0) { let swap = p0; p0 = p1; p1 = swap; }

            // Compute the Y values and draw.
            let ys = Interpolate(p0.x, p0.y, p1.x, p1.y);
            for (let x = p0.x; x <= p1.x; x++) {
                PutPixel(x, ys[(x - p0.x) | 0], color);
            }
        } else {
            // The line is verical-ish. Make sure it's bottom to top.
            if (dy < 0) { let swap = p0; p0 = p1; p1 = swap; }

            // Compute the X values and draw.
            let xs = Interpolate(p0.y, p0.x, p1.y, p1.x);
            for (let y = p0.y; y <= p1.y; y++) {
                PutPixel(xs[(y - p0.y) | 0], y, color);
            }
        }
    }


    function DrawWireframeTriangle(p0, p1, p2, color) {
        DrawLine(p0, p1, color);
        DrawLine(p1, p2, color);
        DrawLine(p0, p2, color);
    }


    // Converts 2D viewport coordinates to 2D canvas coordinates.
    function ViewportToCanvas(p2d) {
        return new Pt(
            p2d.x * canvas.width / viewport_size,
            p2d.y * canvas.height / viewport_size);
    }


    function ProjectVertex(v) {
        return ViewportToCanvas(new Pt(
            v.x * projection_plane_z / v.z,
            v.y * projection_plane_z / v.z));
    }


    function RenderTriangle(triangle, projected) {
        DrawWireframeTriangle(projected[triangle.v0],
            projected[triangle.v1],
            projected[triangle.v2],
            triangle.color);
    }


    function RenderObject(vertices, triangles) {
        let projected = [];
        // 将物体顶点映射到画布
        for (let i = 0; i < vertices.length; i++) {
            projected.push(ProjectVertex(vertices[i]));
        }
        // 在画布上将三角形根据顶点连起来
        for (let i = 0; i < triangles.length; i++) {
            RenderTriangle(triangles[i], projected);
        }
    }

    // 物体顶点
    const vertices = [
        new Vertex(1, 1, 1),
        new Vertex(-1, 1, 1),
        new Vertex(-1, -1, 1),
        new Vertex(1, -1, 1),
        new Vertex(1, 1, -1),
        new Vertex(-1, 1, -1),
        new Vertex(-1, -1, -1),
        new Vertex(1, -1, -1)
    ];

    // 颜色
    const RED = new Color(255, 0, 0);
    const GREEN = new Color(0, 255, 0);
    const BLUE = new Color(0, 0, 255);
    const YELLOW = new Color(255, 255, 0);
    const PURPLE = new Color(255, 0, 255);
    const CYAN = new Color(0, 255, 255);

    // 用顶点表示三角形
    const triangles = [
        new Triangle(0, 1, 2, RED),
        new Triangle(0, 2, 3, RED),
        new Triangle(4, 0, 3, GREEN),
        new Triangle(4, 3, 7, GREEN),
        new Triangle(5, 4, 7, BLUE),
        new Triangle(5, 7, 6, BLUE),
        new Triangle(1, 5, 6, YELLOW),
        new Triangle(1, 6, 2, YELLOW),
        new Triangle(4, 5, 1, PURPLE),
        new Triangle(4, 1, 0, PURPLE),
        new Triangle(2, 6, 7, CYAN),
        new Triangle(2, 7, 3, CYAN)
    ];

    // 平移物体所有顶点
    for (let i = 0; i < vertices.length; i++) {
        vertices[i].x -= 1.5;
        vertices[i].z += 7;
    }

    RenderObject(vertices, triangles);

    UpdateCanvas();

</script>

</html>
```

## 模型和模型实例

更好的表示方法是模型 model 和 实例 instance的角度进行思考。

```bash
model {
 name = cube
 vertices {
  ...
 }
 triangles {
  ...
 }
}

instance {
 model = cube
 position = (0, 0, 5)
}

instance {
 model = cube
 position = (1, 2, 3)
}
```

逻辑伪代码

```js
RenderScene()
{
    for I in scene.instances{
        RenderInstance(I);
    }
}

RenderInstance(instance){
    projected = []
    model = instance.model
    for V in model.vertices{
        V' = V + instance.position
        projected.append(ProjectVertex(V'))
    }
    for T in model.triangles{
        RenderTriangle(T, projected)
    }
}
```

实现效果

![模型和模型实例](../.gitbook/assets/2024-12-15161708.png)

```html
<div class="centered">
  <canvas id="canvas" width=600 height=600 style="border: 1px grey solid"></canvas>
</div>

<script>
  "use strict";

  // ======================================================================
  //  Low-level canvas access.
  // ======================================================================

  let canvas = document.getElementById("canvas");
  let canvas_context = canvas.getContext("2d");
  let canvas_buffer = canvas_context.getImageData(0, 0, canvas.width, canvas.height);

  // A color.
  function Color(r, g, b) {
    return {
      r, g, b,
      mul: function (n) { return new Color(this.r * n, this.g * n, this.b * n); },
    };
  }

  // The PutPixel() function.
  function PutPixel(x, y, color) {
    x = canvas.width / 2 + (x | 0);
    y = canvas.height / 2 - (y | 0) - 1;

    if (x < 0 || x >= canvas.width || y < 0 || y >= canvas.height) {
      return;
    }

    let offset = 4 * (x + canvas_buffer.width * y);
    canvas_buffer.data[offset++] = color.r;
    canvas_buffer.data[offset++] = color.g;
    canvas_buffer.data[offset++] = color.b;
    canvas_buffer.data[offset++] = 255; // Alpha = 255 (full opacity)
  }


  // Displays the contents of the offscreen buffer into the canvas.
  function UpdateCanvas() {
    canvas_context.putImageData(canvas_buffer, 0, 0);
  }


  // ======================================================================
  //  Data model.
  // ======================================================================

  // A Point.
  function Pt(x, y, h) {
    return { x, y, h };
  }


  // A 3D vertex.
  function Vertex(x, y, z) {
    return {
      x, y, z,
      add: function (v) { return new Vertex(this.x + v.x, this.y + v.y, this.z + v.z); },
    }
  }


  // A Triangle.
  function Triangle(v0, v1, v2, color) {
    return { v0, v1, v2, color };
  }


  // A Model.
  function Model(vertices, triangles) {
    return { vertices, triangles };
  }


  // An Instance.
  function Instance(model, position) {
    return { model, position };
  }



  // ======================================================================
  //  Rasterization code.
  // ======================================================================

  // Scene setup.
  let viewport_size = 1;
  let projection_plane_z = 1;


  function Interpolate(i0, d0, i1, d1) {
    if (i0 == i1) {
      return [d0];
    }

    let values = [];
    let a = (d1 - d0) / (i1 - i0);
    let d = d0;
    for (let i = i0; i <= i1; i++) {
      values.push(d);
      d += a;
    }

    return values;
  }


  function DrawLine(p0, p1, color) {
    let dx = p1.x - p0.x, dy = p1.y - p0.y;

    if (Math.abs(dx) > Math.abs(dy)) {
      // The line is horizontal-ish. Make sure it's left to right.
      if (dx < 0) { let swap = p0; p0 = p1; p1 = swap; }

      // Compute the Y values and draw.
      let ys = Interpolate(p0.x, p0.y, p1.x, p1.y);
      for (let x = p0.x; x <= p1.x; x++) {
        PutPixel(x, ys[(x - p0.x) | 0], color);
      }
    } else {
      // The line is verical-ish. Make sure it's bottom to top.
      if (dy < 0) { let swap = p0; p0 = p1; p1 = swap; }

      // Compute the X values and draw.
      let xs = Interpolate(p0.y, p0.x, p1.y, p1.x);
      for (let y = p0.y; y <= p1.y; y++) {
        PutPixel(xs[(y - p0.y) | 0], y, color);
      }
    }
  }


  function DrawWireframeTriangle(p0, p1, p2, color) {
    DrawLine(p0, p1, color);
    DrawLine(p1, p2, color);
    DrawLine(p0, p2, color);
  }


  // Converts 2D viewport coordinates to 2D canvas coordinates.
  function ViewportToCanvas(p2d) {
    return new Pt(
      p2d.x * canvas.width / viewport_size,
      p2d.y * canvas.height / viewport_size);
  }


  function ProjectVertex(v) {
    return ViewportToCanvas(new Pt(
      v.x * projection_plane_z / v.z,
      v.y * projection_plane_z / v.z));
  }


  function RenderTriangle(triangle, projected) {
    DrawWireframeTriangle(projected[triangle.v0],
      projected[triangle.v1],
      projected[triangle.v2],
      triangle.color);
  }


  function RenderInstance(instance) {
    let projected = [];
    let model = instance.model;
    for (let i = 0; i < model.vertices.length; i++) {
      projected.push(ProjectVertex(model.vertices[i].add(instance.position)));
    }
    for (let i = 0; i < model.triangles.length; i++) {
      RenderTriangle(model.triangles[i], projected);
    }
  }


  function RenderScene(instances) {
    for (let i = 0; i < instances.length; i++) {
      RenderInstance(instances[i]);
    }
  }


  const vertices = [
    new Vertex(1, 1, 1),
    new Vertex(-1, 1, 1),
    new Vertex(-1, -1, 1),
    new Vertex(1, -1, 1),
    new Vertex(1, 1, -1),
    new Vertex(-1, 1, -1),
    new Vertex(-1, -1, -1),
    new Vertex(1, -1, -1)
  ];

  const RED = new Color(255, 0, 0);
  const GREEN = new Color(0, 255, 0);
  const BLUE = new Color(0, 0, 255);
  const YELLOW = new Color(255, 255, 0);
  const PURPLE = new Color(255, 0, 255);
  const CYAN = new Color(0, 255, 255);

  const triangles = [
    new Triangle(0, 1, 2, RED),
    new Triangle(0, 2, 3, RED),
    new Triangle(4, 0, 3, GREEN),
    new Triangle(4, 3, 7, GREEN),
    new Triangle(5, 4, 7, BLUE),
    new Triangle(5, 7, 6, BLUE),
    new Triangle(1, 5, 6, YELLOW),
    new Triangle(1, 6, 2, YELLOW),
    new Triangle(4, 5, 1, PURPLE),
    new Triangle(4, 1, 0, PURPLE),
    new Triangle(2, 6, 7, CYAN),
    new Triangle(2, 7, 3, CYAN)
  ];

  let cube = new Model(vertices, triangles);

  let instances = [
    new Instance(cube, new Vertex(-1.5, 0, 7)),
    new Instance(cube, new Vertex(1.25, 2, 7.5))
  ];

  function Render() {
    RenderScene(instances);
    UpdateCanvas();
  }

  Render();

</script>
```

## 模型变换

上面描述的场景定义并没有给我们带来很大的灵活性，由于我们只能指定立方体的位置，因此我们可以实例化任意数量的立方体，但它们都将面向同一个方向。一般来说，希望对实例有更多的控制，如指定它们的方位甚至是指定它们的缩放比例。

可以使用3个元素定义模型变换(model transform),分别是缩放因子、模型空间中围绕原点的旋转以及到场景中特定点的平移。

```cpp
instance{
    model = cube
    transform{
        scale = 1.5
        rotation = <45 degrees around the Y axis>
        translation = {1,2,3}
    }
}
```

应用变换的顺序很重要，尤其是平移必须最后完成。这是因为大多数时候我们想要在模型空间中围绕它们的原点旋转和缩放实例，所以我们需要在它们转换到世界空间之前这样做。

下面演示了 围绕原点旋转45度，然后沿z轴平移的效果。先旋转再平移、先平移再旋转的区别。

![应用旋转然后平移](../.gitbook/assets/chapter-15image68.png)

![应用平移然后旋转](../.gitbook/assets/chapter-15image69.png)

严格来说，对于给定一次旋转后跟一次平移的变换，我们可以找到一次平移后跟一次旋转（可能不是围绕原点）的变换达到相同的结果。然而，使用前一种变换要自然得多。

应用旋转缩放平移伪代码：

```cpp
RenderInstance(instance){
    projected = []
    model = instance.model
    for V in model.vertices{
        V' = ApplyTransform(V, instance.transform)
        projected.append(ProjectVertex(V'))
    }
    for T in model.triangles{
        RenderTriangle(T, projected)
    }
}

ApplyTransform(vertex, transform)
{
    scaled = Scale(vertex, transform.scale)
    rotated = Rotate(scaled, transform.rotation)
    translated = Translate(rotated, transform.translation)
    return translated
}
```

## 相机变换

前面讨论了如何将模型实例放置在场景中的不同位置，想象一下，你是一个漂浮在一个完全空白的坐标系中的相机，突然，一个红色的立方体正好出现在你的面前。

![一个红色的立方体出现在相机前](../.gitbook/assets/chapter-15image70.jpg)

1s后，立方体向相机移动了1个单位

![红色立方体朝着相机移动](../.gitbook/assets/chapter-15image71.jpg)

但是这个立方体真的向相机移动了一个单位吗？还是相机向着立方体移动了一个单位？因为根本没有参考点，而且坐标系也不可见，所以无法通过看到的画面内容来判断。
因为在这两种情况下，立方体和相机的相对位置(relative position)是相同的。

![没有坐标系，无法判断是物体移动还是相机移动](../.gitbook/assets/chapter-15image72.png)

![没有坐标系，无法判断是物体旋转了还是相机旋转了](../.gitbook/assets/chapter-15image73.png)

这种“明显以自我为中心”的宇宙观的优势在于，通过将相机固定在原点并指向Z+,可以使用前面推导出的透视投影方程而无须任何修改，相机的坐标系称为相机空间(camera space)。

假设相机也附加了变换，包括平移和旋转，为了从相机的视野渲染场景，需要对场景的每个顶点应用相反的变换。

![把对相机的变换反向作用域物体达到作用于相机的效果](../.gitbook/assets/2024-12-15165138.png)

## 变换矩阵

## 齐次坐标

## 齐次旋转矩阵

## 齐次缩放矩阵

## 齐次平移矩阵

## 齐次投影矩阵

## 齐次视口-画布变换矩阵
