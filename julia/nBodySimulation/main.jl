include("FileFunctions.jl")
using LinearAlgebra
using Plots
using DataStructures
using StaticArrays
using Dates

import Base.+
import Base.*
import Base./

#set some variables
dt = 10^-4 #time step, dt
simTime = 10^2 # simulation time
plotResults = false; # disable for faster computation
timeDimensionMode = false # if enabled, the plot will be 3d with time being the 3rd dimension

writesPerComputation = 10^5 # write n times per whole computation
plotsPerComputation = 10^2  # plot n times per whole computation
logsPerComputation = 10^3 # print progress n times per whole computation
gravConstant = 4π^2; # AU^3 MO^-1 Year^-2, found this number on an old quora post, G = 4π^2 AU^3 MO^-1 Year^-2
writes=0

outputFolderLocation = "outputFiles"

B = zeros((6, 5))
B[2, 1] = 1 / 4
B[3, 1] = 3 / 32
B[3, 2] = 9 / 32
B[4, 1] = 1932 / 2197
B[4, 2] = -7200 / 2197
B[4, 3] = 7296 / 2197
B[5, 1] = 439 / 216
B[5, 2] = -8
B[5, 3] = 3680 / 513
B[5, 4] = -845 / 4104
B[6, 1] = -8 / 27
B[6, 2] = 2
B[6, 3] = -3544 / 2565
B[6, 4] = 1859 / 4104
B[6, 5] = -11 / 40

CH = [
  16 / 135,
  0,
  6656 / 12825,
  28561 / 56430,
  -9 / 50,
  2 / 55
]


mutable struct bodyState_s
  mass::Float64
  position::Vector{Float64}
  velocity::Vector{Float64}
end
currentBodiesState::Vector{bodyState_s} = [];

mutable struct deltaState_s
  velocity::Vector{Float64} # change in position
  acceleration::Vector{Float64} # change in velocity
end

#makeNBodyInitialConditionsFile(2)

readJsonFile()




NOfBodies = size(currentBodiesState, 1)

createOutputFiles()

if plotResults
  s = scatter(aspect_ratio=:equal)
  if timeDimensionMode
    s = scatter3d()
  end
end


#Takes in current state of bodies, outputs the delta state -> how much the simulation changes
function deltaFunction(bodiesState_local::Vector{bodyState_s})::Vector{deltaState_s}
  forces::Array{Vector{Float64}} = []

  for i in range(1, NOfBodies)
    for j in range(1, NOfBodies)
      iszero(i - j) && continue # if i=j i and j is the same body, we skip it

      distanceVec::Vector{Float64} = bodiesState_local[j].position - bodiesState_local[i].position

      distance::Float64 = LinearAlgebra.norm(distanceVec) # get the distance as a Scalar, pretty much just distance = √(d.x^2 + d.y^2)


      direction::Vector{Float64} = LinearAlgebra.normalize(distanceVec) # get the direction Vector. direction * scalar = original Vector

      force::Float64 = 0
      # check if distance > 0, if distance = 0, we would be dividing by zero, computers dont like that (smh)
      if distance != 0
        force = gravConstant * bodiesState_local[i].mass * bodiesState_local[j].mass / distance^2
      end

      if abs(i - j) > 1
        # if its not the first time we are computing force for this body
        forces[i] = forces[i] + direction * force
      else
        # if its the first time we are computing force for this body
        push!(forces, direction * force)
      end

    end
  end
  result::Vector{deltaState_s} = []
  for i in range(1, NOfBodies)
    push!(result, deltaState_s(bodiesState_local[i].velocity, forces[i] / bodiesState_local[i].mass))
  end
  return result
end

function addBodiesStates(bs1::Vector{bodyState_s}, bs2::Vector{bodyState_s})::Vector{bodyState_s}
  bs::Vector{bodyState_s} = []
  for i in range(1, NOfBodies)

    push!(bs, bodyState_s(bs1[i].mass, bs1[i].position + bs2[i].position, bs1[i].velocity + bs2[i].velocity))
  end


  return bs
end

