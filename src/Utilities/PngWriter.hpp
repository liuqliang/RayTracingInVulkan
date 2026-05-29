#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace Utilities
{
	void WritePng(const std::string& path, uint32_t width, uint32_t height, const std::vector<std::uint8_t>& rgbaPixels);
}
