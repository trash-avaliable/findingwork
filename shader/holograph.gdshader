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
// 四角透明渐变（新增）
// ============================================
uniform float corner_fade_strength : hint_range(0.0, 1.0) = 0.6;  // 渐变强度
uniform float corner_fade_size : hint_range(0.0, 1.0) = 0.25;     // 渐变范围（值越小透明区域越靠近角落）

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
    float scanline_val = sin((aspect_uv.y * scanline_density + TIME * scanline_speed) * 3.14159 * 2.0);
    scanline_val = smoothstep(-scanline_thickness, scanline_thickness, scanline_val);
    float scanline_effect = mix(0.65, 1.0, scanline_val);
    
    // 4. 网格效果 (基于世界坐标的网格，滚动起来)
    vec2 grid_uv = aspect_uv * grid_density;
    grid_uv.y += TIME * grid_speed; // 垂直滚动
    
    vec2 grid_line = abs(fract(grid_uv - 0.5) - 0.5);
    vec2 grid_dist = grid_line / fwidth(grid_uv); // 抗锯齿宽度自适应
    
    float grid_x = 1.0 - smoothstep(0.0, grid_thickness, grid_dist.x);
    float grid_y = 1.0 - smoothstep(0.0, grid_thickness, grid_dist.y);
    float grid_mask = clamp(grid_x + grid_y, 0.0, 1.0);
    
    // 5. 故障效果 (UV 偏移 + 随机色块)
    float glitch_seed = floor(TIME * glitch_speed);
    float glitch_rnd = random(vec2(glitch_seed, floor(UV.y * 15.0)));
    
    vec2 glitch_uv = UV;
    float glitch_trigger = step(0.92, glitch_rnd) * glitch_strength;
    if (glitch_trigger > 0.0) {
        float offset_x = (random(vec2(glitch_seed, 0.5)) - 0.5) * 0.08 * glitch_strength;
        glitch_uv.x += offset_x;
        
        float offset_r = (random(vec2(glitch_seed, 0.8)) - 0.5) * 0.02;
        float offset_b = (random(vec2(glitch_seed, 0.2)) - 0.5) * 0.02;
        vec4 color_r = texture(TEXTURE, glitch_uv + vec2(offset_r, 0.0));
        vec4 color_g = texture(TEXTURE, glitch_uv);
        vec4 color_b = texture(TEXTURE, glitch_uv + vec2(offset_b, 0.0));
        
        sprite_color.r = mix(sprite_color.r, color_r.r, glitch_trigger);
        sprite_color.g = mix(sprite_color.g, color_g.g, glitch_trigger);
        sprite_color.b = mix(sprite_color.b, color_b.b, glitch_trigger);
    }
    
    // 6. 边缘光模拟
    float edge = 1.0 - sprite_color.a;
    edge = pow(edge, 1.5) * edge_glow;
    
    // 7. 合成最终颜色
    float gray = dot(sprite_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 colored = gray * hologram_color.rgb * brightness;
    
    colored *= scanline_effect;
    
    vec3 grid_color = hologram_color.rgb * 1.5;
    colored += grid_mask * grid_color * 0.4;
    
    colored += vec3(edge * hologram_color.rgb * 1.2);
    
    // 8. 计算基础透明度（原有逻辑）
    float final_alpha = alpha * (0.9 + 0.2 * scanline_val + 0.5 * grid_mask + 0.3 * edge);
    
    // ============================================
    // 新增：四角透明渐变
    // ============================================
    // 计算UV到四个边的最小距离，角落处距离最小
    vec2 corner_uv = min(UV, 1.0 - UV);
    float corner_dist = min(corner_uv.x, corner_uv.y);
    // 根据 corner_fade_size 控制渐变范围，强度由 corner_fade_strength 控制
    float corner_fade = smoothstep(0.0, corner_fade_size, corner_dist);
    corner_fade = mix(1.0, corner_fade, corner_fade_strength);
    
    // 应用渐变因子到透明度
    final_alpha *= corner_fade;
    final_alpha = clamp(final_alpha, 0.0, 1.0);
    
    COLOR = vec4(colored, final_alpha);
}