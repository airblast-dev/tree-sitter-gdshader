// taken from https://godotshaders.com/shader/outline-posterization-color-palette-and-dithering/
// CC0 license
shader_type spatial;
// <- keyword
//          ^^^^^^^ keyword
//                 ^ punctuation.delimiter
render_mode unshaded;
// <- keyword
//                  ^ punctuation.delimiter

global uniform vec2 POSITION: thing;
// <- keyword
//     ^^^^^^^ keyword
//             ^^^^ type.builtin
//                  ^^^^^^^^ constant
//                            ^^^^^ attribute

instance uniform vec2 POSITION: thing;
// <- keyword
//       ^^^^^^^ keyword
//               ^^^^ type.builtin
//                    ^^^^^^^^ constant
//                              ^^^^^ attribute

uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture, filter_linear_mipmap;
// <- keyword
//      ^^^^^^^^^ type.builtin
//                ^^^^^^^^^^^^^ constant
//                                ^^^^^^^^^^^^ attribute
//                                              ^^^^^^^^^^^^^^^^^^ attribute
//                                                                  ^ attribute
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_nearest;
// <- keyword
//      ^^^^^^^^^ type.builtin
//                ^^^^^^^^^^^^^^ constant
//                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ attribute
//                                                                ^^^^^^^^^^^^^^^^^^ attribute
uniform sampler2D SCREEN_TEXTURE : source_color, hint_screen_texture, repeat_disable, filter_nearest;
// <- keyword
//      ^^^^^^^^^ type.builtin
//                ^^^^^^^^^^^^^^ constant
//                                 ^^^^^^^^^^^^ attribute
//                                               ^^^^^^^^^^^^^^^^^^^ attribute
//                                                                    ^^^^^^^^^^^^^^ attribute
//                                                                                    ^^^^^^^^^^^^^^ attribute
uniform float zNear = 0.05;
// <- keyword
//      ^^^^^ type.builtin
//            ^^^^^ variable
//                  ^ operator
//                    ^^^^ number
uniform float zFar = 100;
// <- keyword
//      ^^^^^ type.builtin
//            ^^^^ variable
//                 ^ operator
//                   ^^^ number

uniform bool enable_outline = false;
// <- keyword
//      ^^^^ type.builtin
//           ^^^^^^^^^^^^^^ variable
//                          ^ operator
//                            ^^^^^ boolean
uniform vec3 outline_color : source_color = vec3(0.0,0.0,0.0);
// <- keyword
//      ^^^^ type.builtin
//           ^^^^^^^^^^^^^ variable
//                           ^^^^^^^^^^^^ attribute
//                                        ^ operator
//                                          ^^^^ type.builtin
//                                               ^^^ number
//                                                   ^^^ number
//                                                       ^^^ number
uniform float outline_thickness = 10.0;
// <- keyword
//      ^^^^^ type.builtin
//            ^^^^^^^^^^^^^^^^^ variable
//                              ^ operator
//                                ^^^^ number

uniform bool enable_color_limit = true;
// <- keyword
//      ^^^^ type.builtin
//           ^^^^^^^^^^^^^^^^^^ variable
//                              ^ operator
//                                ^^^^ boolean
uniform int color_levels : hint_range(2, 32) = 8;
// <- keyword
//      ^^^ type.builtin
//          ^^^^^^^^^^^^ variable
//                         ^^^^^^^^^^ attribute
//                                    ^ number
//                                       ^^ number
//                                           ^ operator
//                                             ^ number
uniform bool enable_color_palette = true;
//<- keyword
//      ^^^^ type.builtin
//           ^^^^^^^^^^^^^^^^^^^^ variable
//                                ^ operator
//                                  ^^^^ boolean
uniform vec4 color1  : source_color  = vec4(1.0,0.925,0.839,1.0);			//#bfbfbf - avg = 0.749
//<- keyword
//      ^^^^ type.builtin
//           ^^^^^^ variable
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                     ^ type.builtin
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color2  : source_color  = vec4(1.0,0.831,0.639,1.0);			//#71a668 - avg = 0.501
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color3  : source_color  = vec4(1.0,0.667,0.369,1.0);			//#6a86b0 - avg = 0.543
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color4  : source_color  = vec4(0.816,0.506,0.349,1.0);			//#76568f - avg = 0.453
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color5  : source_color  = vec4(0.553,0.412,0.478,1.0);			//#ab5c74 - avg = 0.496
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color6  : source_color  = vec4(0.329,0.306,0.408,1.0);			//#b89d6e - avg = 0.589
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color7  : source_color  = vec4(0.125,0.236,0.337,1.0);			//#4c5b6b - avg = 0.358
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^ number
//                                              ^^^^^ number
//                                                    ^^^^^ number
//                                                          ^^^ number
uniform vec4 color8  : source_color  = vec4(0.05,0.169,0.271,1.0);			//#2e253d - avg = 0.188
// <- keyword
//      ^^^^ type.builtin
//                     ^^^^^^^^^^^^ attribute
//                                   ^ operator
//                                          ^^^^ number
//                                               ^^^^^ number
//                                                     ^^^^^ number
//                                                           ^^^ number

