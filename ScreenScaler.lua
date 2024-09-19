--uses maid64 by adetkto https://github.com/adekto/maid64/blob/master/maid64.lua
--uses pixel art anti-alias shader made by RNavega https://github.com/RNavega/PixelArt-Antialias-Love2D/blob/master/main.lua

--aa scaler thing
local aaShader = nil
local useShader = true
pixelSize = nil
angle = 0 --if canvas ever rotates this is used
SCALE = {2, 2} --not to be set directly, controls the resolution scale of the effect
angleSin = nil

--the shader itself
local aaPointSampleShaderCode = [[
// The default size, in pixels, of the antialiasing filter. The default is 1.0 for a mathematically perfect
// antialias. But if you want, you can increase this to 1.5, 2.0, 3.0 and such to force a bigger antialias zone
// than normal, using more screen pixels.
const float SMOOTH_SIZE = 1.0;

const float _HALF_SMOOTH = SMOOTH_SIZE / 2.0;

// The raw width and height of the image in pixels.
uniform highp vec2 imageSize;

// The horizontal and vertical scales used when drawing the image, making an image texel take several screen pixels.
uniform highp vec2 texelScale;

// The angle of rotation that the image was drawn with.
// Only used with the boundary antialiasing. This uniform can be removed if you don't need it.
uniform highp float angle;

// If you're using 3D meshes then you can remove this vertex shader code.
// This is only needed when you want the outside of Image drawables (AKA sprites) to also be
// antialiased. This is done by expanding the image mesh, without changing how it looks.
#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    // Map the UVs in this vertex from range [0, +1] to range [-1, +1].
    vec2 corner_direction = (VertexTexCoord.xy - 0.5) / 0.5;

    // Move the vertex by its UV direction to "expand" the quad mesh.
    float angleCos = cos(angle);
    float angleSin = sin(angle);
    mat2 sprite_rotation = mat2(angleCos, angleSin, -angleSin, angleCos); // Column-major.
    vertex_position.xy += sprite_rotation * (corner_direction * _HALF_SMOOTH);

    // The amount in UV units that the vertices were shifted.
    vec2 pixel_uv_size = _HALF_SMOOTH / imageSize;

    // Offset the texture coordinates so the contents of the quad remain the same.
    VaryingTexCoord.xy += pixel_uv_size * corner_direction / texelScale;

    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // The antialiasing is done with the UV coordinates of the pixel, sampling the
    // center of texels when the screen pixel is entirely contained in a texel, and
    // sampling an interpolation between the center of two neighboring texels when
    // the screen pixel is between the edge of those texels.

    // When modifying this, be aware of the three types of units being used:
    // A) Normalized UV space: [0, 0] -> [1, 1]
    // B) Image space: [0,0] -> [image_width, image_height]
    // C) "Screen pixel" space: [0, 0] -> [image_width*texelScale, image_height*texelScale]

    vec2 texel = texture_coords * imageSize;
    vec2 nearest_edge = floor(texel + 0.5);
    vec2 dist = (texel - nearest_edge) * texelScale;

    vec2 factor = clamp(dist/vec2(_HALF_SMOOTH), -1.0, 1.0);
    vec2 antialiased_uv = (nearest_edge + 0.5 * factor) / imageSize;

    // Optional boundary antialiasing, making pixels transparent at the edges of the image.
    // This works in screen pixels, getting the distance from the center of the image to the
    // pixel being processed, and then calculating a value when that distance becomes larger than
    // half the image size minus _HALF_SMOOTH. The alpha is the unit complement (1 - x) of this value.

    /* Original code:
     * vec2 center_offset = abs(texture_coords - vec2(0.5));
     * vec2 halfSize = imageSize/2.0 * texelScale;
     * vec2 refSize = halfSize - _HALF_SMOOTH;
     * dist = (temp*imageSize*texelScale - refSize) / SMOOTH_SIZE;
     */
    vec2 center_offset = abs(texture_coords - vec2(0.5));
    dist = ((center_offset - 0.5) * imageSize * texelScale + _HALF_SMOOTH) / SMOOTH_SIZE;
    dist = clamp(dist, 0.0, 1.0);
    float alpha = 1.0 - max(dist.x, dist.y);
    vec4 texturecolor = vec4(Texel(tex, antialiased_uv).rgb, alpha);

    // Without boundary-antialiasing you can just use this line. Make sure to also remove the vertex shader
    // function at the top.
    //vec4 texturecolor = Texel(tex, antialiased_uv);

    return texturecolor * color;
}
#endif

#ifdef FRAGMENT
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // The antialiasing is done with the UV coordinates of the pixel, sampling the
    // center of texels when the screen pixel is entirely contained in a texel, and
    // sampling an interpolation between the center of two neighboring texels when
    // the screen pixel is between the edge of those texels.

    // When modifying this, be aware of the three types of units being used:
    // A) Normalized UV space: [0, 0] -> [1, 1]
    // B) Image space: [0,0] -> [image_width, image_height]
    // C) "Screen pixel" space: [0, 0] -> [image_width*texelScale, image_height*texelScale]

    vec2 texel = texture_coords * imageSize;
    vec2 nearest_edge = floor(texel + 0.5);
    vec2 dist = (texel - nearest_edge) * texelScale;

    vec2 factor = clamp(dist/vec2(_HALF_SMOOTH), -1.0, 1.0);
    vec2 antialiased_uv = (nearest_edge + 0.5 * factor) / imageSize;

    // Optional boundary antialiasing, making pixels transparent at the edges of the image.
    // This works in screen pixels, getting the distance from the center of the image to the
    // pixel being processed, and then calculating a value when that distance becomes larger than
    // half the image size minus _HALF_SMOOTH. The alpha is the unit complement (1 - x) of this value.

    /* Original code:
     * vec2 center_offset = abs(texture_coords - vec2(0.5));
     * vec2 halfSize = imageSize/2.0 * texelScale;
     * vec2 refSize = halfSize - _HALF_SMOOTH;
     * dist = (temp*imageSize*texelScale - refSize) / SMOOTH_SIZE;
     */
    vec2 center_offset = abs(texture_coords - vec2(0.5));
    dist = ((center_offset - 0.5) * imageSize * texelScale + _HALF_SMOOTH) / SMOOTH_SIZE;
    dist = clamp(dist, 0.0, 1.0);
    float alpha = 1.0 - max(dist.x, dist.y);
    vec4 texturecolor = vec4(Texel(tex, antialiased_uv).rgb, alpha);

    // Without boundary-antialiasing you can just use this line. Make sure to also remove the vertex shader
    // function at the top.
    //vec4 texturecolor = Texel(tex, antialiased_uv);

    return texturecolor * color;
}
#endif
]]

