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
    generations = tonumber(args['g']) or defaultgenerations
  }
end

local function loadmap(options)
  local file = assert(io.open(options.filepath))
  print(options.generations)
  file:close()
end

local options = getoptions()
local map = loadmap(options)