function printProgressToConsole(loop)

  timeElapsed = time() - startTime
  timeElapsedStr=""
  completed = round(loop / (simTime / dt), digits=10)
  approxTimeLeft = timeElapsed / completed - timeElapsed
  approxTimeLeftStr = ""
  approxTimeComplete = now() + Second(round(approxTimeLeft))


  if approxTimeLeft > 100 && approxTimeLeft < 4000
    approxTimeLeftStr = string(round(approxTimeLeft / 60, digits=2)) * " min"
  elseif approxTimeLeft >= 4000
    approxTimeLeftStr = string(round(approxTimeLeft / 3600, digits=2)) * " hr"
  else
    approxTimeLeftStr = string(round(approxTimeLeft, digits=2)) * " s"
  end
  if timeElapsed > 100 && timeElapsed < 4000
    timeElapsedStr = string(round(timeElapsed / 60, digits=2)) * " min"
  elseif timeElapsed >= 4000
    timeElapsedStr = string(round(timeElapsed / 3600, digits=2)) * " hr"
  else
    timeElapsedStr = string(round(timeElapsed, digits=2)) * " s"
  end
  println("
    completed: $(round(completed * 100, digits=1))% = $completed,
    time elapsed: $timeElapsedStr, approximate time left: $approxTimeLeftStr,
    now: $(Dates.format(now(), "HH:MM:SS, dd")); done: $(Dates.format(approxTimeComplete, "HH:MM:SS, dd"))
  ")
end

function multiplyKWithTime(k::Vector{deltaState_s}, t::Float64)::Vector{bodyState_s}
  bs::Vector{bodyState_s} = []
  for i in range(1, NOfBodies)
    push!(bs, bodyState_s(0.0, k[i].velocity * t, k[i].acceleration * t))

  end
  bs
end

function RKF45()
  k1 = multiplyKWithTime(deltaFunction(currentBodiesState), dt)
  k2 = multiplyKWithTime(deltaFunction(currentBodiesState + k1 * B[2, 1]), dt)
  k3 = multiplyKWithTime(deltaFunction(currentBodiesState + k1 * B[3, 1] + k2 * B[3, 2]), dt)
  k4 = multiplyKWithTime(deltaFunction(currentBodiesState + k1 * B[4, 1] + k2 * B[4, 2] + k3 * B[4, 3]), dt)
  k5 = multiplyKWithTime(deltaFunction(currentBodiesState + k1 * B[5, 1] + k2 * B[5, 2] + k3 * B[5, 3] + k4 * B[5, 4]), dt)
  k6 = multiplyKWithTime(deltaFunction(currentBodiesState + k1 * B[6, 1] + k2 * B[6, 2] + k3 * B[6, 3] + k4 * B[6, 4] + k5 * B[6, 5]), dt)

 
  
  ans = CH[1] * k1 + CH[2] * k2 + CH[3] * k3 + CH[4] * k4 + CH[5] * k5 + CH[6] * k6

  

  for x in range(1, NOfBodies)

    currentBodiesState[x] += ans[x]
    


  end
end

function RK4()
  k::Vector{Vector{bodyState_s}} = [[], [], [], []]
  k[1] = multiplyKWithTime(deltaFunction(currentBodiesState), dt)
  k[2] = multiplyKWithTime(deltaFunction(currentBodiesState + k[1]/2.0), dt)
  k[3] = multiplyKWithTime(deltaFunction(currentBodiesState + k[2]/2.0), dt)
  k[4] = multiplyKWithTime(deltaFunction(currentBodiesState + k[3]), dt)
  ans::Vector{bodyState_s} = (k[1] + 2.0 * (k[2] + k[3]) + k[4]) / 6.0

  for x in range(1, NOfBodies)
    

    currentBodiesState[x] += ans[x]

    

  end
end

function +(ds1::deltaState_s, ds2::deltaState_s)
  deltaState_s(ds1.velocity + ds2.velocity, ds1.acceleration + ds2.acceleration)
end


function /(x::bodyState_s, y::Float64)
  bodyState_s(x.mass, x.position/y, x.velocity/y)
end
function *(x::deltaState_s, y::Float64)
  deltaState_s(x.velocity * y, x.acceleration * y)
end
function *(x::Float64, y::deltaState_s)
  deltaState_s(y.velocity * x, y.acceleration * x)
end
function *(x::bodyState_s, y::Float64)
  bodyState_s(x.mass, x.position * y, x.velocity * y)
end
function +(x::bodyState_s, y::bodyState_s)
  bodyState_s(x.mass, x.position + y.position, x.velocity + y.velocity) 
end
function *(x::Float64, y::bodyState_s)
  bodyState_s(y.mass, y.position * x, y.velocity * x)
end


startTime = time()
startTimeFormated = Dates.format(now(), "HH:MM:SS, dd")
println(startTimeFormated);
println("Program Started")

for i in range(1, simTime / dt)

  
  RK4()


  if iszero(round(i % (simTime / dt / writesPerComputation), digits=8))
    global writes+=1
    
    writePositionsToFiles()
  end

  if iszero(round(i % (simTime / dt / plotsPerComputation), digits=8))
    if plotResults
      if timeDimensionMode
        scatter3d!([currentBodiesState[1].position[1]], [currentBodiesState[1].position[2]], [i], color="green", markersize=1, legend=false)
        scatter3d!([currentBodiesState[2].position[1]], [currentBodiesState[2].position[2]], [i], color="red", markersize=1, legend=false)
      else
        scatter!([currentBodiesState[1].position[1]], [currentBodiesState[1].position[2]], color="green", markersize=1, legend=false)
        scatter!([currentBodiesState[2].position[1]], [currentBodiesState[2].position[2]], color="red", markersize=1, legend=false)
      end
    end
   
    
  end



  if iszero(round(i % (simTime / dt / logsPerComputation), digits=8))

    printProgressToConsole(i)
  end

end

timeElapsed = time() - startTime
teo="placeholder"
if timeElapsed > 3600
  teo=join([string(round(timeElapsed/3600, digits=4)), " hours"])
elseif timeElapsed > 65
  teo=join([string(round(timeElapsed/60, digits=4)), " minutes"])
else
  teo=join([string(round(timeElapsed, digits=4)), " seconds"])
end


println("start Time: $startTimeFormated")
println("end Time: $(Dates.format(now(), "HH:MM:SS, dd"))")
println("time elapsed: $teo")
println("wrote $writes lines to $NOfBodies files")

if plotResults
  display(s)

  println("press enter to end")

  readline()

  println("Are you sure?")

  readline()
end
