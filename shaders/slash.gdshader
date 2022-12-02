shader_type canvas_item;

const float PI = 3.1416;

uniform float radius_outer : hint_range(0.0, 0.5) = 0.5;

uniform float _phi_tail : hint_range(-6.283, 6.283) = 0.0;
uniform float _phi_head : hint_range(-6.283, 6.283) = 1.0;

uniform bool clockwise = true;

uniform float width_tail : hint_range(0.0, 0.5) = 0.1;
uniform float width_head : hint_range(0.0, 0.5) = 0.2;


vec2 get_nearest(vec2 x, vec2 stride) {
    return round(x / stride) * stride;    
}


float map_to_first_round(float x) {
    
    if (x < -PI) {
        
        while (x < -PI) {
            x += 2.0 * PI;
        }
        return x;
        
    } else if (x > PI) {
        
        while (x > PI) {
            x -= 2.0 * PI;
        }
        return x;
        
    } else {
        
        return x;
        
    }
}


void fragment() {
    
    vec2 uv_center = UV - 0.5;
    uv_center = get_nearest(uv_center, TEXTURE_PIXEL_SIZE);
    
    float r = length(uv_center);
    float phi = atan(uv_center.y, uv_center.x);
    
    float phi_ratio = 0.0;
    bool counterclockwise = !clockwise;
    
    float phi_tail = map_to_first_round(_phi_tail);
    float phi_head = map_to_first_round(_phi_head);
    
    // | -> head | ... | tail -> |
    if (clockwise && (phi_tail > phi_head)) {
        if (phi < phi_head) {
            phi_ratio = (phi - (phi_tail - 2.0 * PI)) / (phi_head - (phi_tail - 2.0 * PI));
        } else if (phi > phi_tail) {
            phi_ratio = (phi - phi_tail) / (phi_head + 2.0 * PI - phi_tail);
        }   
    }
    
    // | <- tail | ... | head <- |
    else if (counterclockwise && (phi_tail < phi_head)) {
        if (phi < phi_tail) {
            phi_ratio = (phi - phi_tail) / (phi_head - 2.0 * PI - phi_tail);
        } else if (phi > phi_head) {
            phi_ratio = (phi - (phi_tail + 2.0 * PI)) / (phi_head - (phi_tail + 2.0 * PI));
        }   
    }
    
    else {
        phi_ratio = (phi - phi_tail) / (phi_head - phi_tail);
    }
        
    float width = 0.0; 
    if ((0.0 < phi_ratio) && (phi_ratio < 1.0)) {
        // phi_ratio = pow(phi_ratio, 2.0);
        width = width_tail * (1.0 - phi_ratio) + width_head * phi_ratio;
    }
    
    bool draw = (radius_outer - width < r) && (r < radius_outer);
    COLOR = vec4(vec3(1), float(draw));
    
}