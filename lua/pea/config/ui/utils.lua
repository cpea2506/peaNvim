local M = {}

local function calculate_float(value, max_value)
	local _, p = math.modf(value)

	if value and p ~= 0 then
		return math.min(max_value, value * max_value)
	else
		return value
	end
end

local function calculate_width(values, max_value, aggregator, limit)
	local result = limit

	if type(values) == "table" then
		for _, v in ipairs(values) do
			result = aggregator(result, calculate_float(v, max_value))
		end

		return result
	else
		result = aggregator(result, calculate_float(values, max_value))
	end

	return result
end

local function calculate_dimension(desired_size, size, min_size, max_size, total_size)
	local result = calculate_float(size, total_size)
	local min_val = calculate_width(min_size, total_size, math.max, 1)
	local max_val = calculate_width(max_size, total_size, math.min, total_size)

	if not result then
		if not desired_size then
			result = (min_val + max_val) / 2
		else
			result = calculate_float(desired_size, total_size)
		end
	end

	result = math.min(result, max_val)
	result = math.max(result, min_val)

	return math.floor(result)
end

M.get_max_strwidth = function(lines)
	local max = 0

	for _, line in ipairs(lines) do
		max = math.max(max, vim.api.nvim_strwidth(line))
	end

	return max
end

M.calculate_width = function(desired_width, width, min_width, max_width, winid)
	return calculate_dimension(desired_width, width, min_width, max_width, vim.api.nvim_win_get_width(winid or 0))
end

return M
