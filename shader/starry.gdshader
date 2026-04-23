shader_type canvas_item;

uniform float star_density : hint_range(0.01, 30.0) = 25.0;
uniform float star_brightness : hint_range(0.1, 5.0) = 1.2;
uniform float star_size : hint_range(0.01, 1.0) = 0.05;          // 新增：星星像素半径
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

float hash(vec3 p) {
    p  = fract(p * 0.1031);
    p += dot(p, p.zyx + 31.32);
    return fract((p.x + p.y) * p.z);
}

void fragment() {
    // === 沿用方案一的方向向量投影，保持星空球形分布感 ===
    vec2 centered = UV - 0.5;
    vec2 aspect = vec2(1.0, 1.0 / SCREEN_PIXEL_SIZE.x * SCREEN_PIXEL_SIZE.y);
    centered *= aspect;
    vec3 dir = normalize(vec3(centered, 1.0));
    
    // 网格划分，与原版一致
    float density_factor = 200.0 * star_density;
    vec3 grid_pos = dir * density_factor;
    vec3 grid_floor = floor(grid_pos);
    vec3 grid_fract = fract(grid_pos);
    
    vec3 stars = vec3(0.0);
    
    // 遍历相邻网格（保留原方案一的基本结构，但增加了邻居遍历）
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            for (int z = -1; z <= 1; z++) {
                vec3 neighbor = vec3(float(x), float(y), float(z));
                vec3 cell = grid_floor + neighbor;
                
                float noise = hash(cell);
                // 阈值与原方案一保持一致
                if (noise > 0.998) {
                    // 生成星星在网格内的随机位置（0~1）
                    vec3 star_pos = vec3(
                        hash(cell + 1.0),
                        hash(cell + 2.0),
                        hash(cell + 3.0)
                    );
                    
                    // 当前像素在网格局部坐标中距离星星中心的偏移（3D 网格空间）
                    vec3 delta = grid_fract - neighbor - star_pos;
                    
                    // === 关键改动：将 3D 网格空间的距离转换为屏幕像素距离 ===
                    // 首先，将 delta 近似映射到 UV 空间中的偏移量
                    // dir 是归一化的方向向量，在单位球面上移动 delta / density_factor
                    // 简化计算：直接用 delta 长度除以 density_factor，再乘以屏幕像素尺度因子
                    float dist_in_uv = length(delta) / density_factor;
                    
                    // 获取画布纹理一个像素对应的 UV 长度
                    float pixel_uv_size = length(TEXTURE_PIXEL_SIZE);
                    
                    // 转换为实际像素距离
                    float pixel_dist = dist_in_uv / pixel_uv_size;
                    
                    float radius = star_size;
                    float glow = 1.0 - smoothstep(0.0, radius, pixel_dist);
                    
                    if (glow > 0.01) {
                        float intensity = pow(hash(cell + 0.5), 10.0) * star_brightness;
                        stars += vec3(intensity * glow);
                    }
                }
            }
        }
    }
    
    COLOR = background_color + vec4(stars, 1.0);
}