varying vec4 vPosition;
varying float vSnoise;
varying float hillHeight;

float cold_desert_slope = 30 / 22;
float woodland_slope = 120 / 22;
float seasonal_forest = 220 / 22;
float temparature_rain_forest = 320 / 22;
float subtropical_desert = 60 / 13;
float tropical_seasonal_forest = 65 / 13;
float tropical_rain_forest = 100 / 13;

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float simplex(vec2 v){
    const vec4 C = vec4(0.211324865405187, 0.366025403784439,
    -0.577350269189626, 0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod(i, 289.0);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
    + i.x + vec3(0.0, i1.x, 1.0));
    vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy),
    dot(x12.zw, x12.zw)), 0.0);
    m = m*m;
    m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}



int check_secondPhase(float temperature, float precipitation){
    float a=precipitation/22;
    if (a<=cold_desert_slope)return 3;
    else if (a>cold_desert_slope&&a<=woodland_slope)return 4;
    else if (a>woodland_slope&&a<=seasonal_forest)return 5;
    else if (a>seasonal_forest&&a<=temparature_rain_forest)return 6;
    return 1;
}
int check_thirdPhase(float temperature, float precipitation){
    float a=precipitation-temperature*(60/13);
    if (a<61.538)return 7;
    else if (a>=61.538&&a<118.461)return 8;
    return 9;
}
int getBiome(float temperature, float precipitation){

    if (temperature< -2.00)return 1;
    else if (temperature> -2.00&&temperature<=7.00)return 2;
    else if (temperature>7.00&&temperature<18.00)return check_secondPhase(temperature, precipitation);
    else if (temperature>=18.00&&temperature<33.00) return check_thirdPhase(temperature, precipitation);
    return 8;

}


float getColor(float color){
    return 0.0;
}
vec3 getHighColor(float temp){
    return vec3(1.0*temp, 0.5*temp, 0.3*temp);
}
int check_secondPhase(float temparature, float precipitation){
    float a=precipitation/22;
    if (a<=cold_desert_slope)return 3;
    else if (a>cold_desert_slope&&a<=woodland_slope)return 4;
    else if (a>woodland_slope&&a<=seasonal_forest)return 5;
    else if (a>seasonal_forest&&a<=temparature_rain_forest)return 6;
    return 1;
}
int check_thirdPhase(float temparature, float precipitation){
    float a=precipitation-temparature*(60/13);
    if (a<61.538)return 7;
    else if (a>=61.538&&a<118.461)return 8;
    return 9;
}
int getBiome(float temperature, float precipitation){

    if (temparature< -2.00)return 1;
    else if (temparature> -2&&temparature<=7)return 2;
    else if (temparature>7.00&&temparature<18.00)return check_secondPhase(temparature, precipitation);
    else if (temparature>=18.00&&temparature<33) return check_thirdPhase(temparature, precipitation);
    return 8;

}
void main(){

    vec3 highColor = vec3(1.0, 0.5, 0.3);
    vec3 lowColor = vec3(0.3, 0.3, .5);

    float temperature = getTemperature(0.0);
    float precipitation = getPrecipitation(temperature);


    float temperatureStrength = temperature*.025;
    float precipitationStrength = precipitation*.0025;

    float mixStrength = precipitationStrength;

    vec3 color = mix(lowColor, highColor, mixStrength);


    gl_FragColor = vec4(color, .8);
}