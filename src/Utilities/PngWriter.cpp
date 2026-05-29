#include "PngWriter.hpp"
#include "Exception.hpp"
#include <png.h>
#include <cstdio>

namespace Utilities
{
	void WritePng(const std::string& path, const uint32_t width, const uint32_t height, const std::vector<std::uint8_t>& rgbaPixels)
	{
		if (rgbaPixels.size() != static_cast<size_t>(width) * static_cast<size_t>(height) * 4)
		{
			Throw(std::runtime_error("invalid RGBA buffer size for PNG output"));
		}

		FILE* file = std::fopen(path.c_str(), "wb");
		if (file == nullptr)
		{
			Throw(std::runtime_error("failed to open PNG output file"));
		}

		png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
		if (png == nullptr)
		{
			std::fclose(file);
			Throw(std::runtime_error("failed to create PNG write struct"));
		}

		png_infop info = png_create_info_struct(png);
		if (info == nullptr)
		{
			png_destroy_write_struct(&png, nullptr);
			std::fclose(file);
			Throw(std::runtime_error("failed to create PNG info struct"));
		}

		if (setjmp(png_jmpbuf(png)) != 0)
		{
			png_destroy_write_struct(&png, &info);
			std::fclose(file);
			Throw(std::runtime_error("failed while writing PNG output"));
		}

		png_init_io(png, file);
		png_set_IHDR(
			png,
			info,
			width,
			height,
			8,
			PNG_COLOR_TYPE_RGBA,
			PNG_INTERLACE_NONE,
			PNG_COMPRESSION_TYPE_DEFAULT,
			PNG_FILTER_TYPE_DEFAULT);

		png_write_info(png, info);

		std::vector<png_bytep> rows(height);
		for (uint32_t y = 0; y < height; ++y)
		{
			rows[y] = const_cast<png_bytep>(rgbaPixels.data() + static_cast<size_t>(y) * width * 4);
		}

		png_write_image(png, rows.data());
		png_write_end(png, nullptr);
		png_destroy_write_struct(&png, &info);
		std::fclose(file);
	}
}