// In order, dark -> light
// 8,7,4,5,2,3,6,1
uniform bool enable_dithering = true;
// <- keyword
//      ^^^^ type.builtin
//           ^^^^^^^^^^^^^^^^ variable
//                            ^ operator
//                              ^^^^ boolean
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;
// <- keyword
//      ^^^^^ type.builtin
//            ^^^^^^^^^^^^^^^ variable
//                              ^^^^^^^^^^ attribute
//                                         ^^^ number
//                                              ^^^ number
//                                                   ^ operator
//                                                     ^^^ number

//This shader uses the sobel-feldman operation to create outlines for any object on the screen.
//It utilizes the depth and normal buffers to create the most accurate or complete outlines.

// We do this using two kernels Gx and Gy (1) , which are convolved (adding each element to its local neighbors)
// with the input data (2). First with the depth buffer (3), and then with the normal buffer (4).
// These results are then handled in the fragment shader (5), to be output to the player's screen.


// (1)
// Gx and Gy are two "kernels" that contain horizontal (x) and vertical(y) derivative approximations.
const mat3 Gx = mat3(
// <- keyword
//    ^^^^ type.builtin
//         ^^ variable
//            ^ operator
//              ^^^^ type.builtin
				vec3(-1,-2,-1),
				//<- type.builtin
				//   ^^ number
				//      ^^ number
				//         ^^ number
				vec3(0, 0, 0),
				//<- type.builtin
				//   ^ number
				//      ^ number
				//         ^ number
				vec3(1, 2, 1)
				//<- type.builtin
				//   ^ number
				//      ^ number
				//         ^ number
);
const mat3 Gy = mat3(
				vec3(-1,0,1),
				vec3(-2,0,2),
				vec3(-1,0,1)
);

// (1) 
// Calculating the scaled depth buffer, converting the depth from clip space, into view space.
float depth(sampler2D depth_texture, vec2 screen_uv, mat4 inv_proj_mat, in vec3 vertex)
// <- type.builtin
//    ^^^^^ function
//          ^^^^^^^^^ type.builtin
//                    ^^^^^^^^^^^^^ variable.parameter
//                                   ^^^^ type.builtin
//                                        ^^^^^^^^^ variable.parameter
//                                                   ^^^^ type.builtin
//                                                        ^^^^^^^^^^^^ variable.parameter
//                                                                      ^^ keyword
//                                                                         ^^^^ type.builtin
//                                                                              ^^^^^^ variable.parameter
{
	float depth_raw = texture(depth_texture, screen_uv)[0];
	// <- type.builtin
	//    ^^^^^^^^^ variable
	//                ^^^^^^^ function.builtin
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth_raw);
	//<- type.builtin
	//   ^^^ variable
	//       ^ operator
	//         ^^^^ type.builtin
	//                        ^ operator
	//                          ^^^ number
	//                              ^ operator
	//                                ^^^ number
	//                                     ^^^^^ ^^^ variable
	vec4 view_space = inv_proj_mat * vec4(ndc,1.0);
	//<- type.builtin
	//   ^ variable
	//              ^ operator
	//                             ^ operator
	//                               ^^^^ type.builtin
	//                                    ^^^ variable
	//                                        ^^^ number
	view_space.z /= view_space.w;
	//<- variable
	//        ^ punctuation.delimiter
	//         ^ property
	//           ^^ operator
	//              ^ variable
	//                        ^ punctuation.delimiter
	//                         ^ property
	float linear_depth = view_space.z;
	//<- type.builtin
	//    ^^^ variable
	//                   ^^^ variable
	//                              ^ property
	float scaled_depth = (zFar-zNear)/(zNear + linear_depth * (zNear-zFar));
	// <- type.builtin
	//    ^ variable
	//                 ^ operator
	//                    ^ variable
	//                        ^ operator
	//                         ^ variable
	//                               ^ operator
	//                                 ^ variable
	//                                       ^ operator
	//                                         ^ variable
	//                                                      ^ operator
	//                                                         ^ variable
	//                                                              ^ operator
	//                                                               ^ variable
	return scaled_depth;
	//<- keyword
	//     ^ variable
}

