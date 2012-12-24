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
    for x = 1, map.width do
      for y = 1, map.width do

      end
    end
    printmap(map, g)
  end
end

local options = getoptions()
local map = loadmap(options)
rungame(map, options)

