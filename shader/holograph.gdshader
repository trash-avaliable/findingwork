shader_type canvas_item;

// ============================================
// 基础颜色与发光
// ============================================
uniform vec4 hologram_color : source_color = vec4(0.2, 0.9, 0.7, 1.0); // 卫戍协议青绿色
uniform float brightness : hint_range(0.0, 3.0) = 1.2;
uniform float edge_glow : hint_range(0.0, 1.0) = 0.6;

// ============================================
// 扫描线效果 (CRT 风格)
// ============================================
uniform float scanline_speed : hint_range(-5.0, 5.0) = 1.5;
uniform float scanline_density : hint_range(1.0, 200.0) = 60.0;
uniform float scanline_thickness : hint_range(0.1, 1.0) = 0.4;

// ============================================
// 网格效果 (全息投影感)
// ============================================
uniform float grid_density : hint_range(1.0, 100.0) = 12.0;
uniform float grid_thickness : hint_range(0.01, 0.5) = 0.08;
uniform float grid_speed : hint_range(-5.0, 5.0) = 0.8;

// ============================================
// 故障效果 (随机位移与噪声)
// ============================================
uniform float glitch_strength : hint_range(0.0, 1.0) = 0.25;
uniform float glitch_speed : hint_range(0.1, 5.0) = 2.0;

// ============================================
// 辅助函数：生成简单的随机噪声
// ============================================
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // 1. 获取原始精灵颜色
    vec4 sprite_color = texture(TEXTURE, UV);
    float alpha = sprite_color.a;
    
    // 如果像素完全透明，直接丢弃
    if (alpha < 0.01) {
        COLOR = vec4(0.0);
    }

    // 2. 构建用于效果计算的 UV (保持宽高比，避免网格拉伸)
    vec2 aspect_uv = UV;
    aspect_uv.x *= TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y; // 修正宽高比
    
    // 3. 动态扫描线 (垂直滚动)
    //    使用 sin 函数生成平滑的明暗条纹，更接近 CRT 的磷光余晖感
    float scanline_val = sin((aspect_uv.y * scanline_density + TIME * scanline_speed) * 3.14159 * 2.0);
    scanline_val = smoothstep(-scanline_thickness, scanline_thickness, scanline_val);
    //    混合一个基础亮度，让暗部不至于全黑
    float scanline_effect = mix(0.65, 1.0, scanline_val);
    
    // 4. 网格效果 (基于世界坐标的网格，滚动起来)
    //    网格分为水平和垂直两条线
    vec2 grid_uv = aspect_uv * grid_density;
    grid_uv.y += TIME * grid_speed; // 垂直滚动
    
    vec2 grid_line = abs(fract(grid_uv - 0.5) - 0.5);
    vec2 grid_dist = grid_line / fwidth(grid_uv); // 抗锯齿宽度自适应
    
    //    计算水平和垂直线的强度 (使用 smoothstep 绘制细线)
    float grid_x = 1.0 - smoothstep(0.0, grid_thickness, grid_dist.x);
    float grid_y = 1.0 - smoothstep(0.0, grid_thickness, grid_dist.y);
    float grid_mask = clamp(grid_x + grid_y, 0.0, 1.0);
    
    // 5. 故障效果 (UV 偏移 + 随机色块)
    //    利用 TIME 和随机函数生成一个动态的故障遮罩
    float glitch_seed = floor(TIME * glitch_speed);
    float glitch_rnd = random(vec2(glitch_seed, floor(UV.y * 15.0)));
    
    //    当随机值大于阈值时，对 UV 施加水平偏移
    vec2 glitch_uv = UV;
    float glitch_trigger = step(0.92, glitch_rnd) * glitch_strength;
    if (glitch_trigger > 0.0) {
        // 偏移量随机，并随时间快速变化
        float offset_x = (random(vec2(glitch_seed, 0.5)) - 0.5) * 0.08 * glitch_strength;
        glitch_uv.x += offset_x;
        
        // 同时模拟 RGB 通道分离 (轻微)
        float offset_r = (random(vec2(glitch_seed, 0.8)) - 0.5) * 0.02;
        float offset_b = (random(vec2(glitch_seed, 0.2)) - 0.5) * 0.02;
        vec4 color_r = texture(TEXTURE, glitch_uv + vec2(offset_r, 0.0));
        vec4 color_g = texture(TEXTURE, glitch_uv);
        vec4 color_b = texture(TEXTURE, glitch_uv + vec2(offset_b, 0.0));
        
        // 混合故障颜色 (只对受影响的像素生效)
        sprite_color.r = mix(sprite_color.r, color_r.r, glitch_trigger);
        sprite_color.g = mix(sprite_color.g, color_g.g, glitch_trigger);
        sprite_color.b = mix(sprite_color.b, color_b.b, glitch_trigger);
    }
    
    // 6. 边缘光模拟 (基于透明度边缘，简单粗暴但有效)
    //    通过采样周边像素的 alpha 差异来估计边缘，此处简化：
    //    直接利用原图亮度来增强边缘感
    float edge = 1.0 - sprite_color.a; // 接近透明区域视为边缘
    edge = pow(edge, 1.5) * edge_glow;
    
    // 7. 合成最终颜色
    //    首先将原图转为灰度，然后乘以全息颜色，实现单色化科技感
    float gray = dot(sprite_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 colored = gray * hologram_color.rgb * brightness;
    
    //    应用扫描线明暗
    colored *= scanline_effect;
    
    //    叠加网格 (网格本身带一点发光色)
    vec3 grid_color = hologram_color.rgb * 1.5;
    colored += grid_mask * grid_color * 0.4;
    
    //    叠加边缘发光
    colored += vec3(edge * hologram_color.rgb * 1.2);
    
    //    处理透明度：原图透明度 + 网格与边缘的增强
    float final_alpha = alpha * (0.9 + 0.2 * scanline_val + 0.5 * grid_mask + 0.3 * edge);
    final_alpha = clamp(final_alpha, 0.0, 1.0);
    
    COLOR = vec4(colored, final_alpha);
}