function maid64(xSize, ySize)
    ScreenSizeX = xSize-- or 32
    ScreenSizeY = ySize-- or 24
    ScreenScalerX = love.graphics.getWidth() / ScreenSizeX
    ScreenScalerY = love.graphics.getHeight() / ScreenSizeY
    GameX = love.graphics.getWidth()/2-(ScreenScalerX*(ScreenSizeX/2))
    GameY = love.graphics.getHeight()/2-(ScreenScalerY*(ScreenSizeY/2))
    GameCanvas = love.graphics.newCanvas(ScreenSizeX, ScreenSizeY, {format = "normal"})
    GameCanvas:setFilter("nearest","nearest")
    aaShader = love.graphics.newShader(aaPointSampleShaderCode)
    useShader = true
    pixelSize = {GameCanvas:getPixelWidth(),GameCanvas:getPixelHeight()}
end

function maid_draw()
    ScreenSizeX = levelwidth * tilelengthx-- or 32
    ScreenSizeY = levelheight * tilelengthy-- or 24
	love.graphics.setCanvas(GameCanvas)
	love.graphics.clear()
	maid64_draw()
	love.graphics.setCanvas()
    --love.graphics.draw(GameCanvas, GameX,GameY,angleSin,ScreenScalerX,ScreenScalerY)

    angleSin = math.sin(angle) * 0.25
    if useShader == true then
        love.graphics.setShader(aaShader)
        --GameCanvas:setFilter('linear', 'linear')
        aaShader:send('imageSize', pixelSize)
        aaShader:send('texelScale', SCALE)
        aaShader:send('angle', angleSin)
        GameCanvas:setFilter("linear","linear")
    end
    -- love.graphics.draw(GameCanvas, 0, 0, angleSin, SCALE[1] * 2.5 , SCALE[2] * 2, 0, 0)
    love.graphics.draw(GameCanvas, GameX,GameY,angleSin,ScreenScalerX,ScreenScalerY)
    
    SCALE = {ScreenScalerX, ScreenScalerY}
---@diagnostic disable-next-line: param-type-mismatch
    love.graphics.setShader(nil)
---@diagnostic disable-next-line: param-type-mismatch
    love.graphics.setCanvas(nil)
    love.graphics.origin()
end

function love.resize(w, h)
    -- if h < w then
        
    -- -- elseif h > w then
    -- --     ScreenScalerX = w / ScreenSizeX
    -- end
    ScreenScalerX = w / ScreenSizeX
    ScreenScalerY = h / ScreenSizeY
    GameX = w/2-(ScreenScalerX*(ScreenSizeX/2))
    GameY = h/2-(ScreenScalerY*(ScreenSizeY/2))
    xDeadZone = math.ceil(love.graphics.getWidth() / mouseDeadzone)
    yDeadZone = math.ceil(love.graphics.getHeight() / mouseDeadzone)
end

