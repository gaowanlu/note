# 填充三角形

## 绘制线框三角形

直接画三条线段就可以实现

```html
DrawWireframeTriangle(P0, P1, P2, color)
{
	DrawLine(P0, P1, color);
	DrawLine(P1, P2, color);
	DrawLine(P2, P0, color);
}
```

## 绘制填充三角形

可以将三角形视为一组水平线段的集合，这些线段一起绘制时看起来像一个三角形，从而实现绘制填充三角形的目的。

![使用水平线段绘制一个填充三角形](../.gitbook/assets/chapter-12image6.png)

效果图

![使用水平线段绘制一个填充三角形效果图](../.gitbook/assets/fhskdfkjs_84934_dkjc_23e23.png)

源码样例

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>光栅化 填充三角形</title>
</head>

<div class="centered">
    <canvas id="canvas" width=600 height=600 style="border: 1px grey solid"></canvas>
</div>

<script>
    "use strict";

    let canvas = document.getElementById("canvas");
    let canvas_context = canvas.getContext("2d");
    let canvas_buffer = canvas_context.getImageData(0, 0, canvas.width, canvas.height);

    // A color.
    function Color(r, g, b) {
        return { r, g, b };
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

    // A Point.
    function Pt(x, y) {
        return { x, y };
    }

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


    function DrawFilledTriangle(p0, p1, p2, color) {
        // Sort the points from bottom to top.
        if (p1.y < p0.y) { let swap = p0; p0 = p1; p1 = swap; }
        if (p2.y < p0.y) { let swap = p0; p0 = p2; p2 = swap; }
        if (p2.y < p1.y) { let swap = p1; p1 = p2; p2 = swap; }
        // 到此p0.y < p1.y < p2.y

        // Compute X coordinates of the edges.
        let x01 = Interpolate(p0.y, p0.x, p1.y, p1.x);
        let x12 = Interpolate(p1.y, p1.x, p2.y, p2.x);
        let x02 = Interpolate(p0.y, p0.x, p2.y, p2.x);

        // Merge the two short sides.
        x01.pop();
        let x012 = x01.concat(x12);

        // Determine which is left and which is right.
        let x_left, x_right;
        let m = (x02.length / 2) | 0;
        if (x02[m] < x012[m]) {
            x_left = x02;
            x_right = x012;
        } else {
            x_left = x012;
            x_right = x02;
        }

        // Draw horizontal segments.
        for (let y = p0.y; y <= p2.y; y++) {
            for (let x = x_left[y - p0.y]; x <= x_right[y - p0.y]; x++) {
                PutPixel(x, y, color);
            }
        }
    }

    // 三角形三个点
    let p0 = new Pt(-200, -250);
    let p1 = new Pt(200, 50);
    let p2 = new Pt(20, 250);

    // 画填充三角形
    DrawFilledTriangle(p0, p1, p2, new Color(0, 255, 0));
    // 画三角形轮廓
    DrawWireframeTriangle(p0, p1, p2, new Color(0, 0, 0));

    UpdateCanvas();

</script>

</html>
```
