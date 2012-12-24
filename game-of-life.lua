local function getoptions()
  local cli = require 'cliargs'

  cli:add_argument('INPUT', 'path to the input file')
  local defaultgenerations = '10'
  cli:add_option('-g GENS', 'number of generations', defaultgenerations)
  local args = cli:parse_args()

  if not args then
    os.exit()
  end

  return {
    filepath = args['INPUT'],
    generations = tonumber(args['g']) or tonumber(defaultgenerations)
  }
end

local function loadmap(options)
  local file = assert(io.open(options.filepath))

  local map = {
    width = file:read('*n'),
    height = file:read('*n')
  }

  if map.width == nil or map.height == nil then
    error 'incorrect file format'
  end

  string.gsub(file:read('*a'), '[#-]+', function(match)
    table.insert(map, match)
    if #match ~= map.width then
      error 'incorrect file format'
    end
  end)

  if #map ~= map.height then
    error 'incorrect file format'
  end

  file:close()
  return map
end

local function printmap(map, generation)
  print('Generation #' .. generation)
  for y = 1, map.height do
    print(map[y])
  end
end

local function rungame(map, options)
  printmap(map, 0)
  for g = 1, options.generations do
    local newmap = {width = map.width, height = map.height}
    for y = 1, map.height do
      newmap[y] = ''
      for x = 1, map.width do
        local neighbours = 0
        if map[y-1] then
          if map[y-1]:sub(x-1, x-1) == '#' then neighbours = neighbours + 1 end
          if map[y-1]:sub(x, x)     == '#' then neighbours = neighbours + 1 end
          if map[y-1]:sub(x+1, x+1) == '#' then neighbours = neighbours + 1 end
        end
        if map[y]:sub(x-1, x-1) == '#' then neighbours = neighbours + 1 end
        if map[y]:sub(x+1, x+1) == '#' then neighbours = neighbours + 1 end
        if map[y+1] then
          if map[y+1]:sub(x-1, x-1) == '#' then neighbours = neighbours + 1 end
          if map[y+1]:sub(x, x)     == '#' then neighbours = neighbours + 1 end
          if map[y+1]:sub(x+1, x+1) == '#' then neighbours = neighbours + 1 end
        end

        if map[y]:sub(x, x) == '#' and neighbours ~= 2 and neighbours ~= 3 then
          newmap[y] = newmap[y] .. '-'
        elseif map[y]:sub(x, x) == '-' and neighbours == 3 then
          newmap[y] = newmap[y] .. '#'
        else
          newmap[y] = newmap[y] .. map[y]:sub(x, x)
        end
      end
    end
    map = newmap
    printmap(map, g)
  end
end

local options = getoptions()
local map = loadmap(options)
rungame(map, options)