// (2)
// Next, we perform the sobel operation on the scaled_depth value.
// This is half of the process for the outlines, giving us most of the outline effect,
// but we'll also be performing the sobel operation on the normal values, for a more "complete"
// looking outline.
float sobel_depth(in vec2 uv, in vec2 offset, in vec3 vertex, mat4 inv_proj_mat)
// <- type.builtin
//    ^^^^^^^^^^^ function
//                ^^ keyword
//                   ^^^^ type.builtin
//                        ^^ variable.parameter
//                            ^^ keyword
//                               ^^^^ type.builtin
//                                    ^^^^^^ variable.parameter
//                                            ^^ keyword
//                                               ^^^^ type.builtin
//                                                    ^^^^^^ variable.parameter
//                                                           ^^^^ type.builtin
//                                                                ^^^^^^^^^^^^^ variable.parameter
{
	//used for multiplying the results of the depth calculation with
	//the Gx and Gy kernels;
	float xSobDepth = 0.0;
	float ySobDepth = 0.0;

	for (int row = 0; row < 3; row++)
	{
		for (int col = 0; col < 3; col++)
		{
			float depth = depth(DEPTH_TEXTURE, uv + offset * vec2(float(col-1),float(row-1)),inv_proj_mat,vertex);
			xSobDepth += Gx[row][col] * depth;
			ySobDepth += Gy[row][col] * depth;
		}
	}


	return sqrt(pow(xSobDepth,2.0) + pow(ySobDepth,2.0));
}

// (4)
// Calculates relative luminance for a pixel's color using the "weighted vector"
// which is a shade of green that approximates the way light is percieved by humans.
float luminance(vec3 color)
{
	const vec3 weight = vec3(0.2125, 0.7154, 0.0721);
	return dot(weight,color);
}

// Using the luminance, we can find even more edges by finding the major luminance differences
// found within the normal buffer. Using the calculated luminance value, we'll perform the sobel operation again,
// providing us with what will become our "full" edge detected results.
float sobel_normal(in vec2 uv, in vec2 offset)
{
	float xSobNormal = 0.0;
	float ySobNormal = 0.0;

	for (int row = 0; row < 3; row++)
	{
		for (int col = 0; col < 3; col++)
		{
			//vec2 uv = SCREEN_UV + vec2(float(col-1),float(row-1)) * SCREEN_PIXEL_SIZE;
			float lumi = luminance(texture(NORMAL_TEXTURE, uv + offset * vec2(float(col-1),float(row-1))).rgb);
			xSobNormal += Gx[row][col] * lumi;
			ySobNormal += Gy[row][col] * lumi;
		}
	}


	return sqrt(pow(xSobNormal,2.0) + pow(ySobNormal,2.0));
}


// Color posterization, or quantization, is handled by passing in the red, green and blue values of a color one at a time
// into the function. the "value" in this instance, would be one of those rgb values, from the color vec3/vec4.
// Meanwhile, the "levels" integer is the number of colors we want to "allow" within the color posterization.
// This function will take the input rgb float value, multiply it by the number of levels, and then round it to the nearest int.
// Then, lastly, it'll be divided again by the number of color levels, to bring it back to an rgb float value that falls between 0.0 and 1.0
// while still being affected by the rounding. 

