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
    if #match ~= map.width then
      error 'incorrect file format'
    end
    map[#map+1] = {}
    string.gsub(match, '.', function (c)
      table.insert(map[#map], c == '#')
    end)
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
    for x = 1, map.width do
      io.write(map[y][x] and '#' or '-')
    end
    io.write('\n')
  end
end

local function rungame(map, options)
  printmap(map, 0)
  for g = 1, options.generations do
    local newmap = {width = map.width, height = map.height}
    for y = 1, map.height do
      newmap[y] = {}
      for x = 1, map.width do
        local neighbours = 0
        if map[y-1] then
          if map[y-1][x-1] then neighbours = neighbours + 1 end
          if map[y-1][x]   then neighbours = neighbours + 1 end
          if map[y-1][x+1] then neighbours = neighbours + 1 end
        end
        if map[y][x-1] then neighbours = neighbours + 1 end
        if map[y][x+1] then neighbours = neighbours + 1 end
        if map[y+1] then
          if map[y+1][x-1] then neighbours = neighbours + 1 end
          if map[y+1][x]   then neighbours = neighbours + 1 end
          if map[y+1][x+1] then neighbours = neighbours + 1 end
        end

        if map[y][x] and neighbours ~= 2 and neighbours ~= 3 then
          newmap[y][x] = false
        elseif not map[y][x] and neighbours == 3 then
          newmap[y][x] = true
        else
          newmap[y][x] = map[y][x]
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

