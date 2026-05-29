#include "Texture.hpp"
#include "Utilities/StbImage.hpp"
#include "Utilities/Exception.hpp"
#include <chrono>
#include <cstdlib>
#include <iostream>

namespace Assets {

Texture Texture::LoadTexture(const std::string& filename, const Vulkan::SamplerConfig& samplerConfig)
{
	std::cout << "- loading '" << filename << "'... " << std::flush;
	const auto timer = std::chrono::high_resolution_clock::now();

	// Load the texture in normal host memory.
	int width, height, channels;
	const auto pixels = stbi_load(filename.c_str(), &width, &height, &channels, STBI_rgb_alpha);

	if (!pixels)
	{
		Throw(std::runtime_error("failed to load texture image '" + filename + "'"));
	}

	const auto elapsed = std::chrono::duration<float, std::chrono::seconds::period>(std::chrono::high_resolution_clock::now() - timer).count();
	std::cout << "(" << width << " x " << height << " x " << channels << ") ";
	std::cout << elapsed << "s" << std::endl;

	return Texture(width, height, channels, pixels);
}

Texture Texture::SolidColor(const unsigned char r, const unsigned char g, const unsigned char b, const unsigned char a)
{
	auto* pixels = static_cast<unsigned char*>(std::malloc(4));
	if (!pixels)
	{
		Throw(std::bad_alloc());
	}

	pixels[0] = r;
	pixels[1] = g;
	pixels[2] = b;
	pixels[3] = a;

	return Texture(1, 1, 4, pixels);
}

Texture::Texture(int width, int height, int channels, unsigned char* const pixels) :
	width_(width),
	height_(height),
	channels_(channels),
	pixels_(pixels, stbi_image_free)
{
}
	
}