//There are likely better ways to handle this, but this was my first implementation and it worked well enough for this project.
float posterize(float val, int levels)
{
	return round(val * float(levels)) / float(levels);
}


// The dithering is fairly heavy handed, and is applied directly to the screen-space quad. This results
// in a full-screen "darkening" of sorts, instead of just being applied to the actual materials of objects 
// to "fix" the color banding from the posterization, like it probably should be.
// Because of that, there are definitely better ways to implement this, and I'd definitely re-do it in the future.
float dither(vec2 position, float brightness)
{
	int x = int(mod(position.x, 4.0));
	int y = int(mod(position.y, 4.0));
	int index = x + y * 4;

	float dithering[16] = float[](
		0.0,0.5,0.125,0.625,
		0.75,0.25,0.875,0.375,
		0.1875,0.6875,0.0625,0.5625,
		0.9375,0.4375,1.0,0.8125
	);
	float threshold = dithering[index];
	return brightness < threshold ? 0.0 : 1.0;
}

void vertex() {
	//Positions the post-processing quad in front of the camera
	POSITION = vec4(VERTEX.xy,1.0,1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 palette[8];
		palette[0] = color1.rgb;
		palette[1] = color2.rgb;
		palette[2] = color3.rgb;
		palette[3] = color4.rgb;
		palette[4] = color5.rgb;
		palette[5] = color6.rgb;
		palette[6] = color7.rgb;
		palette[7] = color8.rgb;

	vec3 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

	vec3 final_color = screen_color;

	if(enable_color_limit)
	{
		// Posterizes the fragment's color using the limit value set in "color_levels"
		final_color = vec3(posterize(final_color.r,color_levels),posterize(final_color.g,color_levels),posterize(final_color.b,color_levels));
		
	}

	if (enable_color_palette)
	{
		vec3 difference = final_color - palette[0];
		float dist = dot(difference,difference);

		float closest_distance = dist;
		vec3 closest_color = palette[0];

		// Iterates through the color palette array, comparing the "distance" of the
		// source color, against the current palette color. It finds the palette
		// color with the shortest distance from the source color, and applies it to
		// the "final_color", of the current fragment. This "replaces" the original image's
		// colors with the best-fit from the palette.
		for( int i = 0; i < palette.length(); i++)
		{
			difference = final_color - palette[i];
			dist = dot(difference,difference);

			if(dist<closest_distance)
			{
				closest_distance = dist;
				closest_color = palette[i];
			}
		}
		final_color = closest_color;
	}

	// Applies the dithering to the screen, based on the dither strength.
	if(enable_dithering)
	{
		float brightness = dot(final_color, vec3(0.3,0.59,0.11));
		brightness += dither_strength * (dither(FRAGCOORD.xy, brightness) -0.5);
		final_color *= (1.0 + dither_strength * (dither(FRAGCOORD.xy, brightness) -0.5));
	}
	
	if(enable_outline)
	{
		vec2 offset = outline_thickness / VIEWPORT_SIZE;
		vec2 uv = SCREEN_UV;

		//Calculates the scaled depth for the current fragment
		float depth = depth(DEPTH_TEXTURE, uv, INV_PROJECTION_MATRIX,VERTEX);
	
		vec3 pixel_color = texture(SCREEN_TEXTURE, uv).rgb;
		
		//Performs the sobel operation on both the depth and normal
		float edge_depth = sobel_depth(uv, offset, VERTEX, INV_PROJECTION_MATRIX);
		float edge_normal = sobel_normal(uv, offset);
		
		//Using the results, we utilie smoothstep to combine the results of the 
		// depth and normal calculations, to get our "final" outline calculations.
		float outline = smoothstep(0.0,1.0,10.0 * edge_depth + edge_normal);

		//These final outline calculations are then combined with the outline color, to create the
		// actual finished outlines, and are mixed with the final color.
		final_color = mix(final_color, outline_color, outline);
	}
	
	
	//The combined results of all of the effects are then output to the quad's albedo, displaying them on the screen.
	ALBEDO = final_color;
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}

