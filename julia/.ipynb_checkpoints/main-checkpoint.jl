include("JSON_Read&WriteFunctions.jl")
using JSON
using DataStructures

#set some variables
timeDelta = 10^-4 #time step, dt
simTime = 10^2 # simulation time

outputCompression = 10^2 # only every n files are written to output files to save space
logsPerComputation = 10^2 # print progress n times per whole computation

gravConstant = 39.478417604; # AU^3 MO^-1 Year^-2, found this number on an old quora post, G = 4pi^2


outputFolderLocation = "../outputFiles"
#initialize / define body structure
struct Body
  mass::Float64
  position::Vector{Float64}
  velocity::Vector{Float64}
  acceleration::Vector{Float64}
end
bodies::Vector{Body} = []




makeNBodyInitialConditionsFile(3)

readJsonFile()

println(bodies)